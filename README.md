# charter

Rules and skills for coding agents — pick the rules your project needs, installed as files you own.

## Why rules you install beat rules a plugin injects

Every project's `CLAUDE.md` tends to end up as a list of good intentions — *write clean code*,
*keep it simple*. The model agrees with all of it and carries on as before, because none of it is a
decision it can act on. The rules here are the other kind: specific enough to change what gets
written.

Getting such rules into a project through a plugin is the hard part. Claude Code plugins can ship
skills, agents and hooks, but no rules — the usual workaround is a `SessionStart` hook that prints
the rule text into every session. We built that first and tested it. It falls short:

- **Subagents never see it.** Hook output reaches the main session only. A reviewer agent checking
  code against the rules has no rules to check against — unless a second hook re-encodes the text
  as JSON, which pulls in `jq` or a script.
- **It needs a Unix shell.** On Windows without Git Bash, hooks run in PowerShell and the rule
  silently never loads.
- **One setting for every project.** Plugin options are stored per user, so a handbook in German
  here and specs in English there is not possible.
- **You can't edit it.** A rule you disagree with stays on, unless you switch off the whole plugin.
- **Updates change your rules unread.** Every plugin update rewrites the rules in every project at
  once.

This plugin takes the other road: `/charter:install-rules` writes the rules into your project as
plain files under `.claude/rules/agent-plugin-charter/`. From there, Claude Code does what it does
with any rule file — and everything above turns around:

- **Native.** Loaded at every session start, in every subagent, again after `/compact`. No hooks,
  no shell, no `jq`; it works on Windows as it does anywhere.
- **Your choice, per project.** You pick which rules a project gets. A project without ADRs never
  carries the ADR rules.
- **Settings per project, per rule.** Language, ADR directory, handbook directory — asked once,
  kept in the file, kept on every update.
- **Yours to edit.** Read what was written and delete what you disagree with. A rule you don't
  actually want is worse than no rule, because the model will follow it.
- **Updates you decide on.** Run `/charter:install-rules` again: it shows what the new version
  changes and overwrites only on your yes.
- **Shared through git.** Commit the files and the whole team works under the same rules — whether
  or not they installed the plugin.
- **Plain Markdown.** Nothing in a rule file is specific to Claude; the text reads the same to any
  coding agent you point at it.

## Installation

```bash
claude plugin marketplace add elnebuloso/agent-plugins
claude plugin install charter@elnebuloso
```

Then, in each project that should follow the rules, run `/charter:install-rules`. It writes them
to `.claude/rules/agent-plugin-charter/`, apart from the project's own rules, and Claude Code loads
them like any other file under `.claude/rules/` — in every session, in subagents, after `/compact`.
Read what it wrote and delete what you disagree with; the files are yours from then on.

Update — auto-update is off for this marketplace unless you switch it on under `/plugin`. A plugin
update never touches a project's rules; run `/charter:install-rules` again to compare and pull them
in:

```bash
claude plugin marketplace update elnebuloso
claude plugin update charter@elnebuloso
```

## Rules

| Rule | For whom | What it covers |
| --- | --- | --- |
| `base.md` | Any project, any language | Working principles, design and git conventions |
| `adrs.md` | Projects that keep architecture decision records | Read the decision record before working in an area, plus when and how to write one |
| `backlog.md` | Users of the Backlog.md CLI | How task entries are written |
| `handbook.md` | Projects with product documentation in the repo | How handbook pages are written |
| `make.md` | Projects driven by a `Makefile` | Run the target instead of the command behind it, and what a command has to earn before it becomes one |
| `superpowers.md` | Users of the Superpowers plugin | File naming, language and standing of specs and plans |

Some rules carry settings the project chooses at the first install: the rules that govern prose —
`adrs`, `backlog`, `handbook`, `superpowers` — ask for the language that prose is written in, one
answer per rule; `adrs` also asks where the ADRs live (default `docs/decisions`), `handbook` where
its pages live (default `docs/handbook`). The answers stay in the installed files, and updates keep
them.

## Skills

### Install rules – `/charter:install-rules`

```text
/charter:install-rules
```

Shows which rules the project has, which are missing and which differ from the plugin's version, and
asks which ones to install or update. A copy that differs is only overwritten after it says what
would change and gets an explicit yes — the project's own edits would be lost. A rule the plugin no
longer ships is listed too, and deleted on request; nothing outside
`.claude/rules/agent-plugin-charter/` is touched.

#### With arguments

Rules and a language can be passed directly:

```text
/charter:install-rules base backlog make German
```

This installs those three rules without asking which ones, with German wherever a rule asks for a
language; settings still missing are asked for.

### Project code review – `/charter:project-code-review`

```text
/charter:project-code-review
```

Reviews the codebase as it stands, not a diff — through the eyes of a senior developer who would
have to take the project over, measured against the project's own rules. Writes one report to
`docs/reviews/`; changes no source file.

### Consolidate ADRs – `/charter:adrs-consolidate`

```text
/charter:adrs-consolidate
```

Merges the ADRs in the directory the installed `adrs` rule names into a set that holds only the
decisions in force today; superseded ones drop out and the old files are deleted. Works in phases
and stops for approval before anything is deleted.

### Update Backlog.md guidelines – `/charter:backlog-guidelines-update`

```text
/charter:backlog-guidelines-update
```

Replaces the Backlog.md guidelines block in every `CLAUDE.md` under a path with the block the
installed `backlog` CLI writes today, and commits each changed file on its own as a `chore`. It
never pushes. A file with uncommitted changes, broken markers or a detached HEAD is left alone, and
so is a symlink. Ends with a table of what happened per file. Without a path, or whenever something
is unclear, it asks instead of guessing.

#### With arguments

```text
/charter:backlog-guidelines-update ~/projects
```
