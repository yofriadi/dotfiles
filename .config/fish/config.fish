# ~>
if status is-interactive
    # Commands to run in interactive sessions can go here
    atuin init fish | source
end

fish_vi_key_bindings
set -U fish_greeting

set -Ux VISUAL nvim
set -Ux EDITOR hx
set -gx PATH /opt/homebrew/bin $PATH

# Encore
#set -x ENCORE_INSTALL "/home/ypcl/.encore"
#set -x PATH "$ENCORE_INSTALL/bin:$PATH"

set -gx PATH $HOME/.local/bin $PATH

# Neovim
set -p PATH $HOME/.local/share/bob/nvim-bin $PATH

# Bun
#set -x PATH $HOME/.local/bin/bun $PATH

# Golang
set -x GOMODCACHE $HOME/.cache/go
set -x GOPATH $HOME/.local/share/go
set -x GOBIN $GOPATH/bin
set -x PATH $GOBIN $PATH

# Gcloud
source "$(brew --prefix)/share/google-cloud-sdk/path.fish.inc"

alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."

alias n='NVIM_APPNAME=nvim/n nvim'
alias nn='NVIM_APPNAME=nvim/nn nvim'
alias na='NVIM_APPNAME=nvim/AstroNvim nvim'
alias nv='NVIM_APPNAME=nvim/NvChad nvim'
alias nl='NVIM_APPNAME=nvim/LazyVim nvim'

alias l="eza"
alias ll="eza -l"
alias la="eza -a"
alias lla="eza -la"

alias zl="zellij"
alias cr="coderabbit"

alias cat="bat"
set -Ux BAT_THEME rose-pine-dawn

#set OLD feat/endpoint-update-char; set NEW refactor/fi-pp; set REMOTE origin; git branch -m $OLD $NEW && git push $REMOTE --delete $OLD && git push $REMOTE $NEW && git push $REMOTE -u $NEW

alias gwip='git add -A; git rm $(git ls-files --deleted) 2> /dev/null; git commit --no-verify --no-gpg-sign --message "--wip-- [skip ci]"'
alias gunwip='git rev-list --max-count=1 --format="%s" HEAD | grep -q "\--wip--" && git reset HEAD~1'

# Similar to `gunwip` but recursive "Unwips" all recent `--wip--` commits not just the last one
function gunwipall
    set -l _commit (git log --grep='--wip--' --invert-grep --max-count=1 --format=format:%H)

    # Check if a commit without "--wip--" was found and it's not the same as HEAD
    if test "$_commit" != (git rev-parse HEAD)
        git reset $_commit; or return 1
    end
end

zoxide init fish --cmd z | source
starship init fish | source
fzf --fish | source
mise activate fish | source

#eval (zellij setup --generate-auto-start fish | string collect)
eval (mise completion fish | string collect)
#eval (atlas completion fish | string collect)

#set -Ux PATH $PATH $HOME/.spoof-dpi/bin

# pnpm
set -Ux PNPM_HOME ~/.local/share/pnpm
fish_add_path $PNPM_HOME

# bun
set --export BUN_INSTALL "$HOME/.local/share/bun"
set --export PATH $BUN_INSTALL/bin $PATH

# Added by Windsurf
fish_add_path /Users/ycm/.codeium/windsurf/bin

function postexec_separator --on-event fish_postexec
    # Get the terminal width (using tput for portability)
    set width (tput cols)
    # Print a line of your chosen character (here we use the box-drawing dash)
    printf '%*s\n' $width '' | tr ' ' '─'
end

# Added by OrbStack: command-line tools and integration
# This won't be added again if you remove it.
source ~/.orbstack/shell/init.fish 2>/dev/null || :

string match -q "$TERM_PROGRAM" kiro and . (kiro --locate-shell-integration-path fish)
