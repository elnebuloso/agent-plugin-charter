---
name: testing-strategy
description: Measures a project's test suites and writes .claude/rules/testing-strategy.md — the cheapest check per kind of change, the full suites before shipping
disable-model-invocation: true
---

# Testing strategy

The goal: while working, the agent runs the cheapest check that can catch what a change breaks; the
full suites run before the commit that ships and always in CI. The output is one rules file,
`.claude/rules/testing-strategy.md`, plus small changes to the task runner where needed.

Every number in the file is measured in this project, on this machine. Every command in the file has
been run once and worked. Nothing is dropped from CI.

## 1. Inventory

Read before running anything:

- The task runner (`Makefile`, `package.json` scripts, `justfile`, `Taskfile`, `tox.ini`, …) and the
  project rules about it. If the project says "use the target, not the command behind it", the
  narrow runs must go through the targets too (step 4).
- Each suite's config: test runner, projects or workspaces, what it starts (a build, a server, a
  database, containers), whether files run in parallel, whether a file is serial on purpose.
- CI: which suites it runs. The strategy changes local habits only.

## 2. Measure

Time each run once with the project's toolchain active (right Node/Python/Go version), output to a
file, and record wall time and exit code:

- every full suite as the task runner starts it (lint, unit, component, e2e, type check separately
  if the lint target bundles them);
- per suite project or package, if the runner has them;
- one single test file of each kind (unit spec, component story, e2e file);
- the runner's own change-based selection, after a probe edit: one edit to a leaf component and one
  to a widely imported module, each reverted afterwards (stash the work tree first);
- the build step on its own when e2e builds first;
- formatting fixes (`format` target) next to the lint check.

Find the slow files with the runner's JSON or timing reporter. One file that dominates a suite is the
most useful line in the result: the agent then knows to leave it out unless the change is in its
area.

Change-based selection by runner, to try first:

| Runner | Change-based run | Single file / test |
|---|---|---|
| Vitest | `vitest run --changed` (uncommitted), `--changed <ref>` | `vitest run <path>`, `-t <name>`, `--project <name>` |
| Jest | `jest --onlyChanged`, `--changedSince <ref>` | `jest <path>`, `-t <name>` |
| Playwright | none built in | `playwright test <file>`, `--grep <title>` |
| pytest | `--lf` (last failed); `pytest-testmon` if installed | `pytest <path>::<test>`, `-k <expr>` |
| Go | none; packages are the unit | `go test ./<pkg>/...`, `-run <regex>` |
| Cargo | none | `cargo test -p <crate> <filter>` |

Check what a change-based run really selected (reporter output), not only that it passed.

## 3. Check isolation

Run every e2e or integration file alone. A file that passes in the full run and fails alone depends
on state another file left behind (an account, a seeded row, a setting) and passes only by worker
order or timing. That is a bug in the test: fix it so the file sets up or avoids that state, in a
`test:` commit of its own, and mention it to the user. A file that is serial on purpose (each test
builds on the one before) is noted as "run whole", never split with `--grep`.

## 4. Expose the narrow runs

Prefer a variable on the existing targets over new targets:

```make
test: ## Run the unit tests once (TEST=… narrows the run)
	npm test -- $(TEST)

e2e: ## Run the browser tests (E2E=… narrows the run)
	npm run test:e2e -- $(E2E)
```

Add a new target only for a narrow run that needs more than arguments (a script, a different
setup), and follow the project's rules for targets (help text, `.PHONY`). Run each narrowed form
once to prove it.

## 5. Map change kinds to checks

Derive the list from this project's layout, not from a template. Typical rows:

- **Default after a code edit:** the change-based run, if the runner has one.
- **A component:** its stories or component tests; look at it in a running dev environment.
- **A module with specs:** its spec file, or the change-based run.
- **A route, handler, page or form:** its spec, then a request against a running dev server (curl or
  browser); the e2e file only when the change alters a flow that file walks through.
- **A user-visible text:** grep the old text in the test files; only files that assert it run.
- **Styles only:** no test catches a look; check the screen (both colour schemes if the project has
  them) and the component's stories.
- **Everything that reaches every request or the build:** server hooks or middleware, the HTML shell
  or root layout, bundler or framework config, a dependency, a migration, environment parsing — the
  full suites.
- **Types:** if the type checker only runs whole-project, it runs at the end.

## 6. Write `.claude/rules/testing-strategy.md`

Rules for the agent, short, in the style of the project's other rule files:

```markdown
# Testing strategy

While working, run the cheapest check that can catch what the change can break. The full suites run
once, before the commit that ships the work, or at the end of a batch of tasks. CI always runs all
of them.

## What a run costs

Measured in the agent's shell (<cores>):

| Run | Time |
|---|---|
| … every full suite, project, single-file and change-based run from step 2 … |

## Pick the run by the change

- … the rows from step 5, each naming the exact command …

## E2E files

- … which files run alone, which are serial and run whole …
- A new e2e file must not depend on the state another file leaves behind.

## Before the commit that ships

All full suites after the last change. A narrow run that passed earlier does not stand in for them.
```

Name commands exactly as they run in this project, through its task runner. Leave out a row the
project has no case for.

## 7. Finish

- Run lint and the suites the changes touched (task runner, test files), in full.
- Commit the test fix, if any, separately from the strategy and the task runner change; follow the
  project's commit conventions.
- Report to the user: the measured table, the slowest file, what the narrow runs save on a typical
  change, any isolation bug found, and that CI is unchanged.
