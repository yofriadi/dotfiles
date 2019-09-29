# Path to your oh-my-zsh installation.
# export ZSH="/Users/yofri/.oh-my-zsh"

# Set zsh theme
ZSH_THEME="spaceship"

# Uncomment the following line to disable auto-setting terminal title.
DISABLE_AUTO_TITLE="true"

# Load plugins
plugins=(
  zsh-syntax-highlighting
  zsh-autosuggestions
  zsh-completions
)

source $ZSH/oh-my-zsh.sh

# User configuration

SPACESHIP_GIT_BRANCH_SHOW=false
SPACESHIP_NODE_SHOW=false
SPACESHIP_KUBECONTEXT_SHOW=false
SPACESHIP_PACKAGE_SHOW=false

export LC_ALL=en_US.UTF-8
export HOMEBREW_GITHUB_API_TOKEN=20cf99cd519e35ec932169edb4f669bd802ebe9d
export PATH=$(brew --prefix openvpn)/sbin:$PATH
export PATH="$(yarn global bin):$PATH"

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
alias gss="git stash save"
alias gsl="git stash list"
alias sp="git stash pop"
alias co="git checkout"
alias cm="git commit -m"

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
alias dcu="docker-compose up"
alias dcd="docker-compose down"

# go
alias gor="go run"
alias gob="go build"
alias got="gotest"

# z.lua
eval "$(lua ~/.z.lua/z.lua --init zsh enhanced once fzf)"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

. $HOME/.asdf/asdf.sh
. $HOME/.asdf/completions/asdf.bash
