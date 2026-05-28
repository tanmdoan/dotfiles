#!/bin/bash

brew bundle --file=~/Brewfile

set -euo pipefail

# Keep ~/.agents/skills mirrored to the dotter-managed ~/.claude/skills so the
# Vercel agent-skill runtime and Claude Code see the same repo-sourced skills.
# Repo is the source of truth; this only points the folder, it never writes skills.
CLAUDE_SKILLS="$HOME/.claude/skills"
AGENTS_SKILLS="$HOME/.agents/skills"

mkdir -p "$HOME/.agents"

if [ -L "$AGENTS_SKILLS" ]; then
  [ "$(readlink "$AGENTS_SKILLS")" = "$CLAUDE_SKILLS" ] || ln -sfn "$CLAUDE_SKILLS" "$AGENTS_SKILLS"
elif [ -e "$AGENTS_SKILLS" ]; then
  mv "$AGENTS_SKILLS" "$AGENTS_SKILLS.pre-symlink.bak.$(date +%s)"
  ln -s "$CLAUDE_SKILLS" "$AGENTS_SKILLS"
else
  ln -s "$CLAUDE_SKILLS" "$AGENTS_SKILLS"
fi
