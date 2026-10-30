---
name: install-rules
description: Installs or updates the plugin's rules in .claude/rules/agent-plugin-charter/ — asks which ones, and keeps the project's settings such as language and ADR directory across updates
disable-model-invocation: true
argument-hint: "[rule ...] [language]"
---

Install the rule files this plugin ships into the project, so Claude Code loads
them natively at every session start — subagents included.

Source: every file in `${CLAUDE_PLUGIN_ROOT}/rules/`.
Target: `.claude/rules/agent-plugin-charter/<same name>` at the root of the project this
session runs in. Claude Code reads `.claude/rules/` recursively, so the subdirectory keeps
these files apart from the project's own rules without changing how they load.

## Arguments

Arguments: $ARGUMENTS

Both are optional, in any order:

- **Rules** — a word that matches a source file name without `.md`, such as
  `adrs`. The named rules are the chosen ones; the question which to install is
  skipped. A word that matches no rule and is not a language is reported, not
  guessed at.
- **Language** — any other word, such as `German`. It is the `<LANGUAGE>` value
  for every chosen rule, overriding the value a copy holds. Rules are written in
  English, so the value is the language's English name: `Deutsch` becomes
  `German`.

Without arguments, everything is asked as described below.

## Settings

A rule may carry settings the project chooses, written as `<UPPERCASE_NAME>`:

- `<LANGUAGE>` — the language the rule's prose is written in. No default: offer
  the language most of the project's prose is in.
- `<ADR_DIRECTORY>` — where the ADRs live. Default `docs/decisions`, common
  alternative `docs/adr`.
- `<HANDBOOK_DIRECTORY>` — where the handbook pages live. Default `docs/handbook`,
  common alternative `docs/guide`.
- `<MOCKUP_DIRECTORY>` — where design mockups live. Default `docs/mockups`,
  common alternative `design/mockups`.

A setting is chosen once. The project's existing copy of a rule holds the values
it was installed with — read them from the place the placeholder sits in the
source. An update keeps them without asking again. Ask only for a setting the
copy holds no value for: on a first install, or when a new version brings a new
one. Each rule gets its own answers; a handbook in one language and specs in
another is fine.

## Take stock

For each source file, check its target and sort it into one of three states:

- **not installed** — no target file
- **up to date** — the target equals the source with its settings filled in
- **differs** — an older version, the project's own edits, or both

Show the list in one short table: the rule's heading (its first line), the
state, the settings it holds, and — read from the rule itself — what it
presumes, such as a tool or a practice the project must already have.
Up-to-date rules need nothing further.

Then look the other way: a file in `.claude/rules/agent-plugin-charter/` with no
source of the same name is **no longer shipped** — the plugin renamed or dropped
that rule, and the file keeps loading until it goes. List each one in the table
with its heading. Only that directory is looked at; files elsewhere under
`.claude/rules/` belong to the project.

## Ask

When rules were passed as arguments, they are the chosen ones; skip to the
settings below.

When at least one installed rule **differs**, first ask with `AskUserQuestion`:
update only the installed rules (recommended), or choose rules. Updating chooses
every rule in state **differs** and nothing else; the rules not installed are
then named in one line, with the command that installs them, not offered.

Otherwise — or when the user chose to pick — ask with `AskUserQuestion`,
multi-select, which of the rules that are not up to date to install or update.
No question carries more than four options, so split the rules across questions
where needed. A rule whose precondition is plainly missing here is still
offered, but say so.

Then ask for each setting the chosen rules still lack — the language counts as
given when passed as an argument — every one of them with
`AskUserQuestion` — up to four settings in one call. Each question needs at
least two options: for a directory, a directory the project already keeps such
files in, then the default marked as such, then the common alternative, up to
four; for a language, the project's language and the next likely one. Typing
another value is always open. A value the user did not answer is never filled
in for them — if the question fails, fix it and ask again.

For each chosen rule in state **differs**, say in a few lines what the plugin's
version would change — added, removed and reworded rules, not a full diff — and
that overwriting drops the project's own edits. Then ask once with
`AskUserQuestion`: overwrite all of them, or decide per rule. Write a rule only
on an explicit yes — the one for all, or its own.

For files **no longer shipped**, ask with `AskUserQuestion`, multi-select, which
to delete. Say what each one covers and, where a renamed rule replaces it, which
one. Delete only what the user picks.

## Write

Write each chosen rule exactly as it ships, with its settings filled in and
nothing else changed: no rewording, no reformatting, no merging of two
versions. Delete the no-longer-shipped files the user picked. Touch nothing else
— no `CLAUDE.md`, no other file under `.claude/`. Then list what was written,
with which settings, and what was deleted. Committing it is the
user's call.
