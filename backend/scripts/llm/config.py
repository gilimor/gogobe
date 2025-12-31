import os

# OpenAI API Key
OPENAI_API_KEY = os.getenv("OPENAI_API_KEY", "")

# Gemini API Key (Alternative) - Default to specific value for convenience if provided by user
GEMINI_API_KEY = os.getenv("GEMINI_API_KEY", "")

# LLM Provider to use ('openai', 'gemini', 'mock')
# Automatic switching if key is present
DEFAULT_PROVIDER = "mock"
if GEMINI_API_KEY:
    DEFAULT_PROVIDER = "gemini"
elif OPENAI_API_KEY:
    DEFAULT_PROVIDER = "openai"

LLM_PROVIDER = os.getenv("LLM_PROVIDER", DEFAULT_PROVIDER)
