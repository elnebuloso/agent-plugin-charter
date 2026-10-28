---
name: backlog-guidelines-update
description: Replaces the Backlog.md guidelines block in every CLAUDE.md under a path with the installed backlog version's block, then commits each change — never pushes
argument-hint: "<path>"
disable-model-invocation: true
---

Bring the Backlog.md guidelines block in every `CLAUDE.md` under $ARGUMENTS up
to what the installed `backlog` writes today.

The path is required. With no argument, ask for it with `AskUserQuestion` —
offer the parent directory of the current repository and its parent, and leave
typing another path open. Don't run anything until you have a path.

Then run:

```bash
bash "${CLAUDE_PLUGIN_ROOT}/skills/backlog-guidelines-update/update.sh" <path>
```

The script does all of the work; don't redo any of it by hand. It takes the
block from a throwaway `backlog init`, replaces the block in every `CLAUDE.md`
that has one — no comparison first, a block already current comes out byte for
byte the same — and commits each changed file on its own with
`chore: update Backlog.md agent guidelines to <version>`. It never
pushes, and neither do you. It leaves a file alone when it has uncommitted
changes, its markers are missing or out of order, it is a symlink, or its
repository has a detached HEAD.

Each line of its output is `status<TAB>file<TAB>old -> new version<TAB>detail`,
followed by how many files were already current. Report it as a table — file,
versions, what happened — with committed files first and everything that needs
a hand afterwards (skipped, not committed, failed), each with its reason. Fix
none of those yourself; the report is where it ends.

Whenever you are unsure, ask with `AskUserQuestion` instead of guessing — a
path that doesn't exist or could mean more than one directory, `backlog`
missing, the script exiting with an error, output that doesn't match the format
above. Don't work around it by hand.
