# Agent Guide

This repo is the `coding` plugin: rule files for coding agents plus the skills around them. Rules
reach a project only through `/coding:install-rules`, which writes them as plain files to
`.claude/rules/agent-plugin-coding/`. Nothing here is active while you work in this repo.

## Rules are installed, never injected

- No hooks. Injecting rule text through a `SessionStart` hook was tried and dropped: subagents
  never see it, it needs a Unix shell, settings can only be per user, and nobody can edit what they
  got. The README's "Why" section is the public version of this; keep the two consistent.
- Every rule file is self-contained. An installed copy is all a project has — no links into this
  repo, no reference to the plugin, no "delete this if it doesn't apply" inside a rule.

## How rules are written

Every file under `rules/` meets the same five criteria:

- **Checkable, not aspirational.** A rule can be applied while writing; `write robust code` cannot.
- **Limits, not goals.** Say what not to produce; models overproduce.
- **No assumptions about the setup.** `base.md` names no language, build tool or pipeline; every
  other rule names nothing beyond the one dependency it exists for, and names that itself.
- **Nothing said twice.** Not within a rule, not across rules.
- **Always on.** No `paths:` frontmatter — a scoped rule misses the file that does not exist yet.
  A rule set that grows past a page of prose (template, worked example, migration guide) becomes a
  skill instead.

A new rule that fails one of them belongs in the discussion, not in a file.

## Settings

- `<UPPERCASE_NAME>` in a rule is a setting the project chooses at install time. Every one in use
  is listed under "Settings" in `skills/install-rules/SKILL.md`, with a default or none, and a
  common alternative — `AskUserQuestion` needs two options. A placeholder missing from that list
  is never asked for. `grep -rno '<[A-Z_]*>' rules` lists the ones in use.
- Lowercase brackets like `<topic>` or `<adr-dir>` are filled in by the model at runtime.
- A skill that needs a setting reads it from the installed rule, the way `adrs-consolidate` reads
  `<ADR_DIRECTORY>` from `.claude/rules/agent-plugin-coding/adrs.md`, and asks when the rule is
  not installed. It never hardcodes the default.

## README.md

- The rules table lists every file in `rules/`; each skill in `skills/` has its own section,
  headed ``### <Name> – `/coding:<skill-name>` ``. Agents in `agents/` are building blocks of a
  skill and are described with it.
- A rule or skill and its README entry change in the same commit.

## Plugin description

- The one-sentence description lives in four places and must stay identical:
  `.claude-plugin/plugin.json`, the GitHub repo description, the plugin's entry in
  `elnebuloso/agent-plugins` (`.claude-plugin/marketplace.json` and its README table) and the first
  paragraph of `README.md`.
- When it changes, update all four — the marketplace repo and the GitHub description are separate
  steps; remind the user.

## Language

Everything here is written in English: rules, skills, agents, README, commits. `<LANGUAGE>` is how
an adopting project chooses its own.

## Public repository

- Never commit tokens, credentials, internal hostnames or personal data.
- Third-party content only under an MIT-compatible license, with attribution.

## Git

- Conventional Commits, English. The scope names the rule or skill:
  `feat(handbook): make the handbook directory a setting`.
- Markdown prose wraps at 100 columns; line endings are LF via `.gitattributes`.
- Run `claude plugin validate .` before pushing. Ask before pushing.
- Never force-push, amend pushed commits, or hard-reset.

## Versioning

- The version lives in `.claude-plugin/plugin.json`. Claude Code detects updates by this version
  only — without a bump, users get no update.
- Before pushing, bump it by SemVer from the Conventional Commit types since the last release:
  `fix:` → patch, `feat:` → minor, `feat!:` / `BREAKING CHANGE:` → major. While pre-1.0, a
  breaking change bumps the minor. A batch of only `docs`/`chore`/`refactor`/`style` needs no bump.
- A plugin update never changes a project's installed rules; users pull them in with
  `/coding:install-rules`.
