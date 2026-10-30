---
name: mockups
description: Evolves the project's visual design through click dummies — offers style directions, builds plain HTML/CSS mockups in numbered lines and stages, and develops the line the user picks until a design is chosen
disable-model-invocation: true
---

# Evolve the design through mockups

The goal is a design the user has chosen by clicking through it, reached in rounds: several style
directions side by side, then one of them developed step by step. Each line of mockups is one
direction, each stage in it one step further. You build only what the user asked for in the
current round, and you ask before every round.

`<mockup-dir>` below is the directory the project's `v0-design` rule names —
`.claude/rules/agent-plugin-charter/v0-design.md`. Without that file, ask the user where the
mockups live and offer `docs/mockups`. If git does not ignore `<mockup-dir>/` yet, offer to add it
to `.gitignore`.

## Ground rules

- **Versions are immutable.** A mockup lives in `<mockup-dir>/NN/MM/` — `NN` the line, `MM` its
  stage, both two digits. Once built, a version is never changed; a new stage starts as a copy of
  the version it develops. Each version is complete on its own, with no stylesheet shared across
  versions.
- **Plain HTML and CSS, no framework, no build step.** JavaScript only for the light/dark switch
  and for the clicks between screens. Every version opens from the file system.
- **Light and dark in every version.** It follows the system setting and has a switch on every
  screen; the choice holds while the user clicks through the screens of that version.
- **Build the scope, nothing more.** Every clickable element leads to a screen in scope or is
  visibly inert. Content is realistic, from the product's domain, never placeholder text.
- **Touch nothing outside `<mockup-dir>/`** and `.gitignore` — the project's frontend least of all.
- **The log keeps the state.** `<mockup-dir>/README.md` names the design skill in use and holds
  one row per version: line, stage, the version it was developed from, direction, scope, what
  changed, the user's verdict — discarded, developed, chosen. Answers given in chat do not survive
  the session, so record each one as it comes.
- **One page to navigate from.** `<mockup-dir>/index.html` lists every version, grouped by line,
  newest line first, each with its direction and verdict, and is rebuilt after every round. Every
  screen of every version links back to it.

## Start

1. Read the log, if there is one, and tell the user where the evolution stands. Continue from
   there; a round the log holds no verdict for gets its verdict first.
2. Build yourself a picture of the whole UI from the code: its screens, routes and main flows.
   Where there is no UI yet, ask the user which screens the product has.
3. Unless the log names one, ask with `AskUserQuestion` which design skill to build with — the
   installed ones whose description covers visual design, or none. With none installed, skip the
   question. Load only the one chosen.

## Round: new lines

1. **Scope.** Ask with `AskUserQuestion`, multi-select, which screens and flows the click dummy
   covers this round — the main ones from your picture of the UI, up to four options, the last
   round's scope first. Every round asks this anew.
2. **Directions.** Work out nine clearly distinct style directions, none of them already a line
   in the log — each a name and one line on palette, type, density and shape. Ask in one
   `AskUserQuestion` call: three questions of three directions each, one pick per question.
3. **Build** one line per pick: the next free line numbers, stage `01`.

## Verdict

After every round, ask with `AskUserQuestion`:

- **Develop a version** — ask which one, usually the latest stage of a line; then what should
  change, with two to four concrete changes you see in it as options; then the scope. Build it as
  the next free stage of its line.
- **New lines** — every line so far is discarded; start a round of new lines.
- **Choose a version** — ask which one. Record it as chosen and stop.
- **Stop** — record where the evolution stands and stop.

Record the verdict in the log before you build anything further.

## When a version is chosen

Name the chosen version and its path. A design that is agreed now ends what the `v0-design` rule
exists for: say that the user can delete it from the project. Committing anything is the user's
call.
