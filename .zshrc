if [[ "$OSTYPE" == "darwin"* ]]; then
  export LC_ALL=en_US.UTF-8
  export PATH="$HOME/.local/bin:$PATH"
fi

export ZSH="$HOME/.oh-my-zsh"
export PATH="$(yarn global bin):$PATH"
export PATH="$HOME/.local/bin:$PATH"

# Uncomment the following line to disable auto-setting terminal title.
DISABLE_AUTO_TITLE="true"

source $ZSH/oh-my-zsh.sh

if [[ "$OSTYPE" == "darwin"* ]]; then
  source ~/.zplug/init.zsh
else
  source ~/.zplug/init.zsh
fi

zplug "denysdovhan/spaceship-prompt", use:spaceship.zsh, from:github, as:theme
zplug "junegunn/fzf-bin", from:gh-r, as:command, rename-to:fzf, use:"*darwin*amd64*"
zplug "zsh-users/zsh-syntax-highlighting"
zplug "zsh-users/zsh-autosuggestions"
zplug "zsh-users/zsh-completions"
zplug load

### User configuration ###
SPACESHIP_NODE_SHOW=false
SPACESHIP_KUBECONTEXT_SHOW=false
SPACESHIP_DOCKER_SHOW=false

. $HOME/.asdf/asdf.sh
. $HOME/.asdf/completions/asdf.bash

# z.lua
eval "$(lua ~/.z.lua/z.lua --init zsh enhanced once fzf)"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

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
alias gr="git reset"
alias gf="git fetch"
alias gg="git log"
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
alias gfi="git flow init"
alias gffs="git flow feature start"
alias gfff="git flow feature finish"
alias gffp="git flow feature publish"

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
alias dcu="docker-compose up"
alias dcd="docker-compose down"

# go
alias gor="go run"
alias gob="go build"
alias got="gotest"

# vim
alias vim="nvim"
