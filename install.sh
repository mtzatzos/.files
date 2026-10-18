#!/usr/bin/env bash
# Symlink the configs in this repo into place.
# You can run it again: correct links stay, other files move to <name>.backup-<timestamp>.
set -euo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
STAMP="$(date +%Y%m%d-%H%M%S)"

# link <file in repo> <target path>
link() {
  local src="$DOTFILES/$1" dst="$2"

  if [[ -L "$dst" && "$(readlink "$dst")" == "$src" ]]; then
    echo "ok      $dst"
    return
  fi

  mkdir -p "$(dirname "$dst")"
  if [[ -e "$dst" || -L "$dst" ]]; then
    mv "$dst" "$dst.backup-$STAMP"
    echo "backup  $dst -> $dst.backup-$STAMP"
  fi
  ln -s "$src" "$dst"
  echo "link    $dst -> $src"
}

# oh-my-zsh and powerlevel10k are not in Homebrew in the form .zshrc expects.
if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
  git clone --depth=1 https://github.com/ohmyzsh/ohmyzsh.git "$HOME/.oh-my-zsh"
fi
P10K="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"
if [[ ! -d "$P10K" ]]; then
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$P10K"
fi

# SDKMAN is not in Homebrew. .zshrc already loads it, so the installer must not change rc files.
# The installer uses $SDKMAN_DIR when it is set, so check the same directory.
if [[ ! -d "${SDKMAN_DIR:-$HOME/.sdkman}" ]]; then
  curl -fsSL "https://get.sdkman.io?rcupdate=false" | bash
fi

# zsh
link zsh/.zshrc    "$HOME/.zshrc"
link zsh/.zprofile "$HOME/.zprofile"
link zsh/.p10k.zsh "$HOME/.p10k.zsh"

# Neovim (LazyVim)
link nvim "$HOME/.config/nvim"

# git
link git/.gitconfig        "$HOME/.gitconfig"
link git/.gitignore_global "$HOME/.gitignore_global"

# k9s: link the files only. Cluster contexts, logs and screen dumps stay local.
if [[ "$(uname)" == "Darwin" && -z "${XDG_CONFIG_HOME:-}" ]]; then
  K9S_DIR="$HOME/Library/Application Support/k9s"
else
  K9S_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/k9s"
fi
link k9s/config.yaml  "$K9S_DIR/config.yaml"
link k9s/aliases.yaml "$K9S_DIR/aliases.yaml"

# herdr and hunk: link the files only. Sockets, logs and state stay local.
link herdr/config.toml "$HOME/.config/herdr/config.toml"
link hunk/config.toml  "$HOME/.config/hunk/config.toml"

# Claude Code
link claude/CLAUDE.md     "$HOME/.claude/CLAUDE.md"
link claude/settings.json "$HOME/.claude/settings.json"

echo "Done. Open a new shell to load the changes."
