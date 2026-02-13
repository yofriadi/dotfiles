# Provider registry for claude-provider
# Maps provider names to their Token and Base URL environment variables.

# OpenRouter
set -g __anth_provider__openrouter__token    $OPENROUTER_API_KEY
set -g __anth_provider__openrouter__base_url "https://openrouter.ai/api/v1"

# Ollama (Local Gateway to Cloud Models)
# Uses local ollama instance which handles the cloud connection.
# Requires 'ollama serve' to be running.
set -g __anth_provider__ollama__token    "ollama"
set -g __anth_provider__ollama__base_url "http://localhost:11434"

# Chutes (OpenAI compatible)
# Base URL matches the official chutes_claude_code_env.sh script
set -g __anth_provider__chutes__token    $CHUTES_API_KEY
set -g __anth_provider__chutes__base_url "https://claude.chutes.ai"
set -g __anth_provider__chutes__extra_env \
    "ANTHROPIC_DEFAULT_HAIKU_MODEL=moonshotai/Kimi-K2.5-TEE" \
    "ANTHROPIC_DEFAULT_SONNET_MODEL=moonshotai/Kimi-K2.5-TEE" \
    "ANTHROPIC_DEFAULT_OPUS_MODEL=moonshotai/Kimi-K2.5-TEE" \
    "CLAUDE_CODE_SUBAGENT_MODEL=moonshotai/Kimi-K2.5-TEE" \
    "ANTHROPIC_SMALL_FAST_MODEL=moonshotai/Kimi-K2.5-TEE"

# z.ai (GLM / Zhipu AI)
set -g __anth_provider__zai__token       $ZAI_API_KEY
set -g __anth_provider__zai__base_url    "https://api.z.ai/api/anthropic"
set -g __anth_provider__chutes__extra_env \
    "ANTHROPIC_DEFAULT_HAIKU_MODEL=GLM-4.7-Air" \
    "ANTHROPIC_DEFAULT_SONNET_MODEL=GLM-4.7" \
    "ANTHROPIC_DEFAULT_OPUS_MODEL=GLM-5" \
    "CLAUDE_CODE_SUBAGENT_MODEL=GLM-4.7" \
    "ANTHROPIC_SMALL_FAST_MODEL=GLM-4.7-Air"

# Example: proxy / gateway
# set -g __anth_provider__gateway__token    "TOKEN_FOR_GATEWAY"
# set -g __anth_provider__gateway__base_url "https://anthropic.mycompany.internal"
