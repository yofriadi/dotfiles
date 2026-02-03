# ~>
if status is-interactive
    # Ensure vi bindings are set in the new global scope (fish 4.3+).
    set -g fish_key_bindings fish_vi_key_bindings
    fish_vi_key_bindings
    # Override Ctrl+L in all vi modes so scrollback isn't wiped.
    bind -M default \cl 'commandline -f repaint'
    bind -M insert \cl 'commandline -f repaint'
    bind -M visual \cl 'commandline -f repaint'
    bind -M replace \cl 'commandline -f repaint'
    bind -M replace_one \cl 'commandline -f repaint'
    set -U fish_greeting
end

# Load Rosé Pine Dawn theme
if test -f ~/.config/fish/themes/Rosé\ Pine\ Dawn.theme
    source ~/.config/fish/themes/Rosé\ Pine\ Dawn.theme
end
