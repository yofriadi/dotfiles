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

# ante
fish_add_path /Users/ycm/.ante/bin

# cargo
fish_add_path /Users/ycm/.cargo/bin

# pnpm
set -gx PNPM_HOME "/Users/ycm/.local/share/pnpm"
if not string match -q -- "$PNPM_HOME/bin" $PATH
  set -gx PATH "$PNPM_HOME/bin" $PATH
end

# OpenCLI configuration for background headless Chromium
set -gx OPENCLI_CDP_ENDPOINT "http://127.0.0.1:9222"

# Zerobrew
#set -gx ZEROBREW_ROOT "$HOME/.local/share/zerobrew"
#set -gx ZEROBREW_PREFIX "/opt/zerobrew"
#fish_add_path "$ZEROBREW_PREFIX/bin"

# Mason LSP servers (nvim)
# Append so existing cargo/go/homebrew binaries keep priority.
fish_add_path --append "$HOME/.local/share/nvim/n/mason/bin"
