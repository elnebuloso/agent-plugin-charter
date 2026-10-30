---
name: handbook-review
description: Reviews the existing handbook pages against the project's handbook rule — lists what breaks it per page and fixes only what the user approves
argument-hint: "[page or directory]"
disable-model-invocation: true
---

# Review the handbook

The handbook rule shapes pages as they are written; pages written before it, or past it, are never
checked. This skill checks them. You deliver findings — the user decides what gets fixed.

The yardstick is the project's handbook rule, `.claude/rules/agent-plugin-charter/handbook.md`.
`<handbook-dir>` below is the directory it names. Without that file, say the rule is not installed,
use `${CLAUDE_PLUGIN_ROOT}/rules/handbook.md` as the yardstick and ask the user where the handbook
lives. Judge only by what the rule says; add no criteria of your own.

Scope: $ARGUMENTS — a page or a directory inside the handbook. Without one, every page in
`<handbook-dir>/`.

## Review

Read every page in scope in full before judging any of them: a page that looks like it repeats
another, or holds content for another role, only shows up next to the others. A gap is a finding
too: an error named without its fix, a prerequisite that surfaces only at the step where it fails.

For each finding note the page, the line, the bullet of the rule it breaks and the change you
propose: a deletion, a rewrite with the new text, or a move with its target page. Where a fix needs
knowledge the pages do not hold — the real limit, the exact error text — look it up in the code
and name where you found it. What the code does not settle, such as the role a page is for, is a
question to the user; never make it up.

A feature that takes a paragraph to find is a flaw in the product, not in the page. Collect those
apart.

## Report

In chat, per page: a short table of the findings, worst first. Pages without findings in one line
together. Then the product flaws, then the open questions. Change no file before this.

Then ask with `AskUserQuestion`, multi-select, which pages to fix — up to four options per
question, so split where needed. Fix only those pages, only as proposed, with the user's answers
filled in; a finding whose question is unanswered stays as it is. Say which findings stay open.
Committing is the user's call.
