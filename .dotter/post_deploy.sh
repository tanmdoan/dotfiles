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

# bun + global bun packages (not available via brew).
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

if ! command -v bun >/dev/null 2>&1; then
  echo "Installing bun…"
  curl -fsSL https://bun.sh/install | bash
fi

# dmux self-updates, so this just guarantees it's present on a fresh machine.
BUN_GLOBALS=(dmux)

if command -v bun >/dev/null 2>&1; then
  for pkg in "${BUN_GLOBALS[@]}"; do
    bun pm ls -g 2>/dev/null | grep -q " ${pkg}@" || bun install -g "$pkg"
  done
else
  echo "⚠️  bun install failed — install manually (https://bun.sh), then: bun install -g ${BUN_GLOBALS[*]}"
fi

# ~/.zshrc is owned by the work setup script, so dotter doesn't manage it. Once it
# exists, ensure it sources our personal config (idempotent — safe to re-run).
ZSHRC="$HOME/.zshrc"
if [ -f "$ZSHRC" ]; then
  if ! grep -qF '.zshrc.local' "$ZSHRC"; then
    printf '\n# load personal dotfiles config (added by dotfiles post_deploy)\n[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local\n' >> "$ZSHRC"
    echo "Wired ~/.zshrc.local into ~/.zshrc"
  fi
else
  echo "⚠️  ~/.zshrc not found yet — after your work setup script creates it, re-run 'dotter deploy' to wire in ~/.zshrc.local"
fi
