# outside-dave

A [Claude Code](https://claude.com/claude-code) plugin marketplace for agentic development workflows. The first plugin, `outside-dave`, prepares a repository so that an outside developer, or an agent, can pick it up and contribute without asking anyone questions.

The name comes from the test the plugin applies. Imagine an outside developer, Dave, joining the project tomorrow. If Dave would have to ask someone how to run the project, where the tests live, or what the review process is, the repository isn't ready for him. And if it isn't ready for Dave, it isn't ready for an agent either.

## The problem

Agents fail in codebases for the same reason new developers do: the knowledge needed to work there isn't written down. Coding standards live in people's heads. Environment setup is folk knowledge passed on in chat. The architecture exists only as a shared mental model among people who have been there a while.

A human can ask around. An agent can't. It will guess instead, and a confident wrong guess is worse than a question. The result is agents that write code in the wrong style, break conventions nobody told them about, and can't verify their own changes because nobody documented how.

The fix isn't a better prompt. It's a repository where the answers exist and are findable.

## What the plugin does

The `outside-dave` plugin ships an **onboarding** skill. Ask Claude Code to onboard the repo (or make it agent-ready), and it will:

1. **Survey what exists.** It takes stock of the current README, contributing guide, and docs, and enriches them rather than writing competing versions. A second, conflicting source of truth is worse than a gap.
2. **Write the docs an outsider needs**, each in a predictable place:
   - `README.md`: environment setup with exact versions and commands, how to build, run, test, and debug the project, and where issues are tracked.
   - `CONTRIBUTING.md`: the pipelines a change must pass, the pull request process, branching and commit conventions, and the definition of done.
   - `docs/CODING-RULES.md`: the coding standards the codebase actually follows, derived from the code and the linting rules.
   - `docs/ARCHITECTURE.md`: the major components, the entrypoints where execution starts, and Mermaid diagrams of the core domain model and the most important flows.
   - `docs/TESTING.md`: the tests that exist across the pyramid, how to run them, and how to functionally test the product the way a user would.
3. **Wire the docs into `CLAUDE.md` or `AGENTS.md`** as one-line, task-conditioned pointers ("Before writing tests: read `docs/TESTING.md`"), so agents load the right doc at the right moment without bloating every session.
4. **Verify the onboarding works.** It launches a swarm of fresh subagents, one per doc. Each starts with none of the context built up while writing, which makes it an honest stand-in for Dave: it can only succeed on what is written down. Each subagent follows its doc step by step and fact-checks every claim against the code, the config, and the pipelines. Findings come back, the docs get fixed, and re-verification repeats until the swarm comes back clean.
5. **Keep the docs alive.** It adds a rule to `CONTRIBUTING.md` that updating these docs is part of any change that invalidates them, not a follow-up.

Where the skill can't find an answer, it asks the user rather than guessing. Anything it can't verify is marked as unverified instead of recorded as fact.

## Installation

In Claude Code:

```
/plugin marketplace add jon-greeff-katsini/outside-dave
/plugin install outside-dave@outside-dave
```

## Usage

In a repository you want to prepare, ask Claude Code in plain language:

> onboard this repo for agentic development

The skill also triggers on requests like "make this repo agent-ready", "set up CLAUDE.md and the docs behind it", or "why do agents struggle in this codebase?".

## Repository layout

```
.claude-plugin/marketplace.json     Marketplace manifest
plugins/outside-dave/               The plugin
  .claude-plugin/plugin.json        Plugin manifest
  skills/onboarding/SKILL.md        The onboarding skill
  skills/planning/SKILL.md          The planning skill
  skills/writing/SKILL.md           The writing skill
```
