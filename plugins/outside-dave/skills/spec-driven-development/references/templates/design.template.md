# Design Name

Spec: <path to the spec this design implements>
Status: <draft | approved | implemented | superseded>

hint: This document describes the shape of the solution, not the code. Name the parts, show how they connect, and stop there. No method bodies, no snippets.

## Overview
hint: One paragraph. What the design adds or changes in the system, and the shape it takes. A reader should be able to picture the result before reading further.

## Components
hint: Each class, module, or service the design introduces or changes, with a single responsibility each. Use the real names that will appear in the code. Mark each as new or changed.

- <component> (<new | changed>): <responsibility>

## Class Diagram
hint: The components above and how they relate: inheritance, composition, dependencies. Show attributes and method signatures by name and type only. Mark new and changed classes so the delta is visible at a glance. Keep it to the classes this design touches, not the whole system.

```mermaid
classDiagram
  class <ClassName> {
    +<attribute> <type>
    +<method>(<args>) <returnType>
  }
  <ClassName> --> <OtherClass> : <relationship>
```

## Interactions
hint: One sequence diagram per entry point in the spec's Use Cases. Show the calls between components from the entry point to the result, including the error path where the spec's Edge Cases require one.

### <entry point>

```mermaid
sequenceDiagram
  actor <Actor>
  <Actor> ->> <Component> : <call>
  <Component> ->> <OtherComponent> : <call>
  <OtherComponent> -->> <Component> : <result>
  <Component> -->> <Actor> : <result>
```

## Data Model
hint: Entities this design adds or changes: fields, types, relationships, and where each is stored. Only what changes. Leave existing entities out unless a field on them moves.

- <entity> (<new | changed>)
  - <field>: <type>

## Files in Scope
hint: Every file this design creates, changes, or deletes, with one line on what it holds. Anything not listed is out of scope for the implementation.

- New
  - <path>: <purpose>
- Changed
  - <path>: <what changes>
- Deleted
  - <path>: <why>

## Boundaries
hint: Components, layers, or files this design deliberately does not touch, especially ones a reader might expect it to. This is what stops the change spreading.

- <boundary>

## Design Decisions
hint: Choices where more than one shape would have worked. State the choice, the alternative rejected, and the reason in one or two sentences. Skip anything that had only one sensible answer.

- <decision>: <alternative rejected>. <reason>

## Open Questions
hint: Decisions not yet made. Each one must be resolved before the design is approved. If implementing reveals something the design does not cover, it goes here and work stops until it is answered.

- <question>
