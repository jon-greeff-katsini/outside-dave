---
name: planning
description: "Use whenever entering plan mode or writing an implementation plan: designing how to build a feature, fix a bug, or refactor before touching code. Trigger on any request to plan, design an approach, or propose implementation steps, even if the user never says the word plan. Produces a concise plan with a diagram, a YAGNI check, validation against project rules, and a verification phase."
---

# Planning

Write every plan so a junior developer could execute it without asking questions. If a step needs context the reader might not have, the plan carries that context. The same property makes the plan executable by an agent in a fresh session.

## Ground the plan in the project's rules

Before drafting, read the project's own documentation so the plan follows the house rules, not your defaults:

- `CLAUDE.md` or `AGENTS.md`, and the docs they point to
- coding rules and linter configs (for example `docs/CODING-RULES.md`)
- architecture docs when the change spans components (for example `docs/ARCHITECTURE.md`)
- testing docs (for example `docs/TESTING.md`), so verification uses the project's real test commands

Validate the drafted plan against these before presenting it. If the plan must break a documented convention, say so and why, so the reader approves the deviation knowingly.

## YAGNI is the default

Plan the smallest change that fully satisfies the request. Apply this when designing the code paths; it doesn't need its own section in the plan:

- no abstractions for hypothetical future callers: no single-implementation interfaces, no config for values that never vary
- no opportunistic refactoring bundled into the change
- prefer extending existing code over adding new layers

## Structure of the plan

Keep the plan readable in a couple of minutes. Use this shape:

```markdown
## What and why
One or two sentences: the change, and the problem it solves.

## How it fits together
A diagram (see below), plus a sentence or two walking through it.

## Steps
1. Ordered, concrete steps. Each names the exact file(s) it touches
   and what changes.

## Verification
How the change will be proven to work (see below).

## Documentation
The docs this change invalidates, and the update each one needs.
```

Concrete means real paths, functions, and commands: "add `validateVoucher()` to `src/vouchers/service.ts`", not "update the voucher logic". Vague steps push the thinking onto whoever executes the plan.

## The diagram

Every plan includes one diagram showing the components the change touches and how they interact:

- a **flowchart** for new or changed logic
- a **sequence diagram** when the change spans components or services
- a **class diagram** when the change is mostly the domain model

Write it as a fenced Mermaid block so it renders wherever the plan lands in markdown. Keep it small (five to ten nodes), name nodes after real files, classes, or services, and mark what is new or changed so the delta is visible at a glance. The diagram's job is to show the change, not the whole system.

## The verification phase

Every plan ends with a verification phase covering both kinds of testing:

- **Automated tests**: which tests will be written or updated, and the exact command that runs the suite. Follow the project's testing docs.
- **Functional testing**: the exact steps to run the product, drive the changed behaviour, and what the expected result looks like. "Run the tests" is not functional testing; using the feature is.

If a step can't be verified locally (needs credentials, a deployed environment), say so in the plan.

## Keep the docs from rotting

A stale doc misleads worse than a missing one, so updating docs is part of the change, not a follow-up. List every doc the change invalidates and the update each needs: the README, architecture and testing docs, coding rules, API references, runbooks. Check `CLAUDE.md` and `AGENTS.md` too; a renamed file or command breaks the pointers they hold. If nothing needs updating, say so, so the reader knows it was checked.

## Before presenting

Reread the plan as the junior who has to execute it: every step names its files, every command exists in the project, the diagram matches the steps. Fix what fails that reading, then present.
