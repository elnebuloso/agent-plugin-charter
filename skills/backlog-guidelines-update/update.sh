#!/usr/bin/env bash
# Replaces the Backlog.md guidelines block in every CLAUDE.md under <path> with
# the block a fresh `backlog init` writes, then commits each change. Never pushes.
# Prints one tab-separated line per touched file: status, file, versions, detail.
set -euo pipefail

search_path=${1:?usage: update.sh <path>}
start_marker='<!-- BACKLOG.MD GUIDELINES START -->'
end_marker='<!-- BACKLOG.MD GUIDELINES END -->'

tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT

# backlog init writes to BACKLOG_CWD when set, which may be a real project.
(cd "$tmp" && BACKLOG_CWD="$tmp" backlog init tmp --defaults --integration-mode cli --agent-instructions claude --no-git >/dev/null)
target_version=$(backlog --version)
sed -n "/$start_marker/,/$end_marker/p" "$tmp/CLAUDE.md" >"$tmp/block"
if [ ! -s "$tmp/block" ]; then
  echo "backlog init wrote no guidelines block - the init flags need fixing" >&2
  exit 1
fi

commit_message="chore: update Backlog.md agent guidelines to $target_version"
unchanged=0

report() {
  printf '%s\t%s\t%s\t%s\n' "$1" "$2" "$3" "$4"
}

version_of() {
  local version
  version=$(grep -o 'backlog.md-instructions-version: [0-9.]*' "$1" | cut -d' ' -f2 | head -n1 || true)
  echo "${version:-none}"
}

# Every START needs an END after it, or replace_block would drop the rest of the file.
markers_balanced() {
  awk -v start="$start_marker" -v end="$end_marker" '
    index($0, start) { if (open) bad = 1; open = 1 }
    index($0, end) { if (!open) bad = 1; open = 0 }
    END { exit bad || open }' "$1"
}

replace_block() {
  awk -v block="$tmp/block" -v start="$start_marker" -v end="$end_marker" '
    index($0, start) { while ((getline line < block) > 0) print line; skipping = 1; next }
    index($0, end) { skipping = 0; next }
    !skipping' "$1"
}

commit() {
  local file=$1 versions=$2 dir name
  dir=$(dirname "$file")
  name=$(basename "$file")

  if ! git -C "$dir" commit -q -m "$commit_message" -- "$name" >"$tmp/error" 2>&1; then
    report "updated, commit failed" "$file" "$versions" "$(tr '\n' ' ' <"$tmp/error")"
    return
  fi
  report "committed" "$file" "$versions" "$(git -C "$dir" rev-parse --short HEAD) on $(git -C "$dir" branch --show-current)"
}

while IFS= read -r -d '' file; do
  grep -qF "$start_marker" "$file" || continue
  dir=$(dirname "$file")
  name=$(basename "$file")
  versions="$(version_of "$file") -> $target_version"

  # A symlink hides its target's uncommitted changes from git diff, and the commit would miss the target.
  if [ -L "$file" ]; then
    report "skipped" "$file" "$versions" "symlink to $(readlink "$file")"
    continue
  fi
  if ! markers_balanced "$file"; then
    report "skipped" "$file" "$versions" "START/END markers missing or out of order"
    continue
  fi
  in_git=false
  if git -C "$dir" ls-files --error-unmatch -- "$name" >/dev/null 2>&1; then
    in_git=true
    # Detached means a rebase, bisect or checkout in progress; a commit there would get lost or mixed in.
    if [ -z "$(git -C "$dir" branch --show-current)" ]; then
      report "skipped" "$file" "$versions" "detached HEAD"
      continue
    fi
    if ! git -C "$dir" diff --quiet HEAD -- "$name"; then
      report "skipped" "$file" "$versions" "uncommitted changes in the file"
      continue
    fi
  fi

  replace_block "$file" >"$tmp/new"
  if cmp -s "$file" "$tmp/new"; then
    unchanged=$((unchanged + 1))
    continue
  fi
  cat "$tmp/new" >"$file"

  if [ "$in_git" = true ]; then
    commit "$file" "$versions"
  else
    report "updated, not committed" "$file" "$versions" "not tracked by git"
  fi
done < <(find "$search_path" -name CLAUDE.md -not -path '*/node_modules/*' -not -path '*/.git/*' -print0 | sort -z)

echo "already at $target_version: $unchanged"
