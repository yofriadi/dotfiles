function claude-provider --description "Run claude with provider-specific ANTHROPIC_* env" --wraps claude
    if test (count $argv) -lt 1
        echo "Usage: claude-provider <provider> <claude args...>"
        echo "Example: claude-provider ollama chat"
        return 2
    end

    set -l provider $argv[1]
    set -e argv[1]

    # Dynamic variable names
    set -l token_var "__anth_provider__"$provider"__token"
    set -l base_var  "__anth_provider__"$provider"__base_url"
    set -l extra_var "__anth_provider__"$provider"__extra_env"

    # Pull values via `eval` (fish doesn't have indirect expansion like bash)
    set -l token (eval echo \$$token_var)
    set -l base  (eval echo \$$base_var)
    set -l extra (eval echo \$$extra_var)

    if test -z "$token" -o -z "$base"
        echo "Unknown or incomplete provider: $provider"
        echo "Missing: $token_var and/or $base_var"
        return 1
    end

    # Build env args safely
    set -l env_args "ANTHROPIC_AUTH_TOKEN=$token" "ANTHROPIC_BASE_URL=$base"

    # Print status to stderr so it doesn't interfere with piped output
    echo " (active provider: $provider -> $base)" >&2

    # Add optional extra env like KEY=VAL entries
    if test -n "$extra"
        set env_args $env_args $extra
    end

    # Run: env KEY=VAL KEY2=VAL2 claude ...
    command env $env_args claude $argv
end
