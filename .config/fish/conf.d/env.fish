set -gx VISUAL nvim
set -gx EDITOR nvim

if test -d /opt/homebrew/bin
    fish_add_path --append /opt/homebrew/bin
else if test -d /home/linuxbrew/.linuxbrew/bin
    fish_add_path --append /home/linuxbrew/.linuxbrew/bin
end

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
if test -f "$HOME/.local/bin/google-cloud-sdk/path.fish.inc"
    source "$HOME/.local/bin/google-cloud-sdk/path.fish.inc"
else if type -q brew
    if test -f (brew --prefix)/share/google-cloud-sdk/path.fish.inc
        source (brew --prefix)/share/google-cloud-sdk/path.fish.inc
    end
end

set -gx BAT_THEME rose-pine-dawn

# pnpm
set -gx PNPM_HOME "$HOME/.local/share/pnpm"
fish_add_path "$PNPM_HOME"
if not string match -q -- "$PNPM_HOME/bin" $PATH
    set -gx PATH "$PNPM_HOME/bin" $PATH
end


# Rainfrog
set -gx RAINFROG_CONFIG "$HOME/.config/rainfrog"
set -gx RAINFROG_FAVORITES "$HOME/.local/share/rainfrog/favorites"

# ante
fish_add_path "$HOME/.ante/bin"

# cargo
fish_add_path "$HOME/.cargo/bin"

# OpenCLI configuration for background headless Chromium
set -gx OPENCLI_CDP_ENDPOINT "http://127.0.0.1:9222"

# Zerobrew
#set -gx ZEROBREW_ROOT "$HOME/.local/share/zerobrew"
#set -gx ZEROBREW_PREFIX "/opt/zerobrew"
#fish_add_path "$ZEROBREW_PREFIX/bin"

# Mason LSP servers (nvim)
# Append so existing cargo/go/homebrew binaries keep priority.
fish_add_path --append "$HOME/.local/share/nvim/n/mason/bin"
