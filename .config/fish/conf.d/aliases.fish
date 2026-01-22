alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'

alias n='NVIM_APPNAME=nvim/n nvim'
alias nn='NVIM_APPNAME=nvim/nn nvim'
alias nan='NVIM_APPNAME=nvim/AstroNvim nvim'
alias nvc='NVIM_APPNAME=nvim/NvChad nvim'
alias nlv='NVIM_APPNAME=nvim/LazyVim nvim'

if type -q eza
    alias l='eza'
    alias ll='eza -l'
    alias la='eza -a'
    alias lla='eza -la'
end

if type -q zellij
    alias zl='zellij'
end

if type -q bat
    alias cat='bat'
end

if type -q rainfrog
    alias rf='rainfrog'
end

alias gwip='git add -A; git rm $(git ls-files --deleted) 2> /dev/null; git commit --no-verify --no-gpg-sign --message "--wip-- [skip ci]"'
alias gunwip='git rev-list --max-count=1 --format="%s" HEAD | grep -q "\--wip--" && git reset HEAD~1'
