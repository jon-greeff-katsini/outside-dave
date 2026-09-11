# Writing plans

A plan turns an approved design into ordered steps and the proof that each one worked. The spec says what the system does. The design says what shape the code takes. The plan says in what order to build it, which tests prove it, and how to run them.

Write every plan so a developer in a fresh session could pick it up and execute it without asking a question. That is also what lets an agent execute it, or resume it after a break, without the context that produced it.

A plan is temporary. The spec and the design outlive the work and describe the system. The plan describes a job, and when the job is done it is deleted. Nothing that needs to survive belongs in it. If you find yourself writing something in the plan that a future reader would need, it belongs in the spec, the design, or the project docs.

Use `templates/plan.template.md` as the starting point. This document explains how to fill it in well.

## Before you write

Read the spec and the design in full. Both must be approved. If either is a draft, stop. A plan built on a moving design is rewritten as often as the design is.

Read how the project runs its tests. The onboarding skill records this in `docs/TESTING.md` and the README, though the project may keep it elsewhere. The plan must name the real commands and the real test locations, so you need to know what they are. Look at existing tests to learn the conventions: where they live, how they are named, what they use to drive a browser, an API, or a command line.

Read the coding rules. Steps that break them will be rejected in review.

Follow the repository's convention for where in-progress plans live. If there is none, put them in `plans/` at the repository root, one file per plan, named after the design it implements. Keep them out of `docs/`. A plan is not documentation, and a reader browsing the docs should not find one.

## Filling in the template

Set the Spec and Design lines first. Everything in the plan is derived from those two documents, and an executor picking the plan up in a fresh session needs to find them before anything else.

Work through the sections in order. Overview says what the job is. Steps says what gets done and when. Verification says what proves it. Documentation says what the change breaks elsewhere, and Open Questions holds what is still undecided.

Fill every section. Write "None" where a section has nothing in it, so a reader knows it was considered. Documentation is the usual candidate, and it is rarely correct.

Delete each hint once its section is written. A finished plan has no hints in it.

## Writing steps

Every step names real files from the design's Files in Scope and says what changes in each. "Add `validateVoucher()` to `src/vouchers/service.ts`" is a step. "Update the voucher logic" is a wish. If a step needs context the reader might not have, the step carries that context.

Every file in the design's Files in Scope appears in at least one step, and no step touches a file outside it. If you cannot plan the work inside the listed files, the design has a gap. Take it back to the design rather than widen the plan.

Each step names the spec items it delivers by number, and the design components it builds or changes. A step that delivers no spec item is either refactoring, which the design should have excluded, or infrastructure for a later step, which should say so.

Order steps so the code builds and the existing tests pass after every one. A plan where nothing works until step nine cannot be resumed at step five. Put shared types and data changes first, then the components that depend on them, then the entry points that expose them.

Then look for what can run at the same time. Group the steps into waves. Two steps belong in the same wave when neither needs the other's output and they touch no file in common. Each wave depends on the wave before it and nothing else. The design's class diagram is the guide: components with no edge between them can usually be built side by side, and their unit tests with them. Acceptance tests depend on the spec alone, so they often form the first wave on their own.

A wave is what an executor hands to parallel subagents, one step each. So each step in a wave must be complete on its own: it carries the files, the context, and the test that proves it, and it does not assume the reader has seen the other steps in the wave. If two steps cannot be described without reference to each other, they are one step.

Keep steps small. One component, one behaviour, or one file is the right size. A step that takes a paragraph to describe is two steps. No step says "implement the rest".

## Verification

Verification is two kinds of test, and the plan names both before any code is written.

### Unit tests

For each component in the design, the plan names the tests that check its behaviour on its own: what it does with valid input, what it does with each kind of invalid input, and how it behaves at its boundaries. Follow the project's existing test conventions for location and naming. Say which file each test lives in.

Unit tests prove the parts. They do not prove the feature, and the plan must not present them as if they do.

### Acceptance tests

For each acceptance criterion and each edge case in the spec, the plan names one test. The test drives the entry point the spec names, a browser page, an HTTP endpoint, or a command line, performs the action the criterion describes, and asserts the observable result the criterion states. Nothing in the test touches internal code. If the spec says an alert shows, the test looks for the alert.

Name each test for the number it proves, so the test list reads as a coverage report of the spec. A reviewer should be able to check coverage from the test names alone.

Write the acceptance tests in the plan before the implementation steps. They depend on the spec and not on the design, so they can be written early, and running them red first proves they test something. A test that passed before the feature existed proves nothing.

The spec has already settled how each entry point is driven and what the test needs to reach it. The plan turns that into a real test: the framework, the file, the name, and the command. It runs unattended in the pipeline like the rest of the suite. Credentials and a deployed environment are not a reason to fall back to a manual check, they are dependencies the spec lists and the plan sets up.

The only manual tests in a plan are the ones the spec already marked as impossible to automate and the user already accepted. Carry the spec's manual steps and expected result across, and mark the row so the reviewer knows to check it by hand. If you find yourself writing a manual test the spec did not mark, stop: that is a gap in the spec, not a step in the plan.

### The coverage table

The Verification section ends with a table. One row per AC and EC in the spec, the test file and name that proves it, and the command that runs it. Every numbered item in the spec has a row. If a row is blank, the plan is not finished.

### Commands

Give the exact commands to run the unit tests, the acceptance tests, and the full suite, taken from the project's testing docs. "Run the tests" is not a command.

## Documentation

List every document the change invalidates: the README, architecture and testing docs, coding rules, API references, runbooks, and the pointers in `CLAUDE.md` or `AGENTS.md`. Name the update each one needs. A stale document misleads worse than a missing one, so updating them is part of the work, not a follow-up. If nothing needs updating, write "None" so the reader knows it was checked.

## Open questions

Anything the plan needs and you cannot decide goes in Open Questions. If the question is about behaviour, it belongs in the spec. If it is about shape, it belongs in the design. Move it there, set that document back to draft, and stop until it is answered.

A plan cannot move from draft to approved while Open Questions has entries.

## Executing the plan

Work the waves in order. Within a wave, run the steps in parallel, one subagent per step, or in any order if working alone. After each wave, run the commands the plan gives and confirm the code builds and the tests pass before starting the next. Mark each step done in the plan, so a fresh session can see where to resume.

That check between waves is a build gate. It asks one question, does the suite still pass, and if it does the next wave starts immediately. Nobody is asked to approve anything between waves. Run the plan through to its last step that way.

When a step reveals something the design or spec does not cover, stop. Put the question in the document it belongs to and set that document back to draft. Do not patch around the gap in the code. A patch that works is the hardest kind of deviation to find later, because nothing is broken.

Never change a test to make it pass. If a test is wrong, the spec or the plan is wrong, and the fix goes there first.

## Final check before executing

Read the plan back as the developer who has to execute it in a fresh session.

- Does every step name real files, and does every file in the design's Files in Scope appear in a step?
- Does any step touch a file the design does not list?
- Does every step name the spec items it delivers?
- Would the code build and the tests pass after every wave?
- Do any two steps in the same wave touch the same file, or need each other's output?
- Does every AC and EC have a row in the coverage table, with a real test name?
- Does every acceptance test drive an entry point and assert an observable result?
- Do the commands exist in the project as written?
- Is every invalidated document listed?
- Is every section filled, or marked "None" on purpose?
- Is Open Questions empty, or is the status still draft?

Fix what fails, then take the plan to the user for approval before executing it.

## Approval

A person closes the work. When every step is done and the tests pass, show the user the finished change and test results, then ask them to accept it. The spec and design move to implemented when the user says so and not before. If they ask for changes, make them, rerun the relevant tests and return the result for acceptance.

When the user accepts, delete the plan. Check first that nothing in it needs to survive: a decision that should have gone in the design, a manual test step that belongs in the testing docs, a command the README should carry. Move those, then remove the file. The spec and the design are the record of what was built. The plan was the record of building it, and that job is over.
