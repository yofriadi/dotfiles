if status is-interactive
    # Atuin
    atuin init fish --disable-up-arrow | source
    if functions -q _atuin_bind_up
        bind \eOA _atuin_bind_up
        bind \e\[A _atuin_bind_up
        bind -M insert \eOA _atuin_bind_up
        bind -M insert \e\[A _atuin_bind_up
    end

    # Zoxide
    zoxide init fish --cmd z | source

    # Starship
    if not set -q __starship_rebuilt
        __starship_rebuild
        set -g __starship_rebuilt 1
    end
    starship init fish | source
    
    # Fzf
    fzf --fish | source
end

# Mise
eval (mise completion fish | string collect)
mise activate --shims fish | source

# OrbStack: command-line tools and integration
# This won't be added again if you remove it.
source ~/.orbstack/shell/init.fish 2>/dev/null || :
