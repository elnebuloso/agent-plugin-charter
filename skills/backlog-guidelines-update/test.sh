#!/usr/bin/env bash
# Runs update.sh against throwaway repositories with bare remotes, one per case.
# The remotes prove nothing gets pushed.
set -euo pipefail

script_dir=$(realpath "$0")
script_dir=${script_dir%/*}
work=$(mktemp -d)
trap 'rm -rf "$work"' EXIT
export GIT_AUTHOR_NAME=test GIT_AUTHOR_EMAIL=test@example.com GIT_COMMITTER_NAME=test GIT_COMMITTER_EMAIL=test@example.com
export GIT_CONFIG_GLOBAL=/dev/null

(cd "$work" && mkdir init && cd init && backlog init tmp --defaults --integration-mode cli --agent-instructions claude --no-git >/dev/null)
target_version=$(backlog --version)
mkdir "$work/elsewhere"
export BACKLOG_CWD=$work/elsewhere
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
broken_file=$(echo "$old_file" | sed '/GUIDELINES END/d')
make_repo broken "$broken_file"
printf -v no_block_file '# Project\n\nNo Backlog.md here.'
make_repo noblock "$no_block_file"
reversed_block=$(echo "$old_block" | sed '/GUIDELINES END/d')
printf -v reversed_file '# Project\n\n<!-- BACKLOG.MD GUIDELINES END -->\n\n%s' "$reversed_block"
make_repo reversed "$reversed_file"
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
  local file=$work/tree/$1/CLAUDE.md
  echo "$output" | awk -F'\t' -v file="$file" '$2 == file { print $1 }'
}

# Each check reads its value into a variable first: inline substitutions inside quoted
# arguments exceed the span limit of some static security scanners.
expect_status() {
  local actual
  actual=$(status_of "$1")
  [ "$actual" = "$2" ] || fail "$1: status '$actual', expected '$2'"
}

expect_commits() {
  local count
  count=$(git -C "$work/$1" rev-list --count "$2")
  [ "$count" = 1 ] || fail "$1: $count commits, expected 1"
}

expect_target_content() {
  local actual
  actual=$(cat "$work/tree/$1/CLAUDE.md")
  [ "$actual" = "$current_file" ] || fail "$1: content differs from target"
}

expect_status outdated committed
expect_target_content outdated
message=$(git -C "$work/tree/outdated" log -1 --format=%s)
printf -v expected_message 'chore: update Backlog.md agent guidelines to %s' "$target_version"
[ "$message" = "$expected_message" ] || fail "message: $message"
expect_commits remotes/outdated.git main
printf -v expected_versions '1.0.0 -> %s' "$target_version"
echo "$output" | grep -qF -- "$expected_versions" || fail "versions missing in report"

expect_status current ''
expect_commits tree/current HEAD

expect_status dirty skipped
cmp -s "$work/dirty-before" "$work/tree/dirty/CLAUDE.md" || fail "dirty file changed"

expect_status broken skipped
cmp -s "$work/broken-before" "$work/tree/broken/CLAUDE.md" || fail "broken file changed"

expect_status reversed skipped
expect_status detached skipped
expect_commits tree/detached HEAD
expect_status symlink skipped
cmp -s "$work/symlink-before" "$work/tree/symlink/AGENTS.md" || fail "symlink target changed"
elsewhere=$(ls -A "$work/elsewhere")
[ -z "$elsewhere" ] || fail "backlog init wrote to BACKLOG_CWD"

expect_status noblock ''
cmp -s "$work/noblock-before" "$work/tree/noblock/CLAUDE.md" || fail "noblock file changed"
expect_commits tree/noblock HEAD

expect_status plain 'updated, not committed'
expect_target_content plain

printf -v expected_summary 'already at %s: 1' "$target_version"
echo "$output" | grep -qxF -- "$expected_summary" || fail "unchanged count wrong"

echo "OK"
