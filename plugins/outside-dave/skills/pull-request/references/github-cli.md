# GitHub CLI & API for Pull Requests

Concrete commands for the operations the SKILL.md refers to. All assume `gh` is authenticated (`gh auth status`) and you're inside the repo checkout. Where an operation isn't covered by a first-class `gh` subcommand, use `gh api` (REST) or `gh api graphql`. Both inherit your `gh` auth.

## Table of contents
- [Finding the PR](#finding-the-pr)
- [Creating a PR](#creating-a-pr)
- [Watching CI checks](#watching-ci-checks)
- [Reading comments and review threads](#reading-comments-and-review-threads)
- [Posting a review with inline comments](#posting-a-review-with-inline-comments)
- [Code suggestions](#code-suggestions)
- [Replying to a comment](#replying-to-a-comment)
- [Resolving a review thread](#resolving-a-review-thread)

## Finding the PR

```bash
gh pr status                 # PRs associated with the current branch
gh pr view                   # the PR for the current branch (add a number/URL for a specific one)
gh pr view 123 --json number,title,state,mergeable,headRefName,url
```

Grab the PR number once and reuse it. Many API calls below need the numeric ID.

## Creating a PR

```bash
# Read the template first, then pass a body that fills it in.
gh pr create --title "feat: ..." --body-file /path/to/filled-body.md --base main

# Or open a draft while CI runs:
gh pr create --draft --title "..." --body-file body.md
```

Common template locations to check, in order:
`.github/PULL_REQUEST_TEMPLATE.md`, `.github/pull_request_template.md`, `PULL_REQUEST_TEMPLATE.md` (repo root), `docs/PULL_REQUEST_TEMPLATE.md`. There may also be multiple templates under `.github/PULL_REQUEST_TEMPLATE/`.

## Watching CI checks

```bash
gh pr checks              # snapshot of all checks and their status
gh pr checks --watch      # blocks and refreshes until every check completes
gh pr checks --watch --fail-fast   # stop as soon as one fails
```

`--watch` exits when checks reach a terminal state, so it won't spin forever. When a check fails, pull its logs:

```bash
gh run view --log-failed             # failed steps of the most recent run
gh run view <run-id> --log-failed
```

## Reading comments and review threads

```bash
gh pr view 123 --comments            # issue-level (conversation) comments
```

Review comments (the ones anchored to lines) and their resolved state come from the API. Threads live in the GraphQL API:

```bash
gh api graphql -f query='
  query($owner:String!, $repo:String!, $number:Int!) {
    repository(owner:$owner, name:$repo) {
      pullRequest(number:$number) {
        reviewThreads(first:100) {
          nodes {
            id
            isResolved
            comments(first:20) {
              nodes { id databaseId author { login } body path line }
            }
          }
        }
      }
    }
  }' -F owner='OWNER' -F repo='REPO' -F number=123
```

The thread `id` (a node ID like `PRRT_...`) is what you resolve. The comment `databaseId` is what you reply to via REST.

## Posting a review with inline comments

Submit a whole review, inline comments and all, in one call. `event` is whichever verdict the user asked for: `COMMENT`, `REQUEST_CHANGES`, or `APPROVE`. Ask before posting if they haven't said.

`gh api`'s `-f`/`-F` flags only send flat key/value pairs, so they cannot express the nested `comments` array (`comments[][path]` is silently dropped, and `comments[][body]` collides with the review's own `body`). Send the payload as JSON on stdin instead:

```bash
gh api repos/OWNER/REPO/pulls/123/reviews --input - <<'JSON'
{
  "event": "COMMENT",
  "body": "A few correctness notes inline.",
  "comments": [
    {
      "path": "src/app.ts",
      "line": 42,
      "body": "This is a bug.\n\n`items` can be empty here, which throws below. Guard it before indexing.\n\n```suggestion\nif (!items.length) return;\n```"
    }
  ]
}
JSON
```

Notes:
- `line` is the line number in the file's **new** version of the diff. For a multi-line comment add `start_line`. To comment on the old side, add `"side": "LEFT"`.
- Add one object to `comments` for each inline comment.
- Comment bodies are JSON strings, so newlines are `\n`. For a long body, write the JSON to a file with a script and pass `--input file.json`.

For a review with no inline comments:

```bash
gh pr review 123 --comment --body "A few thoughts"
```

`gh pr review --approve` and `--request-changes` exist too, but only run them when the user asks for that verdict.

## Code suggestions

A suggestion is a normal comment whose body contains a ` ```suggestion ` fenced block. GitHub renders an "Apply" button and the block's contents replace the commented line(s). Anchor it to the exact line you're replacing:

````markdown
This can be simplified.

```suggestion
const total = items.reduce((a, b) => a + b.price, 0);
```
````

Include it as the `body` of an inline review comment (see above). For a multi-line replacement, comment across the range with `start_line`/`line` and put the full replacement inside the block.

## Replying to a comment

Reply threads to an existing review comment via its numeric `databaseId`:

```bash
gh api repos/OWNER/REPO/pulls/123/comments/<comment_databaseId>/replies \
  -f body='Fixed in abc1234, added the empty-list guard.'
```

Link commits with the short SHA (GitHub auto-links it) or a full URL: `https://github.com/OWNER/REPO/commit/<sha>`.

For conversation-level (non-inline) comments, use `gh pr comment 123 --body '...'`.

## Resolving a review thread

There's no `gh` subcommand for this. Use the GraphQL mutation with the thread node `id` from the reviewThreads query above:

```bash
gh api graphql -f query='
  mutation($threadId:ID!) {
    resolveReviewThread(input:{threadId:$threadId}) {
      thread { id isResolved }
    }
  }' -f threadId='PRRT_kwDO...'
```

To reopen a thread, use `unresolveReviewThread` with the same shape. Reply with your resolution *before* resolving, so the thread carries the explanation.
