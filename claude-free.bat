@echo off
set ANTHROPIC_BASE_URL=https://openrouter.ai/api
set ANTHROPIC_AUTH_TOKEN=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
set ANTHROPIC_API_KEY=
claude --model openrouter/free %*
