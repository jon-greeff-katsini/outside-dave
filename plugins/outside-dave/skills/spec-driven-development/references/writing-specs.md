# Writing specs

A spec describes how a feature behaves as seen from outside the system. It says who uses it, where they reach it, what they do, and what they observe. It does not say how the code is shaped. That belongs in the design document.

Write every spec so a developer who has never seen the codebase could build the feature without asking a question. If they would need to ask, the spec has a gap. The same test is what makes a spec safe for an agent to work from.

Use `templates/spec.template.md` as the starting point. This document explains how to fill it in well.

## Before you write

Check whether a spec already covers this behaviour. If one does, change it rather than write a second one. Two specs describing the same feature will disagree eventually, and nobody will know which one the code follows.

Read the specs that neighbour this one: anything the feature calls, anything that calls it, and anything that shares its data. These become the Dependencies section, and reading them first stops you contradicting behaviour that is already agreed.

Look at the existing behaviour in the code where the feature touches something that already works. The spec must describe what the system will do after the change, so you need to know what it does now.

Follow the repository's convention for where specs live and how they are named. If there is none, put them in `docs/specs/` as one file per feature, named in kebab-case after the feature.

## Interviewing the user

The spec records the user's decisions, not yours. Work through the template with them one section at a time. For each section, ask what they want, listen, and write down what they say.

You may propose a sensible default for any section. Draw it from the code, the neighbouring specs, and the conventions the project already follows, and put it to the user as a proposal: this is what I would suggest, is it right? A default only goes into the spec once the user has said yes to it. Never write one in as though it were agreed and wait to see if anyone objects.

This holds even when the user asks you to decide. Present the choice and the default, and get their yes. It costs one exchange and it means every line in the spec is something a person chose.

Ask with concrete examples rather than abstract questions. "Should an anonymous visitor be able to see this page?" gets an answer. "Who are the actors?" gets a shrug. Where the code already does something, show the user what it does now and ask whether that should stay.

Anything the user cannot answer goes into Open Questions with their name against it. Do not fill the gap yourself.

## Filling in the template

Work through the sections in the order they appear, interviewing the user as you go. Each one narrows the next. Actors and Use Cases fix who and where. Interfaces & Data fixes the contract. Out of Scope draws the boundary. Only then do User Stories and Edge Cases describe behaviour, because by that point there is nothing left to be vague about.

Fill every section. Where a section has nothing in it, write "None" so a reader knows it was considered rather than forgotten. Constraints and Dependencies are the usual candidates.

Delete each hint once the section under it is written. A finished spec has no hints in it.

Keep the section headings and their order as the template has them. A reader who knows one spec should be able to find their way around any other.

## Writing behaviour

Every acceptance criterion and every edge case is an action and an observable result. The actor does something through an entry point, and something they can see, receive, or read happens. If you cannot say what the actor observes, you have not finished describing the behaviour.

One behaviour per criterion. "The user can save and the list refreshes" is two criteria. Splitting them keeps each test small and makes it clear which one failed.

Name the actor in every story. "A user" hides whether an anonymous visitor and an admin see the same thing. If they do, say so. If they do not, that is two stories.

Use numbers and observable results, never adjectives. "Fast" becomes "responds within 300 ms". "Handles errors gracefully" becomes "shows the message 'Voucher expired on 12 March' and leaves the form contents in place". "Appropriate access" becomes a list of who can do what. Any quality you cannot test as written will be decided by whoever implements it.

Describe what the actor sees, not what the code does. "The order is saved to the database" is design. "The order appears in the customer's order history within five seconds" is behaviour. If a sentence mentions a class, a table, a service, or a file, it belongs in the design document.

Cover the error paths with the same care as the happy path. For every input, ask what happens when it is missing, malformed, too large, or arrives twice. For every actor, ask what happens when they are not allowed. Each answer is an edge case with its own number.

Be exact in Interfaces & Data. Give field names, types, and the values a field may hold. For an API, list the status codes and what triggers each. For a command, list the flags and exit codes. Include one real example per entry point: a full request and response, or a command and its output. An example constrains an implementer more than any description.

## Automated verification

Every entry point in Use Cases must be reachable by an automated test that a pipeline can run unattended. Name what drives it: a browser page driven by the project's browser tool, an HTTP endpoint driven by a request, a command run as a subprocess. If nothing can drive an entry point, the feature cannot be proved and the spec is not finished. Take that back to the user before writing behaviour against it.

Unattended means no human in the loop. No manual sign-in, no clicking through a consent screen, no reading a value off a dashboard, no step that only works on the author's machine. A test that needs a person to start it or judge it will be skipped in the pipeline, and a skipped test reports as a passing build.

The spec names the driver, not the test. "AC-2.1 is proved by driving the voucher form in a browser" belongs in the spec. The framework, the file, and the command belong in the plan. Keeping the two apart means the spec survives a change of test tooling.

Whatever the test needs to reach the entry point is part of the spec: test credentials, seed data, a sandbox account, a stubbed third party. List it in Dependencies. A criterion nobody can set up is a criterion nobody will prove.

Where a criterion genuinely cannot be automated, because it needs a physical device, a real payment, or a third party with no sandbox, say so against that criterion, give the exact manual steps and the expected result, and put it to the user as a cost they are accepting. It is a decision, not a default, and every one of them is a hole in the pipeline.

## Numbering

Stories are US-1, US-2, and so on. Criteria under a story are AC-1.1, AC-1.2. Edge cases are EC-1, EC-2. Tests name the number they prove, so a reviewer can check coverage by reading the test names.

A number is never reused. If US-2 is removed, the next story is still US-4, not US-2. Renumbering silently breaks every test and design that referenced the old numbers. Leave a one-line note in the spec where the removed item was, so nobody wonders about the gap.

## Open questions

Anything the spec needs and you cannot decide goes in Open Questions. Do not pick an answer to keep moving. A guess written into a spec looks identical to a decision, and the next reader will build on it.

The same rule applies later. If design or implementation turns up behaviour the spec does not cover, the question goes into the spec and work stops until someone answers it. The answer then goes into the spec, not into the code.

A spec cannot move from draft to approved while Open Questions has entries.

## Changing an existing spec

The spec changes first, then the code. Never adjust a spec to match what was built. If the built behaviour is better than what the spec said, the spec still changes first, and someone approves that change.

When you change an approved spec, set its status back to draft. Any design listed under Designs is now describing an older version of the behaviour, so flag it to whoever owns it.

Re-read the specs in Dependencies before you change anything. If the change alters behaviour they rely on, they need to change too.

## Final check

Read the spec back as the developer who has to build it, then as the tester who has to prove it.

- Could someone build this without asking a question? Every question they would ask is a gap.
- Is every criterion and edge case an action plus an observable result?
- Is there a test you could write for every numbered item, through an entry point, without touching internal code?
- Does every entry point say what drives it automatically, and could that test run in a pipeline with nobody watching?
- Is everything those tests need to run listed in Dependencies?
- Is every criterion that cannot be automated marked as such, with manual steps and the user's agreement?
- Is there any adjective doing the work of a number?
- Does any sentence describe the code rather than the behaviour?
- Is every section filled, or marked "None" on purpose?
- Are all the hints gone?
- Did the user decide every section, or did a default go in without their yes?
- Is Open Questions empty, or is the status still draft?

Fix what fails, then hand the spec to a reviewer.

## Review by a fresh reader

The author is the worst judge of whether a spec is complete. You know the feature, so you read what you meant rather than what is on the page, and your memory fills gaps the text does not. The review has to come from someone who knows nothing but what the spec says.

Launch a subagent with a clean context to do it. Give it the spec, the template, and this guide. Give it nothing else: no conversation history, no notes, no summary of the feature. If it needs more than the spec to understand the feature, that is the first finding.

The reviewer has one job: completeness. For every section, it asks whether a developer could build from it without a question, and whether a tester could prove every numbered item by driving an entry point automatically, unattended, without touching internal code. It reports each gap as the question a developer would have had to ask, named against the section where the answer belongs. It does not rewrite the spec and it does not answer the questions itself.

Every finding comes back to the author. Answer it in the spec, or move it to Open Questions if you cannot. Then send the changed spec to a new subagent, not the one that reviewed it, so the second pass is as fresh as the first. Repeat until a review comes back with nothing to report.

Only then does the spec go to the user for approval.

## Approval

A person approves a spec. The agent never does, however clean the review came back. Show the user the finished spec, tell them the review found nothing, and ask them to approve it. The status moves to approved when they say so and not before. If they ask for changes, make them, run the review again, and come back.
