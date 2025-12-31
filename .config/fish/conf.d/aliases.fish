alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."

alias n='NVIM_APPNAME=nvim/n nvim'
alias nn='NVIM_APPNAME=nvim/nn nvim'
alias nan='NVIM_APPNAME=nvim/AstroNvim nvim'
alias nvc='NVIM_APPNAME=nvim/NvChad nvim'
alias nlv='NVIM_APPNAME=nvim/LazyVim nvim'

alias l="eza"
alias ll="eza -l"
alias la="eza -a"
alias lla="eza -la"

alias zl="zellij"

alias cat="bat"

alias gwip='git add -A; git rm $(git ls-files --deleted) 2> /dev/null; git commit --no-verify --no-gpg-sign --message "--wip-- [skip ci]"'
alias gunwip='git rev-list --max-count=1 --format="%s" HEAD | grep -q "\--wip--" && git reset HEAD~1'
