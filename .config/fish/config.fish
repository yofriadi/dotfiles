# ~>
if status is-interactive
    # Commands to run in interactive sessions can go here
    atuin init fish | source
    eval (zellij setup --generate-auto-start fish | string collect)
end

fish_vi_key_bindings

set -p PATH $HOME/.local/bin $PATH

# Neovim
#set -Ux PATH $HOME/.local/share/bob/nvim-bin $PATH
set -p PATH $HOME/.local/share/bob/nvim-bin $PATH

# Golang
set -Ux GOMODCACHE $HOME/.cache/go
set -Ux GOBIN $GOPATH/bin
set -Ux PATH $GOBIN $PATH

# PNPM
#set -Ux PNPM_HOME ~/.local/share/pnpm
set -p PATH ~/.local/share/pnpm $PATH
if not string match -q "*:$PNPM_HOME:*" $PATH
    set -Ux PATH $PNPM_HOME $PATH
end

# Gcloud
if test -f ~/.local/bin/google-cloud-sdk/path.fish.inc
    source ~/.local/bin/google-cloud-sdk/path.fish.inc
end

alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."

alias n='NVIM_APPNAME=nvim/default nvim'
alias na='NVIM_APPNAME=nvim/AstroNvim nvim'

alias l="eza"
alias ll="eza -l"
alias la="eza -a"
alias lla="eza -la"

alias zl="zellij"
alias hx="helix"

alias cat="bat"
set -Ux BAT_THEME tokyonight_storm

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

function nvim_paste
    # Check for win32yank.exe executable
    if command -v win32yank.exe >/dev/null 2>/dev/null
        # The --lf option pastes data unix style. Which is what I almost always want.
        win32yank.exe -o --lf
    else
        # Else rely on PowerShell being installed and available.
        powershell.exe Get-Clipboard | tr -d '\r' | sed -z '$ s/\n$//'
    end
end

zoxide init fish | source
starship init fish | source
