set -Ux VISUAL nvim
set -Ux EDITOR nvim
fish_add_path --append /opt/homebrew/bin

set -gx PATH $HOME/.local/bin $PATH

# Bun
set -gx BUN_INSTALL "$HOME/.local/share/bun"
set -gx PATH "$BUN_INSTALL/bin" $PATH

# Golang
set -x GOMODCACHE $HOME/.cache/go
set -x GOPATH $HOME/.local/share/go
set -x GOBIN $GOPATH/bin
set -x PATH $GOBIN $PATH

# Gcloud
if type -q brew
    source "$(brew --prefix)/share/google-cloud-sdk/path.fish.inc"
end

set -Ux BAT_THEME rose-pine-dawn

# pnpm
set -Ux PNPM_HOME ~/.local/share/pnpm
fish_add_path $PNPM_HOME

# Windsurf
fish_add_path /Users/ycm/.codeium/windsurf/bin

# Amp CLI
set -gx PATH "/Users/ycm/.amp/bin" $PATH
