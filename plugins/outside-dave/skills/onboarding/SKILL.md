---
name: onboarding
description: "Use when onboarding a repository for agentic development: preparing it so an outside developer, or an agent, can pick it up without asking questions. Trigger whenever the user asks to onboard a repo or project, make it agent-ready, prepare it for Claude, set up CLAUDE.md or AGENTS.md and the docs behind them, or asks why agents struggle to work in this codebase, even if they never say the word onboarding."
---


# Onboarding

A repository is only as good for agentic development as it is for a junior developer to pick up. If an outsider can follow the code, find the standards, and see how to contribute without asking anyone, an agent can too. Onboarding the repository properly is what sets agents up for success.

## Golden rule

If an outside developer would need to ask questions about the repository, it is probably not mature enough to be worked on agentically.

## Before you write

Everything this skill produces is prose a person reads. Invoke the `writing` skill with the Skill tool before drafting any of it.

## Survey what already exists

Before writing anything, take stock of the documentation the repository already has: the README, a CONTRIBUTING file, anything under `docs/`, and any wiki or Confluence pages the repo links to.

For each file this skill produces, check whether an equivalent already exists. If it does, enrich it rather than write a competitor. A second, conflicting source of truth is worse than a gap. If an existing doc is stale, correct it as part of this work, and flag anything you cannot verify to the user.

## Standards

Check whether the repository has linting rules. If it has none, flag this to the user and explain why they matter: without them, standards live in people's heads, and neither an outsider nor an agent can follow them.

Read the linter config to learn what is already enforced, then keep every bit of it out of `docs/CODING-RULES.md`. Name the config file and move on. A linted rule is enforced on every commit whether or not anyone wrote it down, so a prose copy of it is a second source of truth that goes stale the moment someone edits the config.

What belongs in the file is only what no tool will fail a contributor for: naming conventions, the base classes to inherit, how modules are allowed to depend on each other, the decisions that must be made deliberately rather than by default. Work these out from the code itself and record them in `docs/CODING-RULES.md`.

Two tests before a rule goes in:

- **Could a linter enforce this?** Then it belongs in the linter config. If it should be enforced and isn't, propose the linter rule to the user rather than writing a prose rule nobody runs.
- **Is it a rule or a description?** "Inherit `ModelBase`" is a rule. "This foreign key cascades because the child is meaningless without its parent" is a fact about today's code, and facts about today's code rot. Write rules, and cite real code as an example of a rule, never in place of one.

Keep tooling and workflow out as well: how to run the formatter, which commands to avoid, how the build behaves. That is `README.md` or `CONTRIBUTING.md`. And where a rule exists only to work around an unfixed problem in the repository, say so and propose the fix instead of making the workaround permanent.

## Environment setup

Work out everything an outsider needs before the project will run at all:

- the tools required and their versions: runtime, package manager, SDKs, CLIs
- environment variables and configuration values, what each one is for, and where its value comes from
- secrets: where a new developer obtains them, and where they live locally. They belong in a local `.env` file excluded from version control via `.gitignore`, never hardcoded in code or committed config.
- local services the project depends on (databases, queues, containers) and how to start them

Record this in `README.md`. This is the section outsiders get stuck on most, so be precise: name exact versions and exact commands, not "install the usual tools".

## Getting started

- Determine how to run the project: the dependencies it needs, how to build it, and how to run its tests. Record this in `README.md`.
- Determine where issues are tracked. Record this in `README.md` as well.

## Contributing

Determine how a change actually gets from an idea into the main branch, and record it in `CONTRIBUTING.md`:

- the pipelines a change must pass. At a minimum, a pipeline should cover linting, building, and running the test suite.
- the pull request process: how a change is reviewed, who reviews it, and what is required before it can merge
- the branching strategy and branch naming conventions
- commit message conventions
- the definition of done: what a change must include before it is complete, such as tests, documentation updates, or changelog entries

If the repository has no established convention for one of these, don't invent one silently. Propose one to the user and record what they agree to.

## Architecture

Determine the architecture of the product and record it in `docs/ARCHITECTURE.md`. Cover:

- the high-level architecture: the major components, what each is responsible for, and how they talk to each other
- the entrypoints: where execution starts, such as the main function, HTTP routes, scheduled jobs, message handlers, or CLI commands. An outsider reading a codebase for the first time needs to know where to start reading.
- a class diagram of the core domain model
- high-level sequence diagrams for the most important flows in the product

Use Mermaid for the diagrams so they render on the git host. Keep them at a high level: a diagram of every class is noise, and a sequence diagram of every branch is a flowchart. Diagram the model and flows an outsider must understand to make their first change safely.

## Testing

- Determine what tests exist across the testing pyramid:
  - unit tests, and how to run them
  - integration tests, and how to run them, this should include how to virtualize external dependencies

Understanding how to verify a feature the way a user would matters just as much. A developer would typically also test functionally, so work out how to functionally test the product.

Record all of this in `docs/TESTING.md`.

## Debugging

An outsider's change will break something before it works, so record how a developer actually diagnoses problems day to day:

- how to run the project while developing: watch or hot-reload mode, debug builds
- where logs go locally, and how to raise the log level
- how to attach a debugger, including editor configuration where it exists (for example a `launch.json`)
- the failure modes a new developer hits most, and their fixes: a local service not running, a stale dependency, a missing or wrong environment variable

Record this in `README.md` under a Debugging section.

## Files

These are the files the sections above record their findings in. Together they are the deliverable of this skill.

- `README.md`: environment setup, how to run the project, its dependencies, how to build it and run its tests, how to debug it, and where issues are tracked.
- `CONTRIBUTING.md`: the pipelines a change must pass, the pull request process, branching and commit conventions, the definition of done, and the documentation upkeep rule.
- `docs/CODING-RULES.md`: the naming standards, patterns and conventions a contributor must follow that no linter enforces. Anything a linter can check belongs in the linter config, not here.
- `docs/ARCHITECTURE.md`: the architecture of the product, its entrypoints, a class diagram of the core domain model, and sequence diagrams of the most important flows.
- `docs/TESTING.md`: the tests that exist across the pyramid, how to run them, and how to functionally test the product.

## Updating agents

By default, create every file this skill names, at the location it names. If the user wants the information elsewhere, record it there and treat that as the source of truth.

Update `AGENTS.md` or `CLAUDE.md` with references to these files. References only, never the content: `CLAUDE.md` loads into every session, so keep it light.

Each pointer must name the task that makes the doc worth loading, not the doc's topic. An agent reads `CLAUDE.md` before it knows which docs matter, so "architecture documentation" tells it nothing; "before changing code in an unfamiliar area" does. One line per doc, condition first:

- Before writing or changing code: read `docs/CODING-RULES.md`.
- Before a change in an unfamiliar area, or one that spans components: read `docs/ARCHITECTURE.md`.
- Before writing tests or verifying a change: read `docs/TESTING.md`.
- Before branching, committing, or opening a pull request: read `CONTRIBUTING.md`.
- When setting up, building, running, or debugging: read `README.md`.

Adjust paths and conditions to wherever the information lives. Add any other task-specific docs, such as an API reference or a runbook, in the same form.

## Verify the onboarding works

The docs are not done until they have been proven. Verify them with a swarm of subagents, one per doc, launched in parallel. A subagent starts with none of the context you built up writing these docs. That makes it an honest stand-in for the outsider: it can only succeed on what is written down.

Every subagent has the same two jobs for its doc:

1. **Follow it.** Do what the doc says, using only what is written down. Note every step that fails or turns out to be missing.
2. **Fact-check it.** Read the doc claim by claim and check each claim against the source: the code, the configuration, the pipeline definitions, and the repository settings. A doc can read perfectly and still be wrong.

Per doc, that means:

- `README.md`: set up the environment, install dependencies, build, run the project, and run the tests, from the top. Check documented versions, environment variables, and dependencies against the lockfiles and config. Trigger a failure mode from the Debugging section and confirm the documented fix resolves it.
- `CONTRIBUTING.md`: walk the path a change would take. Create a branch using the documented naming and run locally every check the pipeline runs. Then check the documented process against the real pipeline definitions, branch protection rules, required checks, and code owners.
- `docs/CODING-RULES.md`: check each rule twice, first for whether it belongs and then for whether it is true. Report as a finding any rule a linter already enforces, any tooling or workflow instruction, and any passage that describes what the code does today rather than telling a contributor what to do. Then check the rules that survive against real files in the codebase. A rule the codebase itself breaks is a caveat to note or a rule to remove.
- `docs/ARCHITECTURE.md`: read the doc, then check its claims in the source. Trace every component, entrypoint, and diagram element back to real code. Confirm the described responsibilities and interactions are what the code actually does. Names in diagrams must match names in the code.
- `docs/TESTING.md`: run every documented test command and follow the functional-testing steps end to end. Check the described test layout against the tests that actually exist.

Subagents verify and report; they do not fix. Instruct each one to return a structured list of findings: the step or claim that failed, what the doc says, and what is actually true. Every finding comes back to you, the main agent, to resolve:

- If the repository makes the fix clear, fix the doc, not just the immediate problem.
- If the fix needs a decision or knowledge you cannot verify, interview the user and record their answer. Subagents cannot talk to the user; escalating is your job, not theirs.

After fixing, launch a fresh subagent to re-verify each doc that changed. Repeat until the whole swarm comes back clean.

If a step cannot be verified, for example because it needs credentials or access you don't have, mark it as unverified in the doc and tell the user. An unverified step that is labelled honestly is fine; a wrong step recorded as fact misleads everyone who follows.

## Keeping the docs alive

Onboarding docs rot quickly, and a stale doc misleads worse than a missing one. Add a rule to `CONTRIBUTING.md`: when a change invalidates any of these docs, updating them is part of that change, not a follow-up. Suggest making it a pull request checklist item so reviewers enforce it.

## When you cannot find what you're looking for

- Do not guess, and do not assume. A wrong answer written into these files misleads every developer and agent that reads them later, which is worse than a gap.
- Verify your findings with the user before recording them. What you inferred from the code is a hypothesis, not a fact.
- If you truly cannot find anything, interview the user. Ask the questions an outside developer would typically ask to get up and running on each section.
