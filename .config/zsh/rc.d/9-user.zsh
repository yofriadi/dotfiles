#!/bin/zsh

##
# User scripts
#

eval "$(zoxide init zsh)"
eval "$(atuin init zsh)"
#eval "$(zellij setup --generate-completion zsh)"

zstyle ':hist:*' expand-aliases yes

. "/opt/asdf-vm/asdf.sh"

export GOPRIVATE="gitlab.com/pinvest/*"

#export PNPM_HOME="/Users/ymbp/Library/pnpm"
#export PATH="$PNPM_HOME:$PATH"

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

export CLOUDSDK_PYTHON=python3

# Rust
#export PATH="$HOME/.asdf/installs/rust/1.71.0/bin:$PATH"
#export PATH="$HOME/.cargo/bin:$PATH"

alias n='NVIM_APPNAME=nvim/default nvim'
alias nlv='NVIM_APPNAME=nvim/LazyVim-starter nvim'
alias nan='NVIM_APPNAME=nvim/AstroNvim nvim'

alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."

alias l="eza"
alias ll="eza -l"
alias la="eza -a"
alias lla="eza -la"

alias hx="helix"
export BAT_THEME="Nord"

# bun completions
[ -s "/home/ypcl/.bun/_bun" ] && source "/home/ypcl/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
