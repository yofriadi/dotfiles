#!/bin/zsh

##
# User scripts
#

eval "$(zoxide init zsh)"
#eval $(shellclear --init-shell)
eval "$(atuin init zsh)"
bindkey '^r' atuin-search
#eval "$(zellij setup --generate-completion zsh)"

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

alias n='NVIM_APPNAME=nvim/default nvim'
alias nn='NVIM_APPNAME=nvim/AstroNvim nvim'

alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."

alias l="eza"
alias ll="eza -l"
alias la="eza -a"
alias lla="eza -la"

alias gwip='git add -A; git rm $(git ls-files --deleted) 2> /dev/null; git commit --no-verify --no-gpg-sign --message "--wip-- [skip ci]"'
alias gunwip='git rev-list --max-count=1 --format="%s" HEAD | grep -q "\--wip--" && git reset HEAD~1'

# Similar to `gunwip` but recursive "Unwips" all recent `--wip--` commits not just the last one
function gunwipall() {
  local _commit=$(git log --grep='--wip--' --invert-grep --max-count=1 --format=format:%H)

  # Check if a commit without "--wip--" was found and it's not the same as HEAD
  if [[ "$_commit" != "$(git rev-parse HEAD)" ]]; then
    git reset $_commit || return 1
  fi
}

alias hx="helix"
export BAT_THEME="Nord"

export PNPM_HOME="/home/yofri/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
