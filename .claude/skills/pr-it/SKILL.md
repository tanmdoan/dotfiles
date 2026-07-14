---
name: pr-it
description: "End-to-end ship flow for a Linear-tracked branch: commit, push, open the PR (stack-aware base), fill the description from Linear, and move the issue to In Review with the PR attached. Use when asked to run /pr-it or to ship the current branch."
argument-hint: "[base-branch]"
---

# /pr-it

One command to take the current branch from committed-work to an open, described,
Linear-linked PR. Composes `/update-pr-desc` for the description step.

## Input

Optional argument: the PR **base branch** (e.g. `des-258` for a stacked PR).
If omitted, auto-detect per step 3.

## Workflow

1. **Identify the work**
   - Branch: `git rev-parse --abbrev-ref HEAD`.
   - Linear issue ID: first `[A-Za-z]+-\d+` match in the branch name, uppercased
     (e.g. `259-prelude-…` on a Design branch → confirm the real ID like `DES-259`
     via Linear if the branch uses a bare number; the branch may not embed the
     team prefix). If you can't resolve a confident issue ID, ask the user.
   - Fetch the issue with Linear MCP `get_issue` for the title + acceptance criteria.

2. **Commit any pending work**
   - If `git status --porcelain` is clean and there's already a commit ahead of the
     base, skip to push.
   - Otherwise stage the intended files and commit with a message
     `ISSUE-ID: <issue title>` plus a short body. **Let the pre-commit hook run.**
   - Hook reality (this repo): `bin/git-hooks/pre-commit` stylelints **all** staged
     `client/**/*.scss` (incl. `lib/`), eslints/prettifies staged `.js/.ts(x)` only,
     and runs rubocop/ag checks. Worktrees under `.dmux/worktrees/` have **no
     `node_modules`** — run `bun install` in `client/` first so the hook can
     execute, rather than reaching for `--no-verify`. Only use `--no-verify` if a
     hook check is failing for a reason genuinely unrelated to the change, and say
     so explicitly.

3. **Determine the PR base (stack-aware)**
   - If a base argument was given, use it.
   - Else detect a stacked base: if the branch's merge-base with `origin/main`
     equals the tip of another local/remote branch that the work was built on
     (e.g. a dependency branch still in review), use that branch as the base and
     note it. A quick check: `git log --oneline origin/main..HEAD` — if the oldest
     commit shown is someone else's dependency commit, the branch is stacked.
   - Otherwise default to `main`.
   - When stacked, the PR description should note the stack and that it must be
     re-targeted to `main` after the base merges.

4. **Push**
   - `git push -u origin <branch>`.

5. **Open the PR**
   - `gh pr create --base <base> --head <branch> --title "ISSUE-ID: <title>"`
     with a short starter body (the next step rewrites it). Skip if a PR already
     exists for the head branch (`gh pr list --head <branch>`).

6. **Describe it from Linear**
   - Run the `/update-pr-desc` flow (same `~/.claude/skills/update-pr-desc`
     template): Linear-linked header, Summary / Why / What Changed / Acceptance
     Criteria, preserving any `========` verification block already in the body.

7. **Update Linear**
   - Move the issue to **In Review** and attach the PR as a link
     (`save_issue` with `state: "In Review"` and `links: [{url, title}]`).
     Don't re-attach if the PR link is already present.

8. **Report** the PR URL and the new Linear status.

## Notes

- Outward-facing actions (push, PR creation) are authorized by invoking `/pr-it`;
  proceed without re-confirming each one, but report what was done.
- Keep the PR body concise and reviewer-first; lead with the problem only when it
  aids understanding.
- This is the **Linear** ship flow, and the standard one for this repo. It replaces
  the retired Jira-based `create-pr` skill.
