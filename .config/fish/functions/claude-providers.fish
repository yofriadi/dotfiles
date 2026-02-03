function claude-providers --description "List configured providers"
    set -l names
    for v in (set -n | string match -r '^__anth_provider__.*__base_url$')
        set -l name (string replace -r '^__anth_provider__(.*)__base_url$' '$1' $v)
        set names $names $name
    end
    printf "%s\n" $names | sort -u
end
