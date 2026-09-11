# Writing designs

A design describes the shape the code will take to deliver a spec. It names the parts, shows how they connect, and lists the files that will change. It does not contain the code. If a developer needs the design to know what to build, they need the code to know how it was built, and the two should not be confused.

Write every design so a developer who has never seen the codebase could build the feature in the right shape without asking a question. The spec covers the right behaviour. The design covers the right classes in the right files, talking to each other in the right order. If they would have to guess where something goes, the design has a gap.

Use `templates/design.template.md` as the starting point. This document explains how to fill it in well.

## Before you write

Read the spec the design implements, all of it. If the spec is still a draft, stop. A design built on unapproved behaviour will be rebuilt when the behaviour changes, and the rebuild is rarely clean.

Read the repository's architecture and coding rules. The onboarding skill puts these in `docs/ARCHITECTURE.md` and `docs/CODING-RULES.md`, though the project may keep them elsewhere. A design that ignores them will be rejected in review or, worse, accepted and start a second architecture alongside the first. If the documents do not exist, say so and stop. The design has nothing to stand on.

Read the code the design will touch. Find the existing components the feature will call or extend, the patterns the codebase already uses for the same kind of problem, and the tests that cover the area. The design extends what is there. It does not start again.

Check whether a design already covers this part of the system. If one does, change it rather than write a competitor.

Write the design to `<repo-root>/docs/specs/<spec-name>/design.md`, beside the specification it implements.

## Filling in the template

Set the Spec line first. Everything else in the document is derived from that spec, and the reviewer needs to know which one.

Work through the sections in order. Components names the parts. The class diagram shows how they relate. Interactions shows how they behave at runtime. Data Model, Files in Scope, and Boundaries fix where things live and where they stop. Design Decisions and Open Questions record what was chosen and what was not.

Fill every section. Write "None" where a section has nothing in it, so a reader knows it was considered. Data Model and Deleted files are the usual candidates.

Delete each hint once its section is written. A finished design has no hints in it.

## Shape, not code

Name things as they will appear in the code. A component called "the validator" in the design and `VoucherRules` in the code forces every reader to hold a translation table. Use the real class, module, and file names, and if a name is still undecided, decide it now. Naming is a design decision.

Show signatures, not bodies. A method appears in the class diagram with its name, arguments, and return type. What it does inside is the implementer's problem, and writing it out in the design is how designs turn into half-finished code that then gets copied. If you find yourself writing a code snippet, stop and ask what shape you were trying to show. Show that instead.

Follow the patterns the codebase already uses. If services talk to repositories, the new service talks to a repository. If errors are returned rather than thrown, the new code returns them. A design that introduces a new pattern for one feature is proposing an architecture change, and that needs its own conversation before this design proceeds.

Design the smallest shape that satisfies the spec. No interface with one implementation. No configuration for a value that never varies. No abstraction for a caller that does not exist yet. No refactoring of neighbouring code bundled in because you were passing. Each of these makes the diagram bigger and the feature no better, and each is a place for the implementation to drift.

## Diagrams

Every design has one class diagram and one sequence diagram per entry point in the spec's Use Cases. Write them as fenced Mermaid blocks so they render wherever the document lands.

The class diagram shows only the classes this design touches. Mark each as new or changed, so the reader sees the delta and not the system. If it has more than about fifteen classes, the design is too big and should be split, or it is showing classes that do not change and should not be there.

Each sequence diagram starts at an actor from the spec and ends at the result that actor observes. Between them, it shows every component the call passes through, in order. Where the spec lists an edge case for that entry point, the diagram shows the error path too, or a second diagram does.

The diagrams and the Components list must agree. Every class in a diagram is in the list, and every component in the list appears in at least one diagram. A component that appears nowhere at runtime is either missing from a sequence or not needed.

## Tracing to the spec

Every numbered item in the spec has a home in the design. For each story, criterion, and edge case, you should be able to point at the components that deliver it and the sequence diagram that shows it happening. If you cannot, the design does not cover the spec.

Every entry point in the spec's Use Cases has a sequence diagram. Every field in the spec's Interfaces & Data appears in the Data Model or in a signature in the class diagram. Every constraint in the spec is either met by the shape shown or addressed in Design Decisions.

The reverse also holds. Every component, file, and entity in the design exists because some spec item needs it. If you cannot name the spec item that requires a piece of the design, remove the piece or record in Design Decisions why it is there.

## Files in scope

List every file the implementation will create, change, or delete. That includes test files, since tests are code, and documentation the change invalidates. Use real paths. A file listed as "somewhere under services" is a question, not an answer.

Anything not listed is out of scope, and an implementer who finds they need to touch an unlisted file has found a gap in the design. That is the point of the list. It is what lets a reviewer say the change spread further than agreed.

Boundaries is the same idea from the other side. Name the components, layers, or files a reader would expect this design to touch and it does not. Saying so is what stops an implementer wandering in.

## Decisions

Record only the forks in the road: places where two shapes would have satisfied the spec and you chose one. State the choice, the alternative, and the reason in a sentence or two. The reason usually comes from a spec constraint, an architecture rule, or an existing pattern in the code.

Skip anything with one sensible answer. A decisions list full of obvious choices buries the real ones.

## Open questions

Anything the design needs and you cannot decide goes in Open Questions. Do not pick a shape to keep moving. A guess in a design becomes code, and code is expensive to unpick.

If the question is about behaviour rather than shape, it belongs in the spec's Open Questions, not the design's. Move it there, set the spec back to draft, and stop. The design waits for the spec.

A design cannot move from draft to approved while Open Questions has entries.

## Changing an existing design

When the spec changes, the design goes back to draft. Re-read the whole design against the new spec, rather than the part that seems affected. Behaviour changes have a habit of moving data, and moved data changes signatures.

When implementation reveals the design does not work, the design changes first, then the code. Never adjust a design to match what was built. If the shape that got built is better, the design still changes first, and someone approves that change.

## Final check

Read the design back as the developer who has to build it, then as the reviewer who has to check the code against it.

- Could someone build this in the right shape without asking where anything goes?
- Does every numbered spec item have components and a sequence diagram that deliver it?
- Does every piece of the design trace back to a spec item, or to a recorded decision?
- Do the diagrams and the Components list agree?
- Does every name match what will appear in the code?
- Is there any snippet or method body where a signature would do?
- Does the shape follow the architecture and coding rules, or is a deviation recorded and justified?
- Is every file the implementation will touch listed, with a real path?
- Is every section filled, or marked "None" on purpose?
- Are all the hints gone?
- Is Open Questions empty, or is the status still draft?

Fix what fails, then hand the design to a reviewer.

## Review by a fresh reader

The author is the worst judge of whether a design is complete. You have read the spec and the code, so you see connections the document does not draw, and you read structure into diagrams that a stranger would not. The review has to come from someone who knows only what the design and the spec say.

Launch a subagent with a clean context to do it. Give it the design, the spec it implements, the template, this guide, and the architecture and coding rules. Give it nothing else: no conversation history, no notes, no summary of the feature. If it needs more than those documents to understand the design, that is the first finding.

The reviewer has two jobs, both about completeness. First, coverage: it works through every numbered item in the spec and confirms the design shows how it is delivered. Second, buildability: for every section, it asks whether a developer could build in the right shape without a question. It reports each gap as the question a developer would have had to ask, named against the section where the answer belongs. It does not redesign and it does not answer the questions itself.

Every finding comes back to the author. Answer it in the design, or move it to Open Questions if you cannot. If the gap turns out to be in the spec, it goes to the spec's Open Questions and the spec goes back to draft. Then send the changed design to a new subagent, not the one that reviewed it, so the second pass is as fresh as the first. Repeat until a review comes back with nothing to report.

Only then does the design go to the user for approval.

## Approval

A person approves a design. The agent never does, however clean the review came back. Show the user the finished design, tell them the review found nothing, and ask them to approve it. The status moves to approved when they say so and not before. If they ask for changes, make them, run the review again, and come back.
