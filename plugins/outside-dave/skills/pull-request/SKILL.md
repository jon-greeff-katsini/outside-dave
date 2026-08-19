---
name: pull-request
description: Use when creating, reviewing, or responding to GitHub pull requests — opening a PR, addressing review feedback, resolving PR comments, running a code review, or getting a PR into a mergeable state. Triggers on phrases like "open a PR", "review this PR", "address the comments", "gh pr", or "resolve review threads", even when the user doesn't say "pull request" explicitly.
---

# Pull Requests

This skill is GitHub-specific. It assumes the `gh` CLI is authenticated (`gh auth status`). The exact commands for inline comments, code suggestions, resolving threads, and watching checks live in `references/github-cli.md` — read that file whenever you need to post to or query a PR, since several of these operations are easy to get wrong from memory.

## Creating pull requests

- Match the repository's PR template. It usually lives at `.github/PULL_REQUEST_TEMPLATE.md` (also seen at `.github/pull_request_template.md`, the repo root, or `docs/`). Read it first and fill in every section — a template exists because reviewers rely on those sections being present.
- Keep the description clear and concise. Write what changed and why; link the issue it closes.
- If the change touches multiple components or has non-obvious control flow, add a small **Mermaid** diagram — it renders inline on GitHub and saves reviewers from reconstructing the flow themselves.
- After opening, CI gates and autonomous review agents fire almost immediately. Give them time to run rather than declaring victory early — poll with `gh pr checks --watch` (see references).
- The goal is a PR that's genuinely ready to merge: checks green, review threads addressed. When a check *fails* (as opposed to still running), read the logs and fix the cause. Don't merge, dismiss a human's review, or force-push over someone else's work without asking the user first — those are hard to undo.

## Reviewing pull requests

- Confirm the build gates are passing before spending time on the code; a red build often explains issues you'd otherwise flag by hand.
- Check that the PR template is filled in — missing sections are themselves worth raising.
- Read the description against the diff. The two should tell the same story: the code should do what the description claims, and the description should account for what the code does. Where they diverge (undocumented refactors, scope the description never mentions), flag it — you're surfacing the mismatch for the author, not policing it.
- Check logical correctness and syntax.
- Look for simplification: dead or redundant code, over-engineering, or the opposite — cleverness compressed to the point of being hard to follow.
- **Challenge the approach, not just the implementation.** Review against the PR's *objective*, not the shape it arrived in. Don't reason forward from the diff ("given this design, is it correct?") — reason backward from the goal ("what's the smallest thing that achieves this?") and compare. For every non-trivial addition, ask:
  - Is this re-inventing something that already exists — in the stdlib, in the framework, in a dependency already installed, or a few files over in this same repo? Name the existing thing.
  - Is this over-engineered? An interface with one implementation, a config option for a value that never changes, an abstraction for a second case that doesn't exist yet.
  - Is this the simplest way to achieve the objective? If not, say what the simpler way is.
  - Can the objective be met *without* this change at all — by deleting something, changing a call site, using a native platform feature, or doing it once by hand in the UI/CLI instead of encoding it forever in the repo?

  Watch especially for **code that re-implements something the platform already does**: a script or workflow that applies a label, sets a field, or renames a thing that GitHub (or the framework, or the cloud console) can do directly. A one-off action does not need to become permanent automation. If it's genuinely recurring, the automation may be right — but say which one it is.

  Raise these as alternatives with a concrete replacement, not as vague misgivings. If the author's approach survives the questions, say so and move on — one round of pushback, not a campaign.
- Look at the tests: do they cover the edge cases, and are there gaps worth filling?
- Avoid nitpicking. Style the linter already enforces isn't worth a comment.

Compile the issues you find into a list for the user, each linking to the relevant spot on the PR. Ask for permission before posting anything — the user may want to adjust or drop some.

Once approved, post them as **inline** comments anchored to the relevant line (not top-level PR comments). When a fix is small and unambiguous, use a GitHub **suggestion** block so the author can apply it in one click instead of a prose comment. Submit the review as **Request changes** if any real issues remain; otherwise **Approve** or **Comment**. See `references/github-cli.md` for the exact commands.

Each comment should follow this shape:

```markdown
This is a <bug | issue | anti-pattern | simpler alternative>.

<why it matters>

<a suggested fix>
```

## Responding to comments

- Fetch every comment on the PR (`gh pr view --comments`, and the review-thread query in references for unresolved threads).
- For each one, decide: address it, or push back. Both are legitimate — a well-reasoned disagreement is a valid response.
- Reply to the original comment with your resolution. If you made the change, reply with what you did and a link to the commit, then resolve the thread. If you're pushing back, reply with the reasoning and leave the thread open for the author.
- Stay in scope. If a comment asks for something beyond this PR's purpose, don't quietly expand the PR to cover it — reply proposing it be tracked as a separate issue for later.
