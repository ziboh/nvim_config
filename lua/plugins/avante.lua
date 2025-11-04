return {
  "yetone/avante.nvim",
  version = false, -- set this if you want to always pull the latest change
  build = vim.uv.os_uname().sysname:find("Windows") ~= nil
      and "powershell -executionpolicy bypass -file build.ps1 -buildfromsource false"
    or "make",
  enabled = false,
  cmd = {
    "AvanteAsk",
    "AvanteChat",
    "AvanteToggle",
    "AvanteSwitchProvider",
    "AvanteSwitchFileSelectorProvider",
    "AvanteShowRepoMap",
    "AvanteRefresh",
    "AvanteFocus",
    "AvanteEdit",
    "AvanteClear",
    "AvanteBuild",
  },
  opts = function()
    return {
      ---@alias avants.Provider "claude" | "openai" | "azure" | "gemini" | "cohere" | "copilot" | string
      provider = "moonshot", -- recommend using Claude
      auto_suggestions_provider = "moonshot", -- Since auto-suggestions are a high-frequency operation and therefore expensive, it is recommended to specify an inexpensive provider or even a free provider: copilot
      providers = {
        vertex_claude = {
          hide_in_model_selector = true,
        },
        vertex = {
          hide_in_model_selector = true,
        },
        ["openai-gpt-4o-mini"] = {
          hide_in_model_selector = true,
        },
        ["claude-haiku"] = {
          __inherited_from = "openai",
          api_key_name = "ONEAPI_API_KEY",
          endpoint = os.getenv("ONEAPI_URL") .. "/v1",
          model = "claude-haiku-4-5",
        },
        moonshot = {
          api_key_name = "ONEAPI_API_KEY",
          endpoint = os.getenv("ONEAPI_URL") .. "/v1",
          model = "kimi-k2-0905-preview",
          timeout = 30000, -- 超时时间（毫秒）
          extra_request_body = {
            temperature = 0.75,
            max_tokens = 32768,
          },
        },
        openai = {
          __inherited_from = "openai",
          api_key_name = "ONEAPI_API_KEY",
          endpoint = os.getenv("ONEAPI_URL") .. "/v1",
          model = "gpt-5",
        },
        deepseek = {
          __inherited_from = "openai",
          api_key_name = "ONEAPI_API_KEY",
          endpoint = os.getenv("ONEAPI_URL") .. "/v1",
          model = "deepseek-chat",
        },
        qwen = {
          __inherited_from = "openai",
          api_key_name = "ONEAPI_API_KEY",
          endpoint = os.getenv("ONEAPI_URL") .. "/v1",
          model = "qwen3-coder-plus",
        },
      },
      windows = {
        edit = {
          border = "rounded",
          start_insert = false, -- Start insert mode when opening the edit window
        },
        ask = {
          floating = false, -- Open the 'AvanteAsk' prompt in a floating window
          start_insert = true, -- Start insert mode when opening the ask window
          border = "rounded",
          ---@type "ours" | "theirs"
          focus_on_apply = "theirs", -- which diff to focus after applying
        },
      },
    }
  end,
  config = function(_, opts)
    local avante = require("avante")
    avante.setup(opts)
  end,
  keys = {
    {
      "<leader>aa",
      function()
        require("avante.api").ask()
      end,
      mode = { "n", "v" },
      desc = "avante: ask",
    },
    {
      "<leader>ae",
      function()
        require("avante.api").edit()
      end,
      mode = "v",
      desc = "avante: edit",
    },
    {
      "<leader>ar",
      function()
        require("avante.api").refresh()
      end,
      mode = "n",
      desc = "avante: refresh",
    },
    {
      "<leader>aF",
      function()
        require("avante.api").focus()
      end,
      mode = "n",
      desc = "avante: focus",
    },
    {
      "<leader>ap",
      "<cmd>AvanteModels<CR>",
      mode = { "n", "v" },
      desc = "avante: switch provider",
    },
    {
      "<leader>at",
      function()
        require("avante.api").toggle()
      end,
      mode = "n",
      desc = "avante: toggle",
    },
  },
}
