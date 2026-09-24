function sync-alacritty --description "Sync Windows Alacritty config and themes from dotfiles to AppData"
    if not type -q wslpath; or not type -q cmd.exe
        echo "sync-alacritty: WSL Windows interop (wslpath, cmd.exe) not found. This command is only for WSL." >&2
        return 1
    end

    set -l raw_appdata (cmd.exe /c "echo %APPDATA%" 2>/dev/null | string trim)
    if test -z "$raw_appdata"
        echo "sync-alacritty: Could not determine Windows %APPDATA% path." >&2
        return 1
    end

    set -l win_alacritty (wslpath "$raw_appdata")/alacritty
    set -l src_dir $__fish_config_dir/../alacritty
    if not test -d "$src_dir"
        set src_dir $HOME/.config/alacritty
    end

    if not test -f "$src_dir/alacritty.windows.toml"
        echo "sync-alacritty: Source file not found: $src_dir/alacritty.windows.toml" >&2
        return 1
    end

    command mkdir -p "$win_alacritty"

    # Copy Windows config as the primary alacritty.toml
    command cp "$src_dir/alacritty.windows.toml" "$win_alacritty/alacritty.toml"

    # Copy themes
    for theme in $src_dir/*.toml
        set -l filename (basename $theme)
        if test "$filename" != "alacritty.toml" -a "$filename" != "alacritty.windows.toml"
            command cp "$theme" "$win_alacritty/$filename"
        end
    end

    echo "Synced Alacritty config and themes -> $win_alacritty"
end
