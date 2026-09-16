function p
    set -l tools_args
    set -l forward_args
    set -l i 1
    set -l total (count $argv)

    while test $i -le $total
        set -l arg $argv[$i]
        switch $arg
            case -t --tools
                set i (math $i + 1)
                if test $i -le $total
                    set -a tools_args $argv[$i]
                else
                    echo "p: error: flag requires an argument: $arg" >&2
                    return 1
                end
            case "--tools=*"
                set -a tools_args (string replace -- "--tools=" "" -- $arg)
            case "*"
                set -a forward_args $arg
        end
        set i (math $i + 1)
    end

    set -l has_tilth 0
    set -l has_fff 0
    set -l has_acp 0
    set -l extra_tools

    if test (count $tools_args) -gt 0
        for raw_item in (string split "," -- (string join "," -- $tools_args))
            set -l item (string trim -- $raw_item)
            test -z "$item"; and continue
            switch $item
                case tilth tilth_read
                    set has_tilth 1
                case fff fffind ffgrep
                    set has_fff 1
                case acp compress
                    set has_acp 1
                case browser
                    set -a extra_tools agent_browser
                case web
                    set -a extra_tools web_fetch web_search
                case core
                    # core tools are part of the base
                case "*"
                    set -a extra_tools $item
            end
        end
    end

    set -l active_tools bash edit write

    if test $has_tilth -eq 1
        set -a active_tools tilth_read tilth_search tilth_list
    else if test $has_fff -eq 1
        set -a active_tools read fffind ffgrep
    else
        # Original Pi tools by default
        set -a active_tools read grep find ls
    end

    if test $has_acp -eq 1
        set -a active_tools compress decompress search_context acp_status
    end

    for extra in $extra_tools
        if not contains -- $extra $active_tools
            set -a active_tools $extra
        end
    end

    # Dynamically generate ~/.pi/agent/SYSTEM.md based on active tools
    if command -q node; and test -f ~/.pi/agent/generate-system-prompt.js
        if not node ~/.pi/agent/generate-system-prompt.js (string join "," -- $active_tools) 2>/dev/null
            echo "p: warning: failed to regenerate ~/.pi/agent/SYSTEM.md" >&2
        end
    end

    set -l prompt_args
    if not string match -q -- '--system-prompt*' -- $forward_args
        set -l git_root (command git rev-parse --show-toplevel 2>/dev/null)
        if test -f .pi/SYSTEM.md
            set prompt_args --system-prompt "$PWD/.pi/SYSTEM.md"
        else if test -n "$git_root"; and test -f "$git_root/.pi/SYSTEM.md"
            set prompt_args --system-prompt "$git_root/.pi/SYSTEM.md"
        else if test -f ~/.pi/agent/SYSTEM.md
            set prompt_args --system-prompt ~/.pi/agent/SYSTEM.md
        end
    end

    set -l fff_flag
    if test $has_fff -eq 1; and test $has_tilth -eq 0
        set fff_flag --fff-mode tools-and-ui
    end

    if test $has_acp -eq 0
        BILLION_CONTEXT_PROXY=1 command pi \
            $fff_flag \
            $prompt_args \
            --tools (string join "," -- $active_tools) \
            $forward_args
    else
        env -u BILLION_CONTEXT_PROXY pi \
            $fff_flag \
            $prompt_args \
            --tools (string join "," -- $active_tools) \
            $forward_args
    end
end
