# agent-plugin-coding

Rules and skills for coding agents — pick the rules your project needs, installed as files you own.

## Installation

```bash
claude plugin marketplace add elnebuloso/agent-plugins
claude plugin install coding@elnebuloso
```

Then, in each project that should follow the rules, run `/coding:install-rules`. It writes them to
`.claude/rules/agent-plugin-coding/`, apart from the project's own rules, and Claude Code loads them
like any other file under `.claude/rules/` — in every session, in subagents, after `/compact`. Read
what it wrote and delete what you disagree with; the files are yours from then on.

Update — auto-update is off for this marketplace unless you switch it on under `/plugin`. A plugin
update never touches a project's rules; run `/coding:install-rules` again to compare and pull them in:

```bash
claude plugin marketplace update elnebuloso
claude plugin update coding@elnebuloso
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
answer per rule; `adrs` also asks where the ADRs live (default `docs/decisions`). The answers stay
in the installed files, and updates keep them.

## Skills

### Install rules – `/coding:install-rules`

Shows which rules the project has, which are missing and which differ from the plugin's version, and
asks which ones to install or update. A copy that differs is only overwritten after it says what
would change and gets an explicit yes — the project's own edits would be lost.

### Project code review – `/coding:project-code-review`

Reviews the codebase as it stands, not a diff — through the eyes of a senior developer who would have
to take the project over, measured against the project's own rules. Writes one report to
`docs/reviews/`; changes no source file.

### Consolidate ADRs – `/coding:adrs-consolidate`

Merges the ADRs in the directory the installed `adrs` rule names into a set that holds only the decisions in force today;
superseded ones drop out and the old files are deleted. Works in phases and stops for approval
before anything is deleted.
