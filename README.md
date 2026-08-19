# Outside Dave

Outside Dave is a [Claude Code](https://claude.com/claude-code) plugin marketplace for the way I
actually want to work with agents.

Picture Dave. He's outside your team and he's never seen your codebase. Can he start contributing
today without asking you a single question? If the answer is no, your AI is going to struggle for
the same reasons he would.

## Why

I've been building with LLMs since the early days. I've lived through the hype and seen most of it
up close.

Some of it I love. Some of it makes me want to go and farm goats.

What I love:

- Writing code is cheap now.
- Harnesses are cool.

What I don't:

- LLMs are dumb.
- They aren't deterministic. Give one the same problem three times and you get three different
  solutions.
- They forget most of what you're working on. Memory tools exist, they help, but they don't solve
  it.
- Most agentic frameworks are bloated. They're documentation-heavy or opinionated.

And one thing that isn't up for negotiation either way: **I like to read the code.**

Agentic development fails the same way codebases have always failed:

- The domain lives in one person's head.
- Coding standards change with every new tech lead.
- Onboarding is "go and read the repo", and the repo doesn't say enough.

A human can ask around. An agent can't. It will guess instead, and a confident wrong guess is worse
than a question. You get agents that write code in the wrong style, break conventions nobody told
them about, and can't verify their own changes because nobody wrote down how.

## The outside-dave test

Hand your codebase to a junior. If they can't find their way around it without asking questions, no
AI will manage it either.

That's the whole test. How you pass it is up to you: self-documenting code, onboarding docs,
diagrams, whatever fits. What matters is that everything a newcomer needs is in the repository and
not in your head.

Outside Dave is my answer to that: a repository where the answers exist and can be found, plans
that carry their own context, and writing an outsider can follow.

**Disclaimer:** none of this replaces being good at your craft. The best results come from people
who read the code and could have written it themselves.

## The skills

The `outside-dave` plugin ships three skills.

### Onboarding

Onboarding is simple, and it's the most valuable thing you can do.

It works like `/init` in Claude Code, but it aims somewhere else. CLAUDE.md and AGENTS.md are
written for agents. Outside Dave onboards the repository for a new starter, so a human arrives with
the same shot at success the agent gets.

Ask Claude Code to onboard the repo (or make it agent-ready), and it will:

1. **Survey what exists.** It takes stock of the current README, contributing guide, and docs, and
   builds on them rather than writing competing versions. A second, conflicting source of truth is
   worse than a gap.
2. **Write the docs an outsider needs**, each in a predictable place:
   - `README.md`: environment setup with exact versions and commands, how to build, run, test, and
     debug the project, and where issues are tracked.
   - `CONTRIBUTING.md`: the pipelines a change must pass, the pull request process, branching and
     commit conventions, and the definition of done.
   - `docs/CODING-RULES.md`: the coding standards the codebase actually follows, derived from the
     code and the linting rules.
   - `docs/ARCHITECTURE.md`: the major components, the entrypoints where execution starts, and
     Mermaid diagrams of the core domain model and the most important flows.
   - `docs/TESTING.md`: the tests that exist across the pyramid, how to run them, and how to
     functionally test the product the way a user would.
3. **Wire the docs into `CLAUDE.md` or `AGENTS.md`** as one-line, task-conditioned pointers
   ("Before writing tests: read `docs/TESTING.md`"), so agents load the right doc at the right
   moment without bloating every session.
4. **Verify the onboarding works.** It launches a swarm of fresh subagents, one per doc. Each starts
   with none of the context built up while writing, which makes it an honest stand-in for Dave: it
   can only succeed on what is written down. Each subagent follows its doc step by step and
   fact-checks every claim against the code, the config, and the pipelines. Findings come back, the
   docs get fixed, and re-verification repeats until the swarm comes back clean.
5. **Keep the docs alive.** It adds a rule to `CONTRIBUTING.md` that updating these docs is part of
   any change that invalidates them, not a follow-up.

It interviews you where it can't find an answer, rather than guessing. Anything it can't verify is
marked as unverified instead of recorded as fact.

### Planning

Triggers whenever Claude Code enters plan mode or is asked to design an approach. Every plan is
written so a junior developer, or an agent in a fresh session, could execute it without asking
questions.

The plan is drafted after reading `CLAUDE.md`, the coding rules, and the architecture and testing
docs (the same docs the onboarding skill produces), and checked against them before you see it.
It's YAGNI (you aren't gonna need it) by default: the smallest change that fully satisfies the
request, no speculative abstractions, no opportunistic refactoring. Each step names the exact
files it touches, and a small Mermaid diagram shows the components the change affects.

Once implemented, fresh subagents review the diff in parallel, one concern each: requirement fit,
project conventions, simplicity, and comment noise. Findings are fixed and re-reviewed until
clean. Then verification: the automated tests run, the feature gets used the way a user would use
it, and a final subagent audit checks every part of the plan off against the repo. The plan also
lists the docs the change invalidates and the update each needs.

Then you come in. Read the code, leave comments, and iterate.

### Writing

Triggers on any task that produces words a human will read: docs, code comments, docstrings, commit
messages, PR descriptions, error messages. It sets the voice and grammar (lead with the point, short
sentences, plain words, British spelling, no AI-tells), and adds rules per artefact: comments state
only what the code can't show, docstrings are one active-voice sentence, and error messages say what
went wrong and what to do next.

## Installation

In Claude Code:

```
/plugin marketplace add jon-greeff-katsini/outside-dave
/plugin install outside-dave@outside-dave
```

## Usage

The skills trigger on plain language; you don't need to name them.

- **Onboarding**: "onboard this repo for agentic development", "make this repo agent-ready", or "why
  do agents struggle in this codebase?"
- **Planning**: enter plan mode, or ask for a plan or an approach: "plan how to add rate limiting to
  the API".
- **Writing**: any task that produces prose triggers it automatically, from a README rewrite to a
  commit message.

## Repository layout

```
.claude-plugin/marketplace.json     Marketplace manifest
plugins/outside-dave/               The plugin
  .claude-plugin/plugin.json        Plugin manifest
  skills/onboarding/SKILL.md        The onboarding skill
  skills/planning/SKILL.md          The planning skill
  skills/writing/SKILL.md           The writing skill
```
