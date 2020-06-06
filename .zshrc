# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# source ~/.zsh/instant.zsh
# instant-zsh-pre "%n@%m %~%# "

# source ~/.zsh/theme.zsh
# source ~/.zsh/vi-mode.zsh

source <(sheldon source)

export KEYTIMEOUT=1

MODE_CURSOR_VICMD="blinking block"
MODE_CURSOR_VIINS="blinking bar"
MODE_CURSOR_SEARCH="blinking underline"

# FZF-TAB
# disable sort when completing options of any command
zstyle ':completion:complete:*:options' sort false

# use input as query string when completing zlua
zstyle ':fzf-tab:complete:_zlua:*' query-string input

# give a preview when completing `kill`
zstyle ':completion:*:*:*:*:processes' command "ps -u $USER -o pid,user,comm,cmd -w -w"
zstyle ':fzf-tab:complete:kill:argument-rest' extra-opts '--preview=echo $(<{f})' --preview-window=down:3:wrap

# (experimental) give a preview of directory when completing cd
local extract="
# trim input
in=\${\${\"\$(<{f})\"%\$'\0'*}#*\$'\0'}
# get ctxt for current completion
local -A ctxt=(\"\${(@ps:\2:)CTXT}\")
"
zstyle ':fzf-tab:complete:cd*' extra-opts --preview=$extract"exa -1 --color=always \${~ctxt[hpre]}\$in"

FZF_TAB_COMMAND=(
    fzf
    --ansi   # Enable ANSI color support, necessary for showing groups
    --expect='$continuous_trigger' # For continuous completion
    '--color=hl:$(( $#headers == 0 ? 108 : 255 ))'
    --nth=2,3 --delimiter='\x00'  # Don't search prefix
    --layout=reverse --height='${FZF_TMUX_HEIGHT:=75%}'
    --tiebreak=begin -m --bind=tab:down,ctrl-j:accept,change:top,ctrl-space:toggle --cycle
    '--query=$query'   # $query will be expanded to query string at runtime.
    '--header-lines=$#headers' # $#headers will be expanded to lines of headers at runtime
)
zstyle ':fzf-tab:*' command $FZF_TAB_COMMAND
# END FZF_TAB

autoload -Uz compinit
compinit

if [[ "$OSTYPE" == "darwin"* ]]; then
  export LC_ALL=en_US.UTF-8
  # export PATH="$HOME/.local/bin:$PATH"

  # nvim --headless -c "call firenvim#install(0, 'export PATH=\"$PATH\"')" -c quit
fi

# export ZSH="$HOME/.oh-my-zsh"
export PATH="$(yarn global bin):$PATH"
#export PATH="$HOME/.local/bin:$PATH"
export PATH=$(brew --prefix openvpn)/sbin:$PATH
export HISTCONTROL=ignoredups

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

. $HOME/.asdf/asdf.sh
. $HOME/.asdf/completions/asdf.bash

# z.lua
eval "$(lua ~/.zsh/repositories/github.com/skywind3000/z.lua/z.lua --init zsh enhanced once fzf)"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# export FZF_COMPLETION_TRIGGER=''
# bindkey '^T' fzf-completion
# bindkey '^I' $fzf_default_completion

alias n="nvim"
alias g="git"
alias cat="bat"

# git
alias gc="git clone"
alias gs="git status"
alias ga="git add"
alias gb="git branch"
alias gd="git diff"
alias gp="git push"
alias gl="git pull"
alias gr="git restore"
alias gf="git fetch"
alias gg="git log"
alias gtl="git tag -l --sort=v:refname | tail -1"
alias gsa="git stash apply"
alias gss="git stash save"
alias gsl="git stash list"
alias gsp="git stash pop"
alias gsd="git stash drop"
alias gco="git checkout"
alias gcm="git commit -m"
alias gca="git commit --amend -m"

# exa
alias ls="exa"
alias l="exa -l"
alias lsa="exa -la"

# git-flow
alias gfw="git flow"
alias gfi="git flow init"
alias gffs="git flow feature start"
alias gfff="git flow feature finish"
alias gffp="git flow feature publish"
alias gfhs="git flow hotfix start"
alias gfhf="git flow hotfix finish"
alias gfrs="git flow release start"
alias gfrf="git flow release finish"

# yarn
alias ys="yarn start"
alias yw="yarn watch"
alias yl="yarn lint"
alias yt="yarn test"
alias ylf="yarn lint:fix"
alias ytw="yarn test:watch"
alias ytd="yarn test:debug"
alias ytc="yarn test:coverage"
alias yti="yarn test:integration"
alias yp="yarn prettier"
alias yd="yarn dev"
alias yb="yarn build"

# docker
alias d="docker"
alias dc="docker container"
alias di="docker image"
alias db="docker build"
alias dr="docker run"
alias dn="docker network"
alias dp="docker pull"
alias dv="docker volume"
alias de="docker exec"
alias dl="docker logs"
alias dcu="docker-compose up"
alias dcd="docker-compose down"

# go
alias gor="go run"
alias gob="go build"
alias got="gotest"

# eval "$(starship init zsh)"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
# [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

[ -s "/Users/yofri/.scm_breeze/scm_breeze.sh" ] && source "/Users/yofri/.scm_breeze/scm_breeze.sh"
