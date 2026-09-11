---
name: spec-driven-development
description: "Build product features through approved specs, designs and implementation plans. Use when the user requests one of those phases, asks to implement an existing plan, or changes shipped product behaviour that no spec covers. Do not start a new spec for repository tooling or maintenance unless the user explicitly requests one."
---

# Spec-driven development

Build features in four approved phases: behaviour specification, technical design, implementation plan, then implementation. Write each artefact for a developer with no prior context.

## Scope

Do not start this workflow merely because repository code or behaviour changes. Handle development scripts, linters, formatters, CI configuration, agent instructions and similar project infrastructure directly unless the user explicitly asks for a spec, design or plan. If tooling changes shipped product behaviour, apply the workflow to that behaviour.

Before creating a spec, check whether an existing spec owns the behaviour and update it instead. Start at the phase the user requested when its prerequisites are approved; do not recreate completed phases.

## Sources of truth

- The spec owns observable behaviour.
- The design owns code shape.
- The plan is a temporary work order and is deleted after the user accepts the implementation.
- Never rewrite a spec or design to match code that drifted from it.

If work reveals an uncovered decision, stop. Put behaviour questions in the spec and shape questions in the design, set that document to draft and resume only after a person answers and approves it. Do not hide the decision in code or a test.

## Prerequisites

The repository needs coding and architecture rules before design work. Look for `docs/CODING-RULES.md` and `docs/ARCHITECTURE.md`, or the repository's documented equivalents. If they are missing, say so and use the onboarding skill before designing.

## Route by phase

Read only the references for the active phase, in full.

| Phase | Read | Start when | Finish when |
| --- | --- | --- | --- |
| Spec | `references/writing-specs.md` and `references/templates/spec.template.md` | Behaviour needs a new or changed spec | The user approves |
| Design | `references/writing-designs.md` and `references/templates/design.template.md` | The spec is approved | The user approves |
| Plan | `references/writing-plan.md` and `references/templates/plan.template.md` | The spec and design are approved | The user approves |
| Implementation | The `Executing the plan` section of `references/writing-plan.md` | The plan is approved | Tests pass, the user accepts, and the plan is deleted |

Do not load guides or templates for later phases in advance.

## Optional agent reviews

Do not run an agent review automatically or make it a phase gate. When the user explicitly asks for an agent to review a spec, design, plan or implementation, read `references/reviewing.md` and follow the checklist for that artefact.

## Document locations

Use a kebab-case feature directory:

- Spec: `<repo-root>/docs/specs/<spec-name>/spec.md`
- Design: `<repo-root>/docs/specs/<spec-name>/design.md`
- Plan: follow the repository convention, or use `<repo-root>/plans/<design-name>.md`. Never put plans in `docs/`.

Templates contain `hint:` lines. Remove every hint from a completed artefact.
