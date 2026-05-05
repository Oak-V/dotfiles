# AGENTS.md

This workspace IS a git-tracked dotfiles repo on macOS (Apple Silicon). Treat `~` as the repo root.

## Critical Conventions

- **Never commit secrets**. `.secret.*` files are gitignored. Use `*.sample` naming for templates.
- **GPG signing is mandatory** for all commits, pushes, and tags (`~/.gitconfig`).
- **SSH uses GPG agent** for auth. Do not modify `~/.ssh/config` without understanding the GPG bridge.
- **Editor is Neovim**, not vim. Config at `~/.config/nvim/`.
- **Shell is zsh**, but config lives at `~/.config/zsh/` (not `~/.zshrc` directly). `~/.zshenv` sets `ZDOTDIR`.
- **Version manager is mise** (not asdf). Toolchain: bun, deno, elixir, erlang, go, kotlin, lua, node, perl, python, ruby, rust.
- **3-space indentation**, LF line endings, UTF-8 (`.editorconfig`).

## Directory Map

| Path | Purpose |
|------|---------|
| `~/.config/zsh/` | Shell config + plugins (antidote) |
| `~/.config/nvim/` | Neovim config (minimal, built-in LSP) |
| `~/.config/tmux/` | Tmux config |
| `~/.config/opencode/` | OpenCode plugin config (Node.js) |
| `~/.config/mise/config.toml` | Mise tool versions |
| `~/.config/starship/` | Prompt theme (Catppuccin Mocha) |
| `~/.config/alacritty/` | Terminal emulator config |
| `~/.config/bat/` | Cat config with custom themes |
| `~/.hammerspoon/` | macOS window/keyboard automation (Lua) |
| `~/.bin/` | Custom Rust binary workspace |
| `~/.services/` | Launchd plists (tmux, alacritty daemons) |
| `~/.repos/` | Submodule checkouts (catppuccin themes) |
| `~/dev/` | Active development projects |
| `~/.Brewfile` | Homebrew bundle manifest |

## Active Dev Projects (`~/dev/`)

- **`~/dev/brew/`** — Homebrew/brew fork (Ruby + Bash). See its own `AGENTS.md` for repo-specific rules.
  - Use `./bin/brew` (not system `brew`). Run `./bin/brew lgtm --online` before committing.
  - Use `./bin/brew ruby -- <args>` for Ruby (macOS system Ruby is too old).
- **`~/dev/sogcli/`** — Go CLI project.
- **`~/dev/pam_apple_companion/`** — Codeberg submodule project.
- **`~/dev/Local*.spoon/`** — Hammerspoon spoons from Codeberg.

## Key Commands

- `update()` — Shell function in `~/.bin/update.sh`. Upgrades brew, mise, npm global, uv tools, gems.
- `brew bundle install --file ~/.Brewfile` — Install dotfile-managed packages.
- `mise install` — Install mise-managed tool versions.
- Submodules require `git submodule update --init --recursive` after clone.

## OpenCode Plugin

Located at `~/.config/opencode/`. Node.js project using `@opencode-ai/plugin`. Uses bun lockfile.
