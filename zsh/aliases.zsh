# Personal shortcuts.
# oh-my-zsh plugins add more:
#   git     -> gst, gco, gcb, gp, gl, glog …
#   kubectl -> kgp, kgd, kl, kaf, kctx …
# Run `alias` to see all of them.

alias vim=nvim
command -v pyenv >/dev/null && alias python3="$(pyenv which python)"

# act: run GitHub workflows locally
alias act='act --container-architecture linux/amd64'

# Kubernetes
alias k="kubectl"
