# ~>
if status is-interactive
    # Ensure vi bindings are set in the new global scope (fish 4.3+).
    set -g fish_key_bindings fish_vi_key_bindings
    fish_vi_key_bindings
    set -U fish_greeting
end

# Load Rosé Pine Dawn theme
source ~/.config/fish/themes/Rosé\ Pine\ Dawn.theme

# Load local secrets if present (kept out of git).
if test -f ~/.config/fish/secrets.fish
    source ~/.config/fish/secrets.fish
end
