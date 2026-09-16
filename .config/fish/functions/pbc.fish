# pbc: Launch pi with Tilth tools and Billion-Context (ACP) compression enabled.
# BILLION_CONTEXT_PROXY is unset so ACP activates normally.
function pbc
    set -l prompt_args
    if not string match -q -- '--system-prompt*' -- $argv
        set -l git_root (command git rev-parse --show-toplevel 2>/dev/null)
        if test -f .pi/SYSTEM.md
            set prompt_args --system-prompt "$PWD/.pi/SYSTEM.md"
        else if test -n "$git_root"; and test -f "$git_root/.pi/SYSTEM.md"
            set prompt_args --system-prompt "$git_root/.pi/SYSTEM.md"
        else if test -f ~/.pi/agent/SYSTEM.md
            set prompt_args --system-prompt ~/.pi/agent/SYSTEM.md
        end
    end

    env -u BILLION_CONTEXT_PROXY pi \
        $prompt_args \
        --exclude-tools web_screenshot,cache_clear,web_crawl,hound_version,ffgrep,fff-multi-grep,generate_image,read,grep,find,ls,tilth_deps,tilth_grok,tilth_diff,fffind \
        $argv
end
