---
name: spec-driven-development
description: "Use when building product features through specs, designs and plans rather than straight into code. Trigger when the user asks to write or change a spec, design a feature, produce an implementation plan, implement one, or change shipped product behaviour that no spec covers. Do not create a new spec for repository tooling or maintenance work unless the user explicitly asks for one. Routes to the guide and template for each phase, and to the rules that keep the code, spec and design in agreement."
---

# Spec Driven Development

A feature is built in four phases: the spec says how it behaves, the design says what shape the code takes, the plan says in what order to build it, and the implementation delivers it. Each phase is approved by a person before the next begins, and each one is written so a developer with no history on the project could pick it up cold.

That last point is what makes this work for agents. A document that survives a fresh reader survives a fresh context.

## The source of truth

The spec is the truth about behaviour. The design is the truth about shape. Both outrank the code, and neither is ever edited to match what was built.

Everything else follows from that. When the code disagrees with the spec, the code is wrong. When implementation turns up behaviour nobody specified, the work stops and the question goes back to the spec, because a gap patched in code is invisible afterwards: nothing is broken, so nobody looks. When a test fails, the fix goes into the spec or the plan, never into the test.

The plan is the exception. It is a work order, not a record, and it is deleted when the job is accepted. Anything in it that a future reader would need has to move into the spec, the design, or the project docs before it goes.

## Prerequisites

Two things must exist before any of this is worth starting:

- **Coding rules.** The constitution the code is held to.
- **Architecture rules.** How the application comes together.

The onboarding skill produces both, in `docs/CODING-RULES.md` and `docs/ARCHITECTURE.md`. If they are missing, say so and run onboarding first. A design has nothing to stand on without them, and every review that should catch drift has no standard to measure against.

## The workflow

Repository tooling and maintenance work does not need a new spec merely because it changes code or behaviour inside the repository. Handle changes to development scripts, linters, formatters, CI configuration, agent instructions and similar project infrastructure directly unless the user explicitly asks for a spec, design or plan. If tooling changes shipped product behaviour, use the workflow for that behaviour.

Work out which phase the user is in and read that phase's guide in full before writing anything. The guides carry the detail; this file only routes.

### 1. Spec

Read `references/writing-specs.md`. Start from `references/templates/spec.template.md`.

The spec is written by interviewing the user, section by section. Propose defaults drawn from the code and the neighbouring specs, but a default only lands once the user has said yes to it, so that every line is something a person chose. Behaviour is an action and an observable result, numbered so tests can name what they prove, and every entry point has to be drivable by an automated test that runs unattended in a pipeline.

Gate: a subagent with a clean context reviews the spec for completeness, findings come back until a review is clean, and then the user approves it.

### 2. Design

Read `references/writing-designs.md`. Start from `references/templates/design.template.md`.

The design names the components, shows how they relate and how they behave at runtime, and fixes which files are in scope and which are deliberately untouched. It shows shape, never code: signatures, not bodies. It extends the patterns the codebase already uses rather than starting a second architecture alongside the first.

Gate: reviewed against the spec by a fresh subagent. Gaps go back to whichever document owns them, and the design is approved only once it and the spec agree.

### 3. Plan

Read `references/writing-plan.md`. Start from `references/templates/plan.template.md`.

The plan orders the work into waves, where the steps inside a wave share no files and need nothing from each other, so each one can be handed to its own subagent. It names the acceptance tests before any code is written, and every numbered item in the spec gets a row in a coverage table pointing at the test that proves it and the command that runs it.

Gate: reviewed for completeness by a fresh subagent, then approved by the user before a single step runs.

### 4. Implementation and review

Read `references/implementing-specs.md`, and the "Executing the plan" and "Review at the end of implementation" sections of `references/writing-plan.md`.

Waves run in order, steps within a wave in parallel. The test run between waves is a build gate and not a review: if the suite passes, the next wave starts immediately. Nobody reads the diff and nobody approves anything until the whole spec is delivered, because a reviewer looking at part of a feature cannot tell a gap from work that has not happened yet.

Gate: a subagent with a clean context reviews the finished change against the spec, the design, and the plan, and runs the tests itself rather than trusting a report. Findings come back to the implementer until a review is clean. Then the user accepts the work, the spec and design move to implemented, and the plan is deleted.

## Where the documents live

- Create one kebab-case directory per feature at `<repo-root>/docs/specs/<spec-name>/`.
- Put the behaviour specification at `<repo-root>/docs/specs/<spec-name>/spec.md`.
- Put its design at `<repo-root>/docs/specs/<spec-name>/design.md`.
- `plans/` at the repository root, named after the design it implements. Never in `docs/`: a plan is not documentation, and a reader browsing the docs should not find one.

## When something is not covered

At any point, if the work needs a decision the documents do not contain, stop and put the question where the answer belongs. Behaviour goes to the spec, shape goes to the design. Set that document back to draft, and resume once a person has answered.

Do not guess to keep moving. A guess written into a spec is indistinguishable from a decision, and the next reader will build on it.

## Reference files

| File | Read it when |
| --- | --- |
| `references/writing-specs.md` | Writing or changing a spec |
| `references/writing-designs.md` | Writing or changing a design |
| `references/writing-plan.md` | Writing a plan, and while executing one |
| `references/implementing-specs.md` | Implementing a plan |
| `references/templates/spec.template.md` | The starting point for a spec |
| `references/templates/design.template.md` | The starting point for a design |
| `references/templates/plan.template.md` | The starting point for a plan |

Every template carries `hint:` lines under each heading explaining what belongs there. Delete each hint once its section is written; a finished document has none left in it.
