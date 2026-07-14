### Dotfiles

Personal dotfiles, symlinked into place by [dotter](https://github.com/SuperCuber/dotter).

## Fresh machine setup

One-time pre-reqs (manual):

1. Install Homebrew
2. Set up GitHub SSH
3. Install/update Xcode CLI tools: `xcode-select --install`
4. Install dotter: `brew install dotter`

Then clone this repo and deploy:

```sh
dotter deploy -v
```

That's it — you do **not** need a separate `brew install` step. `dotter deploy`
symlinks every config and runs the hooks automatically:

- **pre_deploy** — removes app-rewritten files (Claude / Zed settings) so the
  symlinks win on redeploy.
- **post_deploy** — runs `brew bundle` (installs everything in `Brewfile`),
  installs bun + dmux, mirrors skills into `~/.agents`, and wires
  `~/.zshrc.local` into `~/.zshrc` once that file exists.

## Shell (`~/.zshrc`)

`~/.zshrc` is intentionally **not** managed by dotter — the work setup script
owns it and can regenerate it freely. Personal zsh config lives in
`~/.zshrc.local`. `post_deploy` appends a loader line to `~/.zshrc` when it
exists. If you run `dotter deploy` before the work script has created
`~/.zshrc`, just re-run `dotter deploy` afterward to wire it in.
