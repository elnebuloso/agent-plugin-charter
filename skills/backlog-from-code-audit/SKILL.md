---
name: backlog-from-code-audit
description: Turns the findings of an audit document into Backlog.md tasks — one per finding, self-contained, questions as tasks of their own, existing tasks extended instead of duplicated — after the user has approved a preview
argument-hint: "[audit file] [milestone]"
disable-model-invocation: true
---

# Backlog tasks from a code audit

Turn the findings of one audit document into Backlog.md tasks. The audit is a snapshot that will
be outdated; the tasks are what someone works from later, without ever opening it.

Where `backlog` is not installed, say so and stop.

Arguments: $ARGUMENTS — an audit file and a milestone, both optional, in any order.

- **Audit file.** Without one, ask with `AskUserQuestion`, offering the newest files in
  `docs/audits/`. Any document that lists findings will do.
- **Milestone.** Without one, ask with `AskUserQuestion` whether the tasks go into one, offering
  the milestones `backlog milestone list` names, or none.

How a task is written — language, type, priority, labels — follows the project's backlog rule,
`.claude/rules/agent-plugin-charter/backlog.md`; without that file, ask the user the language the
backlog is written in. `backlog task create --help` and `backlog task edit --help` name the
options.

## Map the findings

Read the audit, list the tasks that are not done with `backlog task list --plain`, and search
for each finding's file and subject with `backlog search`. The audit is a snapshot: look at the
code each finding concerns as it stands now. Then map each finding to exactly one of:

- **New task** — one per finding.
- **Bundled** — findings that share a cause and the code they concern become one task.
- **Resolved** — the code no longer has the problem; nothing is written.
- **Extends** — an existing task covers it in part; name the task and what you would add to it.
- **Covered** — an existing task covers it wholly; name the task, and nothing is written.
- **Clarify** — a finding that is only a question or an uncertainty becomes a task of its own,
  its title starting with the backlog language's word for *Clarify:*.

## Preview

Show one table before anything is written: each finding in a few words, what it maps to, the
title, type and priority of the task. Priority follows the audit's own weighting — where it
sorts findings by impact, the order is that weighting. Then ask with `AskUserQuestion`: create
them all, or change the mapping first. Write nothing until the user approves; after a change,
show the table again.

## Write

Each task stands on its own:

- **No trace of the audit.** The audit document is not named, not linked, not given as a
  reference and not presumed; a task never says *as found in the audit*.
- **Everything the work needs is in it** — the file and line, what the problem is, what it costs,
  and the code it concerns, quoted where a line number alone would go stale.
- **Acceptance criteria say when it is resolved**, taken from what the finding names as the fix.

An extended task keeps everything it has; add to its description and acceptance criteria, and
change nothing else about it.

Touch nothing but backlog tasks — not the audit, not the code. Then list what was created and
what was extended, with task ids. Committing is the user's call.
