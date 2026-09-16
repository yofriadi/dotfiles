# Provider registry for codex-provider
# Maps provider names to their envKey and Base URL.
# Codex CLI uses OpenAI-compatible Chat Completions API format.

# OpenRouter
set -g __codex_provider__openrouter__envKey   "OPENROUTER_API_KEY"
set -g __codex_provider__openrouter__baseURL  "https://openrouter.ai/api/v1"

# Ollama (Local)
set -g __codex_provider__ollama__envKey       "OLLAMA_API_KEY"
set -g __codex_provider__ollama__baseURL      "http://localhost:11434/v1"

# Chutes (OpenAI compatible)
set -g __codex_provider__chutes__envKey       "CHUTES_API_KEY"
set -g __codex_provider__chutes__baseURL      "https://chutes.ai/api/v1"

# z.ai (GLM / Zhipu AI)
set -g __codex_provider__zai__envKey          "ZAI_API_KEY"
set -g __codex_provider__zai__baseURL         "https://api.z.ai/api/v1"

# Gemini
set -g __codex_provider__gemini__envKey       "GEMINI_API_KEY"
set -g __codex_provider__gemini__baseURL      "https://generativelanguage.googleapis.com/v1beta/openai"

# DeepSeek
set -g __codex_provider__deepseek__envKey     "DEEPSEEK_API_KEY"
set -g __codex_provider__deepseek__baseURL    "https://api.deepseek.com"

# Groq
set -g __codex_provider__groq__envKey         "GROQ_API_KEY"
set -g __codex_provider__groq__baseURL        "https://api.groq.com/openai/v1"

# Mistral
set -g __codex_provider__mistral__envKey      "MISTRAL_API_KEY"
set -g __codex_provider__mistral__baseURL     "https://api.mistral.ai/v1"

# xAI
set -g __codex_provider__xai__envKey          "XAI_API_KEY"
set -g __codex_provider__xai__baseURL         "https://api.x.ai/v1"
