---
name: ux-analysis
description: Analyses a web application's usability and structure as a whole and writes a target concept — information architecture, sitemap, layouts, components and a prioritised plan — without changing anything
disable-model-invocation: true
allowed-tools: Bash(date *)
---

# UX analysis and target concept

The result is one document a team can build the next UI from: how the application is structured
today, where it gets in the user's way, and how it should be structured instead. It is about
usability, navigation, information architecture and components — not a new look; the visual
design is the `mockups` skill's job.

You analyse and write, nothing else: no file of the project changes apart from
`docs/ux/<timestamp>/`, nothing is implemented.

## Before you start

- **Where it goes.** `docs/ux/<timestamp>/` — the document as `analysis.md`, the screenshots in
  `screenshots/`. The timestamp is !`date +%Y-%m-%d-%H%M`, already resolved; use it as it stands.
- **Language.** Ask with `AskUserQuestion` which language the document is written in — the
  language of the chat first, then the one most of the project's prose is in.
- **A running instance.** Ask for its URL and, where the application has roles, an account per
  role. Without a URL or a browser tool in this session, say so and work from the code alone,
  naming that limit in the document. Credentials never go into the document.

## Phase 1 — what is there

1. Take a screenshot of every reachable page, and of the states that matter: open dialogs and
   menus, forms with their errors, tables and detail views, filters and search, success and error
   messages, empty and loading states, and the views of each role where there are roles.
2. Hand the screenshots to a subagent that looks at them as an experienced UX and product
   designer. It operates the application itself where a screenshot does not show how things
   connect — screenshots alone are not the analysis. Give it the URL, the accounts and the
   screenshots' path; it returns its findings to you, and you write the document.
3. Write down the current page structure, the functions on each page, and the UI components in
   use, including any component catalogue the project keeps, such as Storybook.

Check that every page and function is in the inventory before you move on.

## Phase 2 — the target

1. **Problems.** Go through the application as a whole, not page by page: can users find what
   they need without detours, is the navigation logical and the grouping sensible, are labels
   understandable, is anything needlessly complex, solved differently in different places,
   redundant, or a dead end, are important actions and their consequences clear, is the
   hierarchy of information visible, and does the structure hold as functions are added. Each
   problem is concrete, with the page or flow it occurs in.
2. **Areas and layouts.** Find out from the analysis whether the application serves clearly
   separate groups of users or tasks, such as everyday use and administration. Propose separate
   layouts only where it does; otherwise describe the one layout. For each, say what it is for
   and how it grows when functions are added. Name no layout pattern before the analysis calls
   for it.
3. **Information architecture.** A complete target sitemap: which pages exist, which belong
   together, which are merged, split, added or dropped, what goes into tabs, dialogs or subpages,
   the navigation hierarchy, and the main paths users take between them.
4. **Pages.** For every page and view: its purpose, its tasks and functions, and how it relates
   to the others — its role in the application, not where a button sits. Write "This page manages
   user accounts: create, edit, deactivate and delete, in one consistent management view", not
   "The logout button is top left." Where pages share a task, such as list, detail and edit
   views, describe the page type once and use it throughout.
5. **Components.** Which components are merged, adapted, added or removed, grouped into
   categories such as layout, navigation, forms, data display, feedback and overlays — reusable
   across pages rather than one-off. Where the project has a component catalogue, say where each
   sits in its structure; without one, at most propose introducing one.

## Phase 3 — the way there

Rate every change by its effect on users, technical effort, dependencies and weight for future
growth, and sort it as critical, structural, worthwhile or optional. From that, an order of
implementation with a migration path and acceptance criteria per step.

## The document

Summary, current structure, problems, target areas and layouts, sitemap with navigation and user
paths, pages and page types, components, and the plan. Every existing function either appears in
the target or is removed with a reason — none disappears unnoticed. Existing solutions are not
kept just because they are built. No function or requirement the analysis does not support;
assumptions and open questions are marked as such.

Name the document's path and its three most important findings. Committing it is the user's call.
