---
name: planning
description: "Use before touching code on any change that needs thinking through, and always on entering plan mode or writing an implementation plan. Trigger on 'plan this', 'how should we build X', 'what is the approach', 'design this feature', 'propose the steps', 'work out how to fix this bug', 'how should we refactor this', and 'do not write code yet', even when the user never says the word plan. Produces a concise plan with an ASCII diagram, a YAGNI check, validation against the project's docs, a subagent review phase, and a verification phase."
---

# Planning

Write every plan so a junior developer could execute it without asking questions. If a step needs context the reader might not have, the plan carries that context. The same property makes the plan executable by an agent in a fresh session.

## Ground the plan in the project's rules

Before drafting, read the project's own documentation so the plan follows the house rules, not your defaults:

- `CLAUDE.md` or `AGENTS.md`, and the docs they point to
- what the product is for and what is out of scope (for example `docs/PRODUCT.md`), along with the decisions already taken, so the plan does not reopen a settled question
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

## Review
Subagent reviews of the finished change (see below).

## Verification
How the change will be proven to work (see below), ending with a
final subagent audit of the entire plan.

## Documentation
The docs this change invalidates, and the update each one needs.
```

Concrete means real paths, functions, and commands: "add `validateVoucher()` to `src/vouchers/service.ts`", not "update the voucher logic". Vague steps push the thinking onto whoever executes the plan.

## The diagram

Every plan includes one diagram showing the components the change touches and how they interact:

- a **flow** of calls or data for new or changed logic
- a **sequence** across lanes when the change spans components or services
- a **model** of the types and their relationships when the change is mostly the domain model

Draw it in ASCII inside a plain fenced block. Plans are read in a terminal, which has no Mermaid renderer: a Mermaid block arrives as its own source, so the reader parses syntax instead of seeing the shape.

Keep it small (five to ten nodes), name nodes after real files, classes, or services, and mark what is new or changed so the delta is visible at a glance. The diagram's job is to show the change, not the whole system.

```
  POST /checkout
        |
        v
  api/routes/checkout.ts
        |
        v
  vouchers/service.ts       [new] validateVoucher()
        |
        v
  vouchers/repository.ts
```

## The review phase

Once the change is implemented, review it with subagents launched in parallel. A subagent starts with none of the context built up while writing the code, so it reads the diff the way a reviewer would: it can only judge what is actually there. Each reviewer covers one concern:

- **Requirement fit**: does the change actually do what the requirement asks? Give this reviewer the original requirement and the diff, nothing else.
- **Project conventions**: does the change follow the project's documented rules? Give this reviewer the coding rules and architecture docs alongside the diff.
- **Simplicity and YAGNI**: code smells, unnecessary abstractions, speculative flexibility, and anything that could be done more simply.
- **Comments**: over-commented code. Comments that restate the code, narrate the change, or justify it to a reviewer are noise; only comments that carry constraints the code can't show should survive.

Reviewers report findings; they don't fix. Every finding comes back to the main agent to resolve, and changed code goes back through a fresh review. Repeat until the reviews come back clean.

## The verification phase

Every plan ends with a verification phase covering both kinds of testing:

- **Automated tests**: which tests will be written or updated, and the exact command that runs the suite. Follow the project's testing docs.
- **Functional testing**: the exact steps to run the product, drive the changed behaviour, and what the expected result looks like. "Run the tests" is not functional testing; using the feature is.

If a step can't be verified locally (needs credentials, a deployed environment), say so in the plan.

When verification is done, spawn one final subagent to audit the whole plan. Give it the full plan and access to the repo, and have it check every part off: each step done as written, every review finding resolved, both kinds of verification actually run, every listed doc updated. The agent that did the work is the worst judge of whether it's finished; a fresh context can only trust what it can see in the repo. The auditor reports gaps, the main agent closes them, and the work isn't complete until the audit comes back clean.

## Keep the docs from rotting

A stale doc misleads worse than a missing one, so updating docs is part of the change, not a follow-up. List every doc the change invalidates and the update each needs: the README, architecture and testing docs, coding rules, API references, runbooks. Check `CLAUDE.md` and `AGENTS.md` too; a renamed file or command breaks the pointers they hold. If nothing needs updating, say so, so the reader knows it was checked.

## Before presenting

Reread the plan as the junior who has to execute it: every step names its files, every command exists in the project, the diagram matches the steps. Fix what fails that reading, then present.
