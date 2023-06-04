#!/bin/zsh

##
# User scripts
#

eval "$(/opt/homebrew/bin/brew shellenv)"
eval "$(zoxide init zsh)"
eval "$(atuin init zsh)"
#eval "$(zellij setup --generate-completion zsh)"

zstyle ':hist:*' expand-aliases yes

#source $(brew --prefix)/opt/zsh-vi-mode/share/zsh-vi-mode/zsh-vi-mode.plugin.zsh
source "$(brew --prefix)/share/google-cloud-sdk/completion.zsh.inc"

. /opt/homebrew/opt/asdf/libexec/asdf.sh

export HOMEBREW_NO_ENV_HINTS=true
export GOPRIVATE="gitlab.com/pinvest/*"

export PNPM_HOME="/Users/ymbp/Library/pnpm"
export PATH="$PNPM_HOME:$PATH"

# Golang
export GOPATH="$HOME/.local/share/go"
export GOMODCACHE="$HOME/.cache/go"
export PATH="$GOPATH/bin:$PATH"

alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."

alias l="exa"
alias ll="exa -l"
alias la="exa -a"
alias lla="exa -la"

alias cat="bat"
alias hx="helix"
export BAT_THEME="Nord"

#alias docker="lima nerdctl"
