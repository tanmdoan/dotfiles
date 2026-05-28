---
name: update-pr-description
description: "Updates a GitHub PR description from Jira context and the branch diff. Use when asked to run /update-pr-description or refresh a PR body."
argument-hint: "[branch-or-ticket]"
---

# /update-pr-description

Update the current branch's PR description using Jira context plus the git diff. Keep the result concise and reviewer-friendly.

## Input

Optional argument: a branch name or Jira ticket ID.

- Branch example: `ah/fe-4082-uuidv4removal`
- Ticket example: `FE-4082`

## Workflow

1. **Find the PR**
   - If no argument is provided, use `git rev-parse --abbrev-ref HEAD`.
   - If given a ticket ID, find the open PR whose branch contains it.
   - Prefer GitHub MCP when available; otherwise use `gh pr list` / `gh pr view`.
   - If no open PR exists, stop and tell the user.

2. **Find Jira context**
   - Parse the ticket ID from the branch or argument with `[A-Za-z]+-\d+`, uppercased.
   - Fetch the Jira issue with Atlassian MCP.
   - Extract only what helps the PR: summary, problem/motivation, acceptance criteria, and parent epic summary if useful.
   - If Jira is too sparse to explain the change, ask the user for 1-2 sentences instead of inventing context.

3. **Read the diff**
   - Use `git diff main...HEAD --stat` and targeted diff reads.
   - Read enough to describe the actual change accurately; do not dump or over-summarize every file.
   - Use current conversation context when it is more accurate than the raw diff.

4. **Preserve existing verification content**
   - Read the current PR body.
   - If it contains a `========` separator, append everything from that separator onward unchanged.
   - If it has obvious screenshots/videos/demo content without a separator, ask whether to keep it.

5. **Write this PR body**

```markdown
[TICKET-ID](https://joinhomebase.atlassian.net/browse/TICKET-ID)

## Summary

1-2 sentences. Lead with the problem only if it is useful.

## Why

1-2 sentences explaining why this matters.

## What Changed

- Concise bullet grouped by meaningful area or file.
- Mention tests only if test files changed.

## Acceptance Criteria

- [ ] Criterion from Jira or inferred from the diff
- [ ] Tests pass
```

Keep it short. Omit empty or irrelevant sections. Avoid implementation trivia unless it helps reviewers.

6. **Update the PR**
   - Prefer GitHub MCP update tools when available; otherwise write to a temp file and run `gh pr edit <number> --body-file <file>`.
   - Confirm with the PR link.
