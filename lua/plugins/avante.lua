return {
  "yetone/avante.nvim",
  version = false, -- set this if you want to always pull the latest change
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
  opts = function()
    return {
      ---@alias avants.Provider "claude" | "openai" | "azure" | "gemini" | "cohere" | "copilot" | string
      provider = "deepseek", -- recommend using Claude
      auto_suggestions_provider = "deepseek", -- Since auto-suggestions are a high-frequency operation and therefore expensive, it is recommended to specify an inexpensive provider or even a free provider: copilot
      claude = {
        endpoint = "https://api.anthropic.com",
        model = "claude-3-5-sonnet-20241022",
        api_key_name = "ONEAPI_API_KEY",
        timeout = 30000, -- Timeout in milliseconds
        temperature = 0,
        max_tokens = 8000,
      },
      openai = {
        endpoint = os.getenv("ONEAPI_URL") .. "/v1",
        model = "gpt-4o",
        api_key_name = "ONEAPI_API_KEY",
        timeout = 30000, -- Timeout in milliseconds
        temperature = 0,
        max_tokens = 4096,
      },
      vendors = {
        grok = {
          __inherited_from = "openai",
          api_key_name = "ONEAPI_API_KEY",
          endpoint = os.getenv("ONEAPI_URL") .. "/v1",
          model = "grok-2-1212",
        },

        claude_oneapi = {
          __inherited_from = "openai",
          api_key_name = "ONEAPI_API_KEY",
          endpoint = os.getenv("ONEAPI_URL") .. "/v1",
          model = "claude-3-5-sonnet-20241022",
        },
        doubao = {
          __inherited_from = "openai",
          api_key_name = "ONEAPI_API_KEY",
          endpoint = os.getenv("ONEAPI_URL") .. "/v1",
          model = "doubao-pro-256k",
        },
        deepseek = {
          __inherited_from = "openai",
          api_key_name = "ONEAPI_API_KEY",
          endpoint = os.getenv("ONEAPI_URL") .. "/v1",
          model = "volc-deepseek-r1",
        },
        qwen_7b = {
          __inherited_from = "openai",
          api_key_name = "",
          endpoint = "http://127.0.0.1:1234/v1",
          model = "qwen2.5-coder-7b-instruct",
        },
        qwen_plus = {
          __inherited_from = "openai",
          api_key_name = "ONEAPI_API_KEY",
          endpoint = os.getenv("ONEAPI_URL") .. "/v1",
          model = "qwen-coder-plus-latest",
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
    local get_provider = function()
      local providers = require("avante.config").providers
      -- 过滤一下 providers ,不包含下面的 Provider
      local filtered_providers =
        { "claude", "azure", "gemini", "cohere", "copilot", "vertex", "claude-haiku", "claude-opus" }
      return vim.tbl_filter(function(provider)
        return not vim.tbl_contains(filtered_providers, provider)
      end, providers)
    end

    vim.keymap.set("n", "<leader>ap", function()
      local agents = get_provider()
      vim.ui.select(agents, {
        prompt = "Providers> ",
        format_item = function(item)
          local name = string.gsub(item, "_oneapi", "")
          return name
        end,
      }, function(selected)
        if selected then
          require("avante.api").switch_provider(vim.trim(selected))
        end
      end)
    end, { desc = "avante: switch provider" })
  end,
  build = vim.uv.os_uname().sysname:find("Windows") ~= nil
      and "powershell -executionpolicy bypass -file build.ps1 -buildfromsource false"
    or "make",
  dependencies = {},
}
