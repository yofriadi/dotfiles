function __starship_rebuild
    set -l parts_dir "$HOME/.config/starship"
    set -l out_file "$HOME/.config/starship.toml"

    if not test -d $parts_dir
        return
    end

    set -l parts $parts_dir/*.toml
    if not test -e $parts[1]
        return
    end

    set -l rebuild 0
    if not test -f $out_file
        set rebuild 1
    else
        for part in $parts
            if test $part -nt $out_file
                set rebuild 1
                break
            end
        end
    end

    if test $rebuild -eq 1
        command cat $parts > $out_file
    end
end
