# .files

My macOS development setup: zsh, Neovim (LazyVim), git, k9s, herdr, hunk and Claude Code.

![Terminal screenshot](docs/screenshot.png)

## What is here

| Path | Contents | Linked to |
| --- | --- | --- |
| `Brewfile` | All tools, casks and global npm packages | — |
| `install.sh` | Makes the symlinks below | — |
| `zsh/.zshrc` | oh-my-zsh, powerlevel10k, nvm, pyenv, direnv, SDKMAN | `~/.zshrc` |
| `zsh/.zprofile` | Homebrew environment and login `PATH` | `~/.zprofile` |
| `zsh/.p10k.zsh` | powerlevel10k prompt | `~/.p10k.zsh` |
| `zsh/aliases.zsh` | Personal shortcuts (`k`, `vim`, `act` …) | loaded by `.zshrc` |
| `nvim/` | LazyVim config (`lua/config`, `lua/plugins`) | `~/.config/nvim` |
| `git/.gitconfig` | Identity, aliases, hunk as pager | `~/.gitconfig` |
| `git/.gitignore_global` | Global ignore rules | `~/.gitignore_global` |
| `k9s/` | `config.yaml` and `aliases.yaml` (no cluster contexts) | k9s config directory |
| `herdr/config.toml` | herdr key bindings | `~/.config/herdr/config.toml` |
| `hunk/config.toml` | hunk theme | `~/.config/hunk/config.toml` |
| `claude/CLAUDE.md` | Global Claude Code instructions | `~/.claude/CLAUDE.md` |
| `claude/settings.json` | Model, hooks, status line (no keys) | `~/.claude/settings.json` |

The oh-my-zsh `git` and `kubectl` plugins supply the other shortcuts, for example `gst`, `gco`, `kgp` and `kl`. Run `alias` to see all of them.

## Install

1. Install [Homebrew](https://brew.sh).
2. Clone this repo and install the tools:

   ```sh
   git clone https://github.com/mtzatzos/.files.git ~/Projects/01.Personal/.files
   cd ~/Projects/01.Personal/.files
   brew bundle --file Brewfile
   ```

3. Make the symlinks:

   ```sh
   ./install.sh
   ```

   The script also clones oh-my-zsh and powerlevel10k if they are not there. If a target file exists, the script moves it to `<name>.backup-<timestamp>`. You can run the script again safely.

4. Install the tools that do not come from Homebrew:
   - [Claude Code](https://claude.com/claude-code)
   - herdr. After you install it, let herdr install its Claude Code integration. This makes `~/.claude/hooks/herdr-agent-state.sh`, which `claude/settings.json` calls.
   - [hunk](https://hunk.dev). Git uses it as the pager.
   - SDKMAN, Rust (`rustup`) and the Google Cloud SDK, if you need them.

## Not in this repo

- Secrets, API keys and tokens.
- k9s cluster contexts (`clusters/`) and kube configs.
- Claude Code skills, plugins, history and per-project settings.
- Files that herdr and hunk manage themselves (sockets, logs, state).
