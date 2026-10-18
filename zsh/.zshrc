# Path of this repo. ~/.zshrc is a symlink, so resolve it (:A) and go up two levels.
export DOTFILES="${${(%):-%x}:A:h:h}"

export PATH="$HOME/bin:/usr/local/bin:$HOME/.local/bin:$PATH"

########### oh-my-zsh ###########
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"
plugins=(git kubectl poetry)

# Homebrew completions must be on FPATH before oh-my-zsh runs compinit.
# https://docs.brew.sh/Shell-Completion#configuring-completions-in-zsh
if command -v brew >/dev/null; then
  FPATH="$(brew --prefix)/share/zsh/site-functions:$FPATH"
fi

source "$ZSH/oh-my-zsh.sh"

# To change the prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh

########### completions ###########
# pack
command -v pack >/dev/null && . "$(pack completion --shell zsh)"

# Google Cloud SDK: PATH and completion
[[ -f "$HOME/.google-cloud-sdk/path.zsh.inc" ]] && . "$HOME/.google-cloud-sdk/path.zsh.inc"
[[ -f "$HOME/.google-cloud-sdk/completion.zsh.inc" ]] && . "$HOME/.google-cloud-sdk/completion.zsh.inc"

########### Rust ###########
[[ -f "$HOME/.cargo/env" ]] && . "$HOME/.cargo/env"

########### NVM ###########
if [[ -s "/opt/homebrew/opt/nvm/nvm.sh" ]]; then
  . "/opt/homebrew/opt/nvm/nvm.sh"
  [[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ]] && . "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"

  # Change the Node version automatically from .nvmrc
  autoload -U add-zsh-hook

  load-nvmrc() {
    if [[ -f .nvmrc && -r .nvmrc ]]; then
      local node_version
      node_version=$(<.nvmrc)
      if [[ "$(nvm version)" != "v$node_version" ]]; then
        nvm use "$node_version" --silent
      fi
    fi
  }

  add-zsh-hook chpwd load-nvmrc
  load-nvmrc
fi

########### direnv ###########
command -v direnv >/dev/null && eval "$(direnv hook zsh)"

########### pyenv ###########
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
if command -v pyenv >/dev/null; then
  eval "$(pyenv init -)"
  eval "$(pyenv virtualenv-init -)"
fi

########### Hunk ###########
export PATH="$HOME/.hunk/bin:$PATH"

########### project-navigator ###########
# Let `pn` change the directory of the shell.
pn() {
  result=$(command pn "$@")
  if echo "$result" | grep -q "^cd "; then
    eval "$result"
  else
    echo "$result"
  fi
}

########### aliases ###########
# Load after oh-my-zsh, so these aliases override the plugin aliases.
source "$DOTFILES/zsh/aliases.zsh"

########### SDKMAN ###########
# !!! THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK !!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"
