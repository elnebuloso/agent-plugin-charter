---
name: mockups
description: Evolves the project's visual design through click dummies — lets the user set how far the layout may change, offers sketched design directions or picks them itself, builds each line of plain HTML/CSS mockups with a fitting design skill from the ones the user allows, develops the line the user picks until a design is chosen, then writes the chosen one down
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
  versions. A line the user throws out is deleted, never kept around.
- **Plain HTML and CSS, no framework, no build step.** JavaScript only for the light/dark switch
  and for the clicks between screens. Every version opens from the file system. This holds
  whatever a design skill prescribes: it shapes the look, not the technique.
- **Light and dark in every version.** It follows the system setting and has a switch on every
  screen; the choice holds while the user clicks through the screens of that version.
- **Build the scope, nothing more.** Every clickable element leads to a screen in scope or is
  visibly inert. Content is realistic, from the product's domain, never placeholder text.
- **Touch nothing outside `<mockup-dir>/`**, `.gitignore` and the design description and
  component page written when a version is chosen — the project's frontend least of all.
- **One subagent per version.** Each version is built by its own subagent, which loads only the
  design skill of its line, so one skill's rules do not bleed into another line; you load none.
  Give it these ground rules, your picture of the UI, the scope, the freedom, the direction — or,
  for a new stage, the version it copies and what changes — and the directory to build in. Start
  the subagents of one round together.
- **The log keeps the state.** `<mockup-dir>/README.md` names the design skills the user allows
  and holds one row per version: line, stage, the version it was developed from, design skill,
  freedom, direction, scope, who chose them — the user or you, what changed. Each line is in the
  race, thrown out or chosen; rows of a thrown-out line stay, so its direction is not offered
  again. Answers given in chat do not survive the session, so record each one as it comes.
- **One page to navigate from.** `<mockup-dir>/index.html` lists the lines in the race, newest
  line first, each with its direction and design skill, its latest stage on top and the earlier
  ones below. It is rebuilt after every change. Every screen of every version links back to it.

## Start

1. Read the log, if there is one, and tell the user where the evolution stands. Continue from
   there.
2. Build yourself a picture of the whole UI from the code: its screens, routes and main flows,
   and what each screen shows and lets the user do. That content and those functions are what a
   mockup keeps; how far it keeps the current layout is decided per round. Where there is no UI
   yet, ask the user which screens the product has. Where the `design` rule is installed, read
   the file it names too: the agreed design a new round sets out from.
3. Unless the log names them, ask with `AskUserQuestion`, multi-select, which design skills may
   build lines — the installed ones whose description covers visual design, up to four options;
   the user names any other in the free-text answer. None ticked means no design skill. With none
   installed, skip the question. Ask again only when the user wants to change the choice.

## Round: new lines

1. **Freedom.** Ask with `AskUserQuestion` how far this round may move away from the current UI:
   - **Restyle** — same layout, new look: colours, type, spacing, shapes.
   - **Rework the layout** — same screens and content, arranged however serves them best;
     nothing of the current arrangement is fixed, from the grid down to how a list is shown.
   - **Rethink the screens** — only what the product does stays; screens may be split, merged or
     regrouped.
   - **Your call** — you choose freedom, scope and directions yourself and ask nothing more this
     round. Pick a freedom and directions the log has not tried yet, keep the last round's scope
     or take the main flows, and say what you chose once the lines are built.

   Where there is no UI yet, offer only the last two.
2. **Scope.** Ask with `AskUserQuestion`, multi-select, which screens and flows the click dummy
   covers this round — the main ones from your picture of the UI, up to four options, the last
   round's scope first. Every round asks this anew, unless it is Your call.
3. **Directions.** Work out nine clearly distinct directions, none of them already a line in the
   log or close to one. Beyond a restyle they differ in layout as much as in look. Describe each
   so that someone without design vocabulary can picture it: a name — a style people know by
   name, such as glass or retro, where one fits — then one sentence on what the user sees and how
   it feels to use. No colour codes, font names or design terms, and no word that fits every
   direction, such as modern or clean. Give each option a `preview`: an ASCII sketch of one main
   screen in that direction, with its look named in a few plain words below it. Ask in one
   `AskUserQuestion` call: three questions of three directions each, one pick per question.
4. **Build** one line per pick: the next free line numbers, stage `01`. Give each line the allowed
   design skill that fits its direction best, a different one per line as far as the allowed ones
   reach.

## How to go on

After every round, ask with `AskUserQuestion` how to go on:

- **Develop a version** — ask which one, usually the latest stage of a line; then what should
  change, with up to three concrete changes you see in it as options — in layout as well as look,
  unless the line is a restyle — and **Your call** as the last; then the scope. With Your call you
  decide what changes, keep the version's scope, ask nothing more and say what you changed. Build
  it as the next free stage of its line, with the design skill of its line.
- **New lines** — a round of new lines; the lines in the race stay in it.
- **Throw out lines** — ask with `AskUserQuestion`, multi-select, which lines go: the oldest
  lines in the race, up to four; the user names any other in the free-text answer. Delete them,
  record them as thrown out and ask again how to go on. Starting over is throwing out all, then
  new lines.
- **Choose a version** — ask which one. Record it as chosen and hand it over, as below.

Record each answer in the log before you build anything further. The user can stop at any point;
the log is current.

## When a version is chosen

The mockups are throwaway and may not even be in the repository; what the frontend is built from
is a description of the chosen version, and a page that shows it applied to every component.

1. It goes to the file the `design` rule names, `.claude/rules/agent-plugin-charter/design.md`.
   Without that rule, ask where and offer `docs/design.md` — never inside `<mockup-dir>/`. If the
   file exists, show what would change and ask before replacing it.
2. Write it from the chosen version's CSS and HTML, as values, not adjectives: colours in light
   and dark, type, spacing, radii and borders, the recurring components, and the layout of each
   screen in scope. Anything the version leaves open is named as open, not invented.
3. Build the component page next to it, same name ending in `.html`: every kind of element the
   project's frontend uses — from your picture of the UI, not only the screens in scope — one
   below the other, each under its name and in its states, such as buttons, inputs, tables,
   navigation, cards and messages. Plain HTML and CSS with the light/dark switch, like a version.
   Build it from the description alone, not from the mockup's CSS: what looks wrong on the page
   is wrong or missing in the description, so fix the description first. An element the
   description leaves open is shown as open, not styled by guess. If the page exists, ask before
   replacing it.
4. Name the chosen version, its path, the description and the component page, and the screens of
   the product the description does not cover. Where the version rethinks screens, say that the
   frontend has to be rebuilt to match, not only restyled.
5. The agreed design ends what `v0-design` exists for, and the `design` rule takes over: it holds
   the frontend to the description. Unless it is installed, tell the user to install it with
   `/charter:install-rules design`, set to the description's path. Then offer to delete
   `.claude/rules/agent-plugin-charter/v0-design.md`. Committing anything is the user's call.
6. Offer to delete `<mockup-dir>/` — the description and the component page hold the result. If
   git ignores it, say that nothing brings it back.
