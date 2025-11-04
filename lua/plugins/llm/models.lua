return {
  ChatGpt = {
    name = "ChatGpt",
    url = os.getenv("ONEAPI_URL") .. "/v1/chat/completions",
    fetch_key = function()
      return vim.env.ONEAPI_KEY
    end,
    model = "gpt-5-nano",
    api_type = "openai",
  },
  Gemini = {
    name = "Gemini",
    url = os.getenv("ONEAPI_URL") .. "/v1/chat/completions",
    fetch_key = function()
      return vim.env.ONEAPI_KEY
    end,
    model = "gemini-2.5-flash",
    api_type = "openai",
  },
  Deepseek = {
    name = "Deepseek",
    url = os.getenv("ONEAPI_URL") .. "/v1/chat/completions",
    fetch_key = function()
      return vim.env.ONEAPI_KEY
    end,
    model = "deepseek-chat",
    api_type = "openai",
  },
  ChatGLM = {
    name = "ChatGLM",
    url = os.getenv("ONEAPI_URL") .. "/v1/chat/completions",
    fetch_key = function()
      return vim.env.ONEAPI_KEY
    end,
    model = "glm-4.5-air",
    api_type = "openai",
  },
}
