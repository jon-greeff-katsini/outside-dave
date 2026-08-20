# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this repository is

A Claude Code plugin marketplace. Almost everything here is markdown that gets loaded into another
Claude Code session as skill instructions; the one exception is a small shell hook. There is no
build, no test suite, no linter, and no CI. Verification is reading the prose and, where practical,
running a skill against a real repository. A hook is verified by piping a sample event into it, as
the header comment on each one shows.

Because the deliverable is prose, the repository's own writing is governed by its own `writing`
skill (`plugins/outside-dave/skills/writing/SKILL.md`). Read it before editing any file here,
including this one, commit messages, and PR descriptions. The rules that catch people out most:
British spelling, Oxford comma, no em-dashes, no emoji, no hype.

## Layout

```
.claude-plugin/marketplace.json          Marketplace manifest: lists the plugins and their sources
plugins/outside-dave/
  .claude-plugin/plugin.json             Plugin manifest, including the version
  skills/<name>/SKILL.md                 One skill
  skills/<name>/references/*.md          Detail a skill reads only when it needs it
  hooks/hooks.json                       Hooks the plugin installs, auto-discovered at this path
  hooks/*.sh                             The scripts those hooks run
```

`marketplace.json` points at `./plugins/outside-dave`; the plugin manifest there carries the
version users install. Adding a plugin means adding a directory under `plugins/` and an entry in
`marketplace.json`.

`hooks/hooks.json` needs no entry in `plugin.json`: Claude Code discovers it at that path. Hook
scripts run on the user's machine on someone else's project, so keep them POSIX `sh`, dependency
free, silent when they have nothing to say, and always exiting 0. Reach for a hook only where a
skill description can't do the job, because a hook fires whether or not the user wants it.

## How the skills relate

The skills are not independent:

- **onboarding** produces `README.md`, `CONTRIBUTING.md`, `docs/CODING-RULES.md`,
  `docs/ARCHITECTURE.md`, and `docs/TESTING.md` in a target repository, then wires one-line,
  task-conditioned pointers into that repo's `CLAUDE.md` or `AGENTS.md`.
- **planning** reads those same five docs before drafting a plan, and validates the plan against
  them.
- **writing** is invoked by both `onboarding` and `pull-request` via the Skill tool before either
  drafts prose.
- **pull-request** is GitHub-specific and defers to `references/github-cli.md` for exact commands.

That coupling is the thing to protect. If you rename a file `onboarding` produces, or change the
docs it writes, `planning` reads a stale list. Change both together.

Two shared patterns run through all four: fresh subagents verify the work (they report findings,
they never fix, and the main agent resolves and re-runs until clean), and a doc a change
invalidates is updated as part of that change rather than as a follow-up.

## Writing or editing a skill

A skill is a `SKILL.md` with YAML frontmatter of exactly `name` and `description`. The description
is the trigger: it must say when to use the skill and list the plain-language phrasings a user
would actually type, including cases where they never say the skill's name. It is the only part
loaded until the skill fires, so vague descriptions mean the skill never triggers.

Keep `SKILL.md` short enough to read in one pass and push fiddly, rarely-needed detail into
`references/`, the way `pull-request` does with `github-cli.md`. The skill body is instructions to
an agent: imperative, concrete, and specific about which file each output lands in.

## Versioning and commits

Bump `version` in `plugins/outside-dave/.claude-plugin/plugin.json` whenever skill content
changes; users get updates through that number. History shows both styles: bundled into the change
commit, or a separate "Bump plugin version to X.Y.Z" commit after it. Either is fine, but do not
land a skill change without the bump.

Commit messages are imperative and factual, one line, no prefix convention.
