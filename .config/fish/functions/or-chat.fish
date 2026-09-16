function or-chat
    set -l model "openrouter/aurora-alpha"
    set -l prompt ""

    # Check if first argument contains a slash (model identifier)
    if set -q argv[1]
        if string match -q '*/*' $argv[1]
            set model $argv[1]
            set prompt $argv[2..]
        else
            set prompt $argv
        end
    end

    # Validate prompt was provided
    if test -z "$prompt"
        echo "Usage: or-chat [model] \"prompt\""
        echo "Example: or-chat \"What is 2+2?\""
        echo "Example: or-chat anthropic/claude-3.5-sonnet \"Explain recursion\""
        return 1
    end

    # Make API call to OpenRouter
    curl -s https://openrouter.ai/api/v1/chat/completions \
        -H "Content-Type: application/json" \
        -H "Authorization: Bearer $OPENROUTER_API_KEY" \
        -H "HTTP-Referer: https://github.com" \
        -d "{\"model\": \"$model\", \"messages\": [{\"role\": \"user\", \"content\": \"$prompt\"}]}" \
        | jq -r '.choices[0].message.content'
end
