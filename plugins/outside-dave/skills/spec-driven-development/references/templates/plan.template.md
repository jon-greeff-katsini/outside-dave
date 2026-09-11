# Plan Name

Spec: <path to the spec this plan delivers>
Design: <path to the design this plan implements>
Status: <draft | approved | in progress>

hint: This document is the order of work and the proof each part of it landed. It is temporary. When the work is accepted the plan is deleted, so nothing that needs to outlive the job belongs here: decisions go in the design, behaviour goes in the spec, commands and manual steps go in the project docs.

## Overview
hint: One or two sentences. What gets built and in what order. A reader should know the shape of the job before reading the steps.

## Steps
hint: Steps grouped into waves. Two steps belong in the same wave when neither needs the other's output and they touch no file in common. Each wave depends on the wave before it and nothing else, and the code builds and the existing tests pass at the end of every wave. Each step names the real files it touches from the design's Files in Scope, what changes in each, the design components it builds, and the spec items it delivers by number. Every file in Files in Scope appears in at least one step, and no step touches a file outside it. Keep steps small: one component, one behaviour, or one file. A step that takes a paragraph to describe is two steps. Each step is handed to a subagent on its own, so it carries its own context and never refers to another step in its wave. Mark a step `[done]` as it is completed so a fresh session can see where to resume.

### Wave 1
1. <step>
   - Files: <path>: <what changes>
   - Components: <design component>
   - Delivers: <AC-1.1, EC-1>
2. <step>
   - Files: <path>: <what changes>
   - Components: <design component>
   - Delivers: <spec items>

### Wave 2
3. <step>
   - Files: <path>: <what changes>
   - Components: <design component>
   - Delivers: <spec items>

## Verification

### Unit tests
hint: For each component in the design, the tests that check its behaviour on its own: valid input, each kind of invalid input, and its boundaries. Follow the project's existing conventions for location and naming. Unit tests prove the parts, not the feature.

- <component>
  - <test file>: <test name> - <what it checks>

### Acceptance tests
hint: One test per acceptance criterion and per edge case in the spec. Each drives the entry point the spec names, the way the spec says it is driven, performs the action the criterion describes, and asserts the observable result it states. Nothing touches internal code, and every test runs unattended in the pipeline. Name each test for the item it proves. These are written before the implementation steps and run red first. The only manual entries here are the ones the spec already marked as impossible to automate: carry its steps and expected result across and mark them manual.

- <test file>: <test name> - proves <AC-1.1>

### Coverage table
hint: One row per AC and EC in the spec. Every numbered item has a row, and no row is blank.

| Spec item | Test file | Test name | Command |
| --- | --- | --- | --- |
| <AC-1.1> | <path> | <name> | <command> |
| <EC-1> | <path> | <name> | <command> |

### Commands
hint: The exact commands, taken from the project's testing docs. "Run the tests" is not a command.

- Unit tests: `<command>`
- Acceptance tests: `<command>`
- Full suite: `<command>`

## Documentation
hint: Every document this change invalidates and the update each one needs: README, architecture and testing docs, coding rules, API references, runbooks, and the pointers in `CLAUDE.md` or `AGENTS.md`. Updating them is part of the work. Write "None" if nothing needs updating, so the reader knows it was checked.

- <document>: <update needed>

## Open Questions
hint: Decisions not yet made. If the question is about behaviour it belongs in the spec, and if it is about shape it belongs in the design: move it there, set that document back to draft, and stop. This plan cannot move from draft to approved while this section has entries.

- <question>
