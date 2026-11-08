---
name: adrs-consolidate
description: Consolidates the project's ADRs so that one ADR answers each question — partly superseded ADRs are replaced whole by new ones, the old ones stay as superseded, and the index is brought up to date. Deletes no ADR.
disable-model-invocation: true
---

# Consolidate the ADRs

The goal is a set of ADRs in which one ADR in force answers each question. Where a decision is
spread over several ADRs — an older one partly superseded by a newer one, or one decision split
across two — a new ADR restates everything still in force on that question and supersedes them
whole. ADRs that already stand on their own stay as they are, number and file included. No ADR is
deleted: a superseded one keeps its number and gains a `Superseded by` line, as `adrs.md` asks.
You deliver analyses, drafts and questions — the user makes the decisions.

`<adr-dir>` below is the directory the project's ADR rule names —
`.claude/rules/agent-plugin-charter/adrs.md`. Without that file, ask the user where the ADRs live.

## Ground rules for every phase

- Change no existing ADR before phase 4, and delete none at all.
- Change no production code.
- Invent no rationale. Where the ADRs do not say *why*, mark it `[OPEN: rationale missing]`.
- Mark uncertainty, contradictions and interpretation as such — do not smooth them over.
- Working files go to `<adr-dir>/_consolidate/`. It is scaffolding, deleted at the end. If it
  already exists, a run is in progress: read what is there, tell the user where it stands, and
  wait for their OK before going on. Answers the user gave in chat do not survive the session
  unless they are in a file, so record each one in `04-questions.md` as it comes.
- After every phase: a short summary, then stop and wait for the user's OK. An answer to a
  question is not that OK: ask for it in a sentence of its own and go on only once it is given.

## Phase 1: Inventory

Read every file in `<adr-dir>/` except `_consolidate/` and write `_consolidate/01-inventory.md`
with:

1. A table: ID, title, date, status, supersedes, superseded by, topic area.
2. The supersession graph (Mermaid is fine), including *partial* supersessions — a newer ADR
   that changes only one aspect of an older one — and every ADR, accepted or proposed, that
   answers part of another's question without naming it.
3. Anomalies: missing or inconsistent statuses, implicit supersessions (a newer ADR contradicts
   an older one without referencing it), ADRs without a recognisable decision, an ADR still
   `Proposed` that the code already carries out, and files that are not ADRs — the index, a
   template. "The old ADRs" below means exactly the rows of the table.
4. A description of the ADR format used so far — structure, file names, numbering — so the new
   ADRs match it. Where it departs from `adrs.md`, name the gap; the new ADRs follow the rule.
5. Per ADR, every name and link `adrs.md` forbids an ADR to hold — paths, identifiers, links
   into the code, documentation or task tracker — so the drafts in phase 3 describe the thing
   instead.
6. Whether `<adr-dir>/README.md` exists as the index `adrs.md` describes, and where it is
   missing an ADR or disagrees with one.

## Phase 2: New structure

Write `_consolidate/02-mapping.md` with:

- The planned new ADRs, each with a working title, a short description and the question it
  answers.
- The mapping. Every old ADR in force appears exactly once, as one of:
  - **kept** — it answers its question alone: no other ADR, accepted or proposed, named in it or
    not, answers part of that question. It stays as it is.
  - **replaced** — by one or more new ADRs, which together carry over every part still in force;
    say which part goes where.
- ADRs already fully superseded need nothing and are listed once, as such.
- An ADR still `Proposed` is not in force: it is never merged into an accepted one. Whether it is
  accepted as it is, carried into a new ADR as a proposal of its own, or left as it is goes to the
  user as a question.
- The new ADRs take the next free numbers.

A question whose answer changes the mapping — a `Proposed` ADR above all — is asked now, before
the structure is approved, and recorded in `04-questions.md`. Every other question waits for
phase 4.

Replace only where one question needs more than one ADR to answer. A new ADR bundles one coherent
decision, not a whole topic area. Several focused ADRs beat one catch-all.

Where every ADR in force is kept, there is nothing to draft: phase 3 is the code check alone, and
phase 4 skips steps 1 and 2 after its questions — step 3 then makes only the changes approved for
kept ADRs, and the index is still written in step 4.

## Phase 3: Drafts and check against the code

Once the user has approved the structure:

1. Draft the new ADRs in `_consolidate/new/`, in the format from phase 1. Each holds at least
   context, decision, rejected alternatives (only the ones that matter) and consequences, and a
   `Supersedes` line naming the ADRs it replaces. The metadata table carries the consolidation's
   date; a draft's status is `Proposed` and becomes `Accepted` in phase 4, step 2 — one carried
   over as a proposal stays `Proposed`. A superseded earlier decision may appear among the rejected
   alternatives in one sentence, where the reason it was superseded helps explain the current one.
   Mark each draft as *clear*, *interpreted* or *contradictory*.

   Every sentence that gives a reason traces to an old ADR or to an answer recorded in
   `04-questions.md`; a rejected alternative the old ADRs do not name is not added. Before showing
   the drafts, list each reason with its source in `03-code-check.md`. A reason without a source
   becomes `[OPEN: rationale missing]`.
2. Check every new ADR, and every kept one, against the actual codebase and write
   `_consolidate/03-code-check.md`, one verdict per ADR:
   - ✅ consistent — with evidence: file and location
   - ⚠️ deviation — what the code actually does, with file references
   - ❓ not verifiable — e.g. a process or infrastructure decision

   Document only; fix nothing.

## Phase 4: Questions and completion

Write `_consolidate/04-questions.md` with every open point from phases 1 to 3, each as a concrete
question to the user with your assessment and the options. For every deviation the question is:
adjust the ADR, or adjust the code? For a kept ADR that holds names `adrs.md` forbids, or a
statement another ADR has made untrue, the question is whether to reword it in place.

Once the user has answered:

1. Finalise the new ADRs in `_consolidate/new/` according to the answers. Where the user changed
   the substance of a decision, record that briefly in the ADR's context. No draft marker survives
   — neither *clear / interpreted / contradictory* nor `[OPEN: …]`; a rationale the user could not
   supply either is stated as not recorded.
2. Show the user the finished ADRs, then stop. Their OK approves them — set the status as phase 3
   describes — and only then:
3. Move the new ADRs into `<adr-dir>/`. In each replaced ADR, set the status to `Superseded` and
   its `Superseded by` line to the new ADRs, replacing any partial wording such as "for …". Change
   nothing else in it. Make the changes the user approved for kept ADRs.
4. Write or update the index `<adr-dir>/README.md` as `adrs.md` describes.
5. List the deviations the user chose to resolve by adjusting the code as tasks in
   `_consolidate/05-followups.md` — do not implement them.
6. Search the project for ADR numbers and links to ADR files outside `<adr-dir>/`, and list each
   one that names a superseded ADR or the wrong ADR for what it cites. Documents describing the
   current state — architecture notes, the handbook, code comments — are the ones to correct;
   records of the past, such as finished tasks and changelogs, stay as they are.
7. Ask the user to carry the follow-ups and the corrections wherever their tasks live, then stop;
   create the tasks yourself only when they ask you to, by the project's rules for its tracker.
   Once they confirm, delete `_consolidate/` with everything in it — its results now live in the
   ADRs, the index and the follow-ups, and a leftover `_consolidate/` would make the next run
   resume a finished one.

Begin with phase 1.
