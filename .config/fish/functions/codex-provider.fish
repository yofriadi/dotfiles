function codex-provider --description "Run codex with provider-specific config overrides" --wraps codex
    if test (count $argv) -lt 1
        echo "Usage: codex-provider <provider> [model] <codex args...>"
        echo "Example: codex-provider chutes \"Write a function\""
        echo "         codex-provider chutes gpt-4o \"Write a function\""
        return 2
    end

    set -l provider $argv[1]
    set -e argv[1]

    # Dynamic variable names
    set -l envKey_var  "__codex_provider__"$provider"__envKey"
    set -l baseURL_var "__codex_provider__"$provider"__baseURL"

    # Pull values via `eval` (fish doesn't have indirect expansion like bash)
    set -l envKey  (eval echo \$$envKey_var)
    set -l baseURL (eval echo \$$baseURL_var)

    if test -z "$envKey" -o -z "$baseURL"
        echo "Unknown or incomplete provider: $provider"
        echo "Missing: $envKey_var and/or $baseURL_var"
        return 1
    end

    # Get the actual API key from the environment
    set -l apiKey (eval echo \$$envKey)
    if test -z "$apiKey"
        echo "Missing API key: \$$envKey is not set"
        return 1
    end

    # Print status to stderr so it doesn't interfere with piped output
    echo " (active provider: $provider -> $baseURL)" >&2

    # Build config overrides
    # Codex uses dotted paths for nested config values
    set -l config_args
    set -a config_args -c "providers.$provider.name=$provider"
    set -a config_args -c "providers.$provider.baseURL=$baseURL"
    set -a config_args -c "providers.$provider.envKey=$envKey"
    set -a config_args -c "model_provider=$provider"

    # Run codex with config overrides
    command codex $config_args $argv
end
