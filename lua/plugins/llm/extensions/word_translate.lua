local prompts = require("plugins.llm.prompts")
local tools = require("llm.tools")
return {
  handler = tools.flexi_handler,
  prompt = prompts.WordTranslate,
  -- prompt = "Translate the following text to English, please only return the translation",
  opts = {
    url = os.getenv("ONEAPI_URL") .. "/v1/chat/completions",
    fetch_key = vim.env.ONEAPI_KEY,
    model = "glm-4.5-flash",
    api_type = "openai",

    win_opts = {
      zindex = 120,
    },
    exit_on_move = false,
    enter_flexible_window = true,
    enable_cword_context = true,
  },
}
