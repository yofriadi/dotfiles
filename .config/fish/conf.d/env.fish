set -Ux VISUAL nvim
set -Ux EDITOR nvim

fish_add_path --append /opt/homebrew/bin

fish_add_path $HOME/.local/bin

# Bun
set -gx BUN_INSTALL "$HOME/.local/share/bun"
fish_add_path "$BUN_INSTALL/bin"

# Golang
set -x GOMODCACHE "$HOME/.cache/go"
set -x GOPATH "$HOME/.local/share/go"
set -x GOBIN "$GOPATH/bin"
fish_add_path "$GOBIN"

# Gcloud
if type -q brew
    if test -f (brew --prefix)/share/google-cloud-sdk/path.fish.inc
        source (brew --prefix)/share/google-cloud-sdk/path.fish.inc
    end
end

set -Ux BAT_THEME rose-pine-dawn

# pnpm
set -Ux PNPM_HOME "$HOME/.local/share/pnpm"
fish_add_path "$PNPM_HOME"

# Rainfrog
set -gx RAINFROG_CONFIG "$HOME/.config/rainfrog"
set -gx RAINFROG_FAVORITES "$HOME/.local/share/rainfrog/favorites"