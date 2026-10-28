#!/usr/bin/env bash
# Runs update.sh against throwaway repositories with bare remotes, one per case.
# The remotes prove nothing gets pushed.
set -euo pipefail

script_dir=$(cd "$(dirname "$0")" && pwd)
work=$(mktemp -d)
trap 'rm -rf "$work"' EXIT
export GIT_AUTHOR_NAME=test GIT_AUTHOR_EMAIL=test@example.com GIT_COMMITTER_NAME=test GIT_COMMITTER_EMAIL=test@example.com
export GIT_CONFIG_GLOBAL=/dev/null

(cd "$work" && mkdir init && cd init && backlog init tmp --defaults --integration-mode cli --agent-instructions claude --no-git >/dev/null)
target_version=$(backlog --version)
mkdir "$work/elsewhere"
export BACKLOG_CWD="$work/elsewhere"
target_block=$(sed -n '/<!-- BACKLOG.MD GUIDELINES START -->/,/<!-- BACKLOG.MD GUIDELINES END -->/p' "$work/init/CLAUDE.md")
old_block=$(echo "$target_block" | sed 's/instructions-version: [0-9.]*/instructions-version: 1.0.0/; /Use the overview/d')
current_file=$(printf '# Project\n\n%s\n\nTrailing notes.\n' "$target_block")
old_file=$(printf '# Project\n\n%s\n\nTrailing notes.\n' "$old_block")

fail() {
  echo "FAIL: $*" >&2
  exit 1
}

make_repo() {
  local name=$1 content=$2
  git init -q --bare -b main "$work/remotes/$name.git"
  git clone -q "$work/remotes/$name.git" "$work/tree/$name" 2>/dev/null
  echo "$content" >"$work/tree/$name/CLAUDE.md"
  git -C "$work/tree/$name" add CLAUDE.md
  git -C "$work/tree/$name" commit -q -m "chore: init"
  git -C "$work/tree/$name" push -q -u origin main 2>/dev/null
}

mkdir -p "$work/remotes" "$work/tree"
make_repo outdated "$old_file"
make_repo current "$current_file"
make_repo dirty "$old_file"
echo "edited by hand" >>"$work/tree/dirty/CLAUDE.md"
make_repo broken "$(echo "$old_file" | sed '/GUIDELINES END/d')"
make_repo noblock "$(printf '# Project\n\nNo Backlog.md here.\n')"
make_repo reversed "$(printf '# Project\n\n<!-- BACKLOG.MD GUIDELINES END -->\n\n%s\n' "$(echo "$old_block" | sed '/GUIDELINES END/d')")"
make_repo detached "$old_file"
git -C "$work/tree/detached" checkout -q --detach
make_repo symlink "$old_file"
git -C "$work/tree/symlink" mv CLAUDE.md AGENTS.md
ln -s AGENTS.md "$work/tree/symlink/CLAUDE.md"
git -C "$work/tree/symlink" add CLAUDE.md
git -C "$work/tree/symlink" commit -q -m "chore: link"
echo "edited by hand" >>"$work/tree/symlink/AGENTS.md"
cp "$work/tree/symlink/AGENTS.md" "$work/symlink-before"
mkdir "$work/tree/plain"
echo "$old_file" >"$work/tree/plain/CLAUDE.md"
cp "$work/tree/broken/CLAUDE.md" "$work/broken-before"
cp "$work/tree/dirty/CLAUDE.md" "$work/dirty-before"
cp "$work/tree/noblock/CLAUDE.md" "$work/noblock-before"

output=$("$script_dir/update.sh" "$work/tree")
echo "$output"

status_of() {
  echo "$output" | awk -F'\t' -v file="$work/tree/$1/CLAUDE.md" '$2 == file { print $1 }'
}

[ "$(status_of outdated)" = "committed" ] || fail "outdated was not committed"
[ "$(cat "$work/tree/outdated/CLAUDE.md")" = "$current_file" ] || fail "outdated content differs from target"
message=$(git -C "$work/tree/outdated" log -1 --format=%s)
[ "$message" = "chore: update Backlog.md agent guidelines to $target_version" ] || fail "message: $message"
[ "$(git -C "$work/remotes/outdated.git" rev-list --count main)" = 1 ] || fail "outdated was pushed"
echo "$output" | grep -qF "1.0.0 -> $target_version" || fail "versions missing in report"

[ -z "$(status_of current)" ] || fail "current was touched"
[ "$(git -C "$work/tree/current" rev-list --count HEAD)" = 1 ] || fail "current got a commit"

[ "$(status_of dirty)" = "skipped" ] || fail "dirty was not skipped"
cmp -s "$work/dirty-before" "$work/tree/dirty/CLAUDE.md" || fail "dirty file changed"

[ "$(status_of broken)" = "skipped" ] || fail "broken was not skipped"
cmp -s "$work/broken-before" "$work/tree/broken/CLAUDE.md" || fail "broken file changed"

[ "$(status_of reversed)" = "skipped" ] || fail "reversed was not skipped"
[ "$(status_of detached)" = "skipped" ] || fail "detached was not skipped"
[ "$(git -C "$work/tree/detached" rev-list --count HEAD)" = 1 ] || fail "detached got a commit"
[ "$(status_of symlink)" = "skipped" ] || fail "symlink was not skipped"
cmp -s "$work/symlink-before" "$work/tree/symlink/AGENTS.md" || fail "symlink target changed"
[ -z "$(ls -A "$work/elsewhere")" ] || fail "backlog init wrote to BACKLOG_CWD"

[ -z "$(status_of noblock)" ] || fail "noblock was reported"
cmp -s "$work/noblock-before" "$work/tree/noblock/CLAUDE.md" || fail "noblock file changed"
[ "$(git -C "$work/tree/noblock" rev-list --count HEAD)" = 1 ] || fail "noblock got a commit"

[ "$(status_of plain)" = "updated, not committed" ] || fail "plain not reported as uncommitted"
[ "$(cat "$work/tree/plain/CLAUDE.md")" = "$current_file" ] || fail "plain content differs from target"

echo "$output" | grep -qx "already at $target_version: 1" || fail "unchanged count wrong"

echo "OK"
