# Optional agent reviews

Use this guide only when the user explicitly asks for an agent review. The review is advisory, not a phase gate.

Give a fresh-context agent the artefact under review and only the authoritative inputs listed below. Ask it to report findings with severity, evidence and the document section or file that owns the correction. The reviewer does not fix findings unless the user also asks for fixes.

## Specification

Provide the specification, its template and writing-specs.md. Check that:

- a developer can build the behaviour without asking an unanswered question
- every acceptance criterion and edge case is an action with an observable result
- every numbered behaviour is testable through a declared entry point
- automated drivers and their dependencies can run unattended
- non-automatable checks include exact manual steps and user agreement
- the document describes behaviour rather than code shape
- every section is complete, no hint lines remain and draft specs retain unresolved questions

## Design

Provide the approved specification, design, design template, writing-designs.md, architecture rules and coding rules. Check that:

- every numbered specification item maps to components and interactions
- every design element traces back to a specification item or recorded decision
- names, signatures, diagrams and component lists agree
- the design follows existing architecture or records a justified deviation
- every implementation file is listed and boundaries are explicit
- the document contains shape rather than method bodies or implementation snippets
- every section is complete, no hint lines remain and draft designs retain unresolved questions

## Plan

Provide the approved specification and design, the plan, plan template and writing-plan.md. Check that:

- every design file appears in a step and no step introduces an unlisted file
- every step names the components and specification items it delivers
- steps in the same wave have no file or output dependency
- the project builds and existing tests can pass after each wave
- every acceptance criterion and edge case maps to a real test and command
- acceptance tests drive public entry points and assert observable results
- documentation updates and exact verification commands are included
- every section is complete, no hint lines remain and draft plans retain unresolved questions

## Implementation

Provide the approved specification, design and plan, plus repository access. Check that:

- code delivers every numbered specification item and adds no unapproved behaviour
- components, signatures, interactions, changed files and boundaries match the design
- every plan step is complete
- every coverage-table test exists, drives the declared entry point, performs the specified action and asserts the observable result
- tests are not skipped, weakened or satisfied only by mocks returning configured values
- tests fail when the behaviour they claim to prove is absent
- the documented test commands pass

Return findings to the user. If there are none, say the review found no issues. Do not start repeated review cycles unless the user requests another review after fixes.
