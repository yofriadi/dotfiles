# ~>
if status is-interactive
    # Commands to run in interactive sessions can go here
    atuin init fish | source
    eval (zellij setup --generate-auto-start fish | string collect)
    eval (atlas completion fish | string collect)
end

fish_vi_key_bindings

# Encore
set -x ENCORE_INSTALL "/home/ypcl/.encore"
set -x PATH "$ENCORE_INSTALL/bin:$PATH"

set -gx PATH $HOME/.local/bin $PATH

# Neovim
set -p PATH $HOME/.local/share/bob/nvim-bin $PATH

# Golang
set -x GOMODCACHE $HOME/.cache/go
set -x GOPATH $HOME/.local/share/go
set -x GOBIN $GOPATH/bin
set -x PATH $GOBIN $PATH

# PNPM
set -gx PATH ~/.local/share/pnpm $PATH
if not string match -q "*:$PNPM_HOME:*" $PATH
    set -Ux PATH $PNPM_HOME $PATH
end

# Gcloud
if test -f ~/.local/bin/google-cloud-sdk/path.fish.inc
    source ~/.local/bin/google-cloud-sdk/path.fish.inc
end

#alias docker="podman"

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

# pnpm
set -gx PNPM_HOME "/home/ypcl/.local/share/pnpm"
if not string match -q -- $PNPM_HOME $PATH
  set -gx PATH "$PNPM_HOME" $PATH
end
# pnpm end
