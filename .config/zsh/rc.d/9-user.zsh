#!/bin/zsh

##
# User scripts
#

eval "$(zoxide init zsh)"
#eval $(shellclear --init-shell)
eval "$(atuin init zsh)"
bindkey '^r' atuin-search
eval "$(zellij setup --generate-auto-start zsh)"
eval "$(zellij setup --generate-completion zsh)"

zstyle ':hist:*' expand-aliases yes

# Golang
export GOPATH="$HOME/.local/state/go"
export GOMODCACHE="$HOME/.cache/go"
export GOBIN="$GOPATH/bin"
export PATH="$GOBIN:$PATH"

# Bob
export PATH="$HOME/.local/share/bob/nvim-bin:$PATH"

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/home/ypcl/.local/bin/google-cloud-sdk/path.zsh.inc' ]; then . '/home/ypcl/.local/bin/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/home/ypcl/.local/bin/google-cloud-sdk/completion.zsh.inc' ]; then . '/home/ypcl/.local/bin/google-cloud-sdk/completion.zsh.inc'; fi

# pnpm
export PNPM_HOME="/home/ypcl/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
