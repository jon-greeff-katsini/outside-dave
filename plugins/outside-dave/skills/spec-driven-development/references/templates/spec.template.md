# Spec Name

Status: <draft | approved | implemented | superseded>
Designs: <paths to the design documents that implement this spec>

## Overview
hint: A short description of this spec.

## Actors
hint: Who interacts with this feature and what each one is allowed to do. For example, an anonymous visitor, a signed-in customer, an admin, or another system.

- <actor>

## Use Cases
hint: How this feature gets consumed. List every entry point. For example, a browser-linked page, a REST API URL, or a CLI command. Every entry point must be drivable by an automated test that runs unattended in a pipeline, so say what drives it: a browser, an HTTP request, a command run as a subprocess. An entry point nothing can drive cannot be proved, and the spec is not finished until it can.

- <entry point>
  - Driven by: <browser page | HTTP request | CLI subprocess>

## Interfaces & Data
hint: The contract of each entry point: what it accepts and what it returns. For an API, the request and response shapes and status codes. For a CLI, the arguments, flags, output, and exit codes. For a page, the fields shown and the controls available. Acceptance tests are written against this, so be exact.

- <entry point>
  - Inputs: <inputs>
  - Outputs: <outputs>

## Out of Scope
hint: What this feature deliberately does not do, so nobody builds it. Include anything a reader might reasonably assume is included.

- <non-goal>

## User Stories & Acceptance Criteria
hint: Repeat for each user story. Name the actor in each story. Each acceptance criterion is an action the actor takes and the result they observe, and it is verified by a test that performs that action through one of the entry points listed in Use Cases and checks for that result. If the criterion says "when a user clicks the button, an alert shows", the test clicks the button and asserts the alert shows. Tests against internal functions do not count. Number stories US-1, US-2 and criteria AC-1.1, AC-1.2 so each test can name the criterion it proves. Once assigned, a number is never reused, even if the story is removed.

- US-1: <story>
  - AC-1.1: <acceptance criterion>
  - AC-1.2: <acceptance criterion>

## Edge Cases & Error Handling
hint: What happens on bad input, missing data, timeouts, unauthorised callers, or unexpected state. Each case states the condition and the expected behaviour, and is tested the same way as an acceptance criterion: through an entry point, not an internal function. Number them EC-1, EC-2 so tests can name them.

- EC-1: <condition>
  - <expected behaviour>

## Constraints
hint: Non-functional requirements this feature must meet: performance, security, concurrency, data retention, accessibility. Only list the ones that apply. Write "None" if none do, so a reader knows it was considered.

- <constraint>

## Dependencies
hint: Other specs, services, or features this one relies on or changes. Re-read these when this spec changes. Include whatever an automated test needs to reach the entry points: test credentials, seed data, a sandbox account, a stubbed third party.

- <dependency>

## Open Questions
hint: Decisions not yet made. Each one must be resolved before the spec is approved. If design or implementation reveals behaviour this spec does not cover, it goes here and work stops until it is answered.

- <question>

