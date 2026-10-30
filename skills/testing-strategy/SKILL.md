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
been run once and worked. Nothing is dropped from CI. Nothing here assumes a language, a test runner
or a task runner: what this project uses is found in step 1, and what its runner can do is looked
up in the runner's own help or documentation.

## 0. Before you start

- **The work tree is clean.** Step 2 makes probe edits and reverts them with
  `git checkout -- <file>`. With uncommitted changes, stop and ask the user to commit or set them
  aside first; never stash or reset their work yourself.
- **An existing `.claude/rules/testing-strategy.md` is updated, not replaced.** Read it first.
  Measurements and the mapping of change kinds are rewritten; lines the user added stay as they are.

## 1. Inventory

Read before running anything:

- The task runner the project starts its commands with, and the project rules about it. If the
  project says to use its targets rather than the commands behind them, the narrow runs go through
  the targets too (step 4).
- Each suite's configuration: the test runner, its projects or packages, what a run starts (a
  build, a server, a database, containers), whether files run in parallel, whether a file is serial
  on purpose.
- CI: which suites it runs. The strategy changes local habits only.

Then tell the user what step 2 will start — every full suite and what each brings up — and ask
with `AskUserQuestion`: run everything (recommended), or leave out the suites they name. A suite
left out appears in the file as not measured. Ask in the same go for the time limit per run:
15 minutes (recommended), or one the user names.

## 2. Measure

Time each run once with the toolchain versions the project pins, output to a file outside the
project, and record wall time and exit code. A run that exceeds the time limit is stopped and
recorded as timed out, and the next one starts; a timed-out run is reported, never retried
unasked.

- every full suite as the task runner starts it, with static checks separately where one target
  bundles them;
- per project or package, where the runner has them;
- one single test file of each kind the project has (unit, integration, end-to-end);
- one single test by name;
- the runner's change-based selection, if it has one: after one probe edit to a leaf module and one
  to a widely imported module, each reverted afterwards;
- the build step on its own, where a suite builds first;
- the formatter's fix run next to the lint check, where the project has both.

Check what a change-based run really selected, from the runner's output, not only that it passed.

Find the slow files with the runner's timing or machine-readable report. One file that dominates a
suite is the most useful line in the result: the agent then knows to leave it out unless the change
is in its area.

## 3. Check isolation

Running every integration and end-to-end file alone can take far longer than the suite. Show the
user, per suite, its measured time and its number of files, and ask with `AskUserQuestion`,
multi-select, which suites to check; a suite not checked appears in the file as not checked. Never
sample files within a suite — the file that depends on another is the one a sample misses.

Run every file of the chosen suites alone, under the same time limit. A file that passes in the
full run and fails alone depends on state another file left behind (an account, a seeded row, a
setting) and passes only by order or timing. That is a bug in the test. A file that is serial on
purpose (each test builds on the one before) is noted as "run whole", never split by test name.

## 4. Propose, then change

Collect what the project itself would change:

- **Test fixes** for each isolation bug from step 3: the file sets up or avoids that state itself.
- **Narrow runs in the task runner**, where its targets cannot be narrowed yet. Prefer a parameter
  on an existing target (a file, a name filter) over a new target; add one only for a narrow run
  that needs more than arguments. Follow the project's rules for its task runner.

Show the list, then ask with `AskUserQuestion`, multi-select, which to apply. Apply only those, run
each changed test and each narrowed target once to prove it, and say what stays open. A narrow run
not applied is left out of the file, not written with the raw command behind it.

## 5. Map change kinds to checks

Each kind of change gets the lowest test level that can catch what it breaks — unit, then
integration, then end-to-end. A higher level runs only for what the lower ones cannot see: where
parts meet, or a flow through the system.

Derive the list from this project's layout, not from a template. Typical rows:

- **Default after a code edit:** the change-based run, if the runner has one.
- **A unit with its own tests:** those tests, or the change-based run.
- **Where parts meet — a query, a client for another service, a message handler:** the integration
  tests of that boundary.
- **An entry point — a route, a command or a page:** its tests, then one real call against a
  running instance; an end-to-end file only when the change alters a flow that file walks through.
- **A user-visible text:** search the old text in the test files; only files that assert it run.
- **Only how something looks:** no test catches a look; look at it running.
- **Everything that every request or the build passes through:** shared middleware, build or
  framework configuration, a dependency, a schema migration, environment parsing — the full suites.
- **Static checks that only run whole-project:** at the end.

## 6. Write `.claude/rules/testing-strategy.md`

Rules for the agent, short, in the style and language of the project's other rule files:

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

## Files that run whole

- … the serial files from step 3 …

## Before the commit that ships

All full suites after the last change. A narrow run that passed earlier does not stand in for them.
```

Name commands exactly as they run in this project, through its task runner. Leave out a row or a
section the project has no case for.

## 7. Finish

Run lint and the suites the changes touched, in full. Commit nothing; committing is the user's
call. Report to the user: the measured table, the slowest file, what the narrow runs save on a
typical change, the runs that timed out, the isolation bugs found and which of them were fixed,
and that CI is unchanged.
