return {
  {
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
        "<leader>af",
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
            model = "deepseek-coder",
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
    dependencies = {
      {
        -- Make sure to set this up properly if you have lazy=true
        "MeanderingProgrammer/render-markdown.nvim",
        opts = {
          file_types = { "markdown", "Avante" },
        },
        ft = { "markdown", "Avante" },
      },
    },
  },
  {
    "Robitx/gp.nvim",
    config = function()
      require("gp").setup({
        providers = {
          openai = {
            endpoint = os.getenv("ONEAPI_URL") .. "/v1/chat/completions",
            secret = os.getenv("ONEAPI_API_KEY"),
          },
          lmstudio = {
            endpoint = "http://localhost:1234/v1/chat/completions",
          },
        },
        agents = {
          {
            provider = "openai",
            name = "ChatDoubao",
            chat = true,
            command = false,
            -- string with model name or table with model name and parameters
            model = { model = "doubao-pro-256k", temperature = 1, top_p = 1 },
            -- system prompt (use this to specify the persona/role of the AI)
            system_prompt = require("gp.defaults").chat_system_prompt,
          },
          {
            provider = "openai",
            name = "CodeDoubao",
            chat = true,
            command = true,
            -- string with model name or table with model name and parameters
            model = { model = "doubao-pro-256k", temperature = 0.8, top_p = 1 },
            system_prompt = require("gp.defaults").code_system_prompt,
          },
          {
            provider = "openai",
            name = "ChatDeepseek",
            chat = true,
            command = false,
            -- string with model name or table with model name and parameters
            model = { model = "deepseek-chat", temperature = 1, top_p = 1 },
            -- system prompt (use this to specify the persona/role of the AI)
            system_prompt = require("gp.defaults").chat_system_prompt,
          },
          {
            provider = "openai",
            name = "CodeDeepseek",
            chat = true,
            command = true,
            -- string with model name or table with model name and parameters
            model = { model = "deepseek-coder", temperature = 0.8, top_p = 1 },
            system_prompt = require("gp.defaults").code_system_prompt,
          },
          {
            provider = "openai",
            name = "ChatGrok",
            chat = true,
            command = false,
            -- string with model name or table with model name and parameters
            model = { model = "grok-2-1212", temperature = 1, top_p = 1 },
            -- system prompt (use this to specify the persona/role of the AI)
            system_prompt = require("gp.defaults").chat_system_prompt,
          },
          {
            provider = "openai",
            name = "codegrok",
            chat = true,
            command = true,
            -- string with model name or table with model name and parameters
            model = { model = "grok-2-1212", temperature = 0.8, top_p = 1 },
            system_prompt = require("gp.defaults").code_system_prompt,
          },
          {
            provider = "openai",
            name = "ChatClaude-3-5-Sonnet",
            chat = true,
            command = false,
            -- string with model name or table with model name and parameters
            model = { model = "claude-3-5-sonnet-20241022", temperature = 1, top_p = 1 },
            -- system prompt (use this to specify the persona/role of the AI)
            system_prompt = require("gp.defaults").chat_system_prompt,
          },
          {
            name = "ChatClaude-3-Haiku",
            disable = true,
          },
          {
            provider = "openai",
            name = "CodeClaude-3-5-Sonnet",
            chat = true,
            command = true,
            -- string with model name or table with model name and parameters
            model = { model = "claude-3-5-sonnet-20241022", temperature = 0.8, top_p = 1 },
            system_prompt = require("gp.defaults").code_system_prompt,
          },
          {
            name = "CodeClaude-3-Haiku",
            disable = true,
          },
          {
            provider = "openai",
            name = "ChatGemini",
            chat = true,
            command = false,
            -- string with model name or table with model name and parameters
            model = { model = "gemini-1.5-flash", temperature = 1, top_p = 1 },
            -- system prompt (use this to specify the persona/role of the AI)
            system_prompt = require("gp.defaults").chat_system_prompt,
          },
          {
            provider = "openai",
            name = "CodeGemini",
            chat = true,
            command = true,
            -- string with model name or table with model name and parameters
            model = { model = "gemini-1.5-flash", temperature = 0.8, top_p = 1 },
            system_prompt = require("gp.defaults").code_system_prompt,
          },
          {
            provider = "openai",
            name = "ChatGPT4o",
            chat = true,
            command = false,
            -- string with model name or table with model name and parameters
            model = { model = "gpt-4o", temperature = 1, top_p = 1 },
            -- system prompt (use this to specify the persona/role of the AI)
            system_prompt = require("gp.defaults").chat_system_prompt,
          },
          {
            provider = "openai",
            name = "CodeGPT4o",
            chat = true,
            command = true,
            -- string with model name or table with model name and parameters
            model = { model = "gpt-4o", temperature = 0.8, top_p = 1 },
            -- system prompt (use this to specify the persona/role of the AI)
            system_prompt = require("gp.defaults").code_system_prompt,
          },
          {
            provider = "openai",
            name = "CodeGPT4o-mini",
            chat = true,
            command = true,
            -- string with model name or table with model name and parameters
            model = { model = "gpt-4o-mini", temperature = 0.8, top_p = 1 },
            -- system prompt (use this to specify the persona/role of the AI)
            system_prompt = require("gp.defaults").code_system_prompt,
          },
          {
            provider = "lmstudio",
            name = "CodeQwen",
            chat = true,
            command = true,
            -- string with model name or table with model name and parameters
            model = {
              model = "qwen2.5-coder-7b-instruct",
              temperature = 0.8,
              top_p = 1,
              num_ctx = 8192,
            },
            system_prompt = require("gp.defaults").code_system_prompt,
          },
          {
            provider = "lmstudio",
            name = "ChatQwen",
            chat = true,
            command = false,
            -- string with model name or table with model name and parameters
            model = {
              model = "qwen2.5-coder-7b-instruct",
              temperature = 0.97,
              top_p = 1,
              num_ctx = 8192,
            },
            -- system prompt (use this to specify the persona/role of the AI)
            system_prompt = require("gp.defaults").chat_system_prompt,
          },
          {
            provider = "openai",
            name = "ChatGPT4o-mini",
            chat = true,
            command = false,
            -- string with model name or table with model name and parameters
            model = { model = "gpt-4o-mini", temperature = 1, top_p = 1 },
            -- system prompt (use this to specify the persona/role of the AI)
            system_prompt = require("gp.defaults").chat_system_prompt,
          },
        },
        template_selection = "我有来自 {{filename}} 文件中的内容如下:"
          .. "\n\n```{{filetype}}\n{{selection}}\n```\n\n{{command}}",
        template_rewrite = "I have the following from {{filename}}:"
          .. "\n\n```{{filetype}}\n{{selection}}\n```\n\n{{command}}"
          .. "\n\nRespond exclusively with the snippet that should replace the selection above.",
        template_append = "I have the following from {{filename}}:"
          .. "\n\n```{{filetype}}\n{{selection}}\n```\n\n{{command}}"
          .. "\n\nRespond exclusively with the snippet that should be appended after the selection above.",
        template_prepend = "I have the following from {{filename}}:"
          .. "\n\n```{{filetype}}\n{{selection}}\n```\n\n{{command}}"
          .. "\n\nRespond exclusively with the snippet that should be prepended before the selection above.",
        template_command = "{{command}}",
        chat_template = [[
# topic: ?

- file: {{filename}}
{{optional_headers}}
在 {{user_prefix}} 后输入您的问题。使用 `{{respond_shortcut}}` 或 :{{cmd_prefix}}ChatRespond 生成请求。
可以通过使用 `{{stop_shortcut}}` 或 :{{cmd_prefix}}ChatStop 命令来终止响应。
聊天内容会自动保存。要删除此聊天，请使用 `{{delete_shortcut}}` 或 :{{cmd_prefix}}ChatDelete。
请注意非常长的聊天。使用 `{{new_shortcut}}` 或 :{{cmd_prefix}}ChatNew 开始一个新的聊天。

---

{{user_prefix}}
]],
        hooks = {
          -- example of adding command which opens new chat dedicated for translation
          Translator = function(gp, params)
            local chat_system_prompt = "You are a Translator, please translate between English and Chinese."
            gp.cmd.ChatNew(params, chat_system_prompt)
          end,
        },
      })
      local get_agent = function()
        local buf = vim.api.nvim_get_current_buf()
        local file_name = vim.api.nvim_buf_get_name(buf)
        local is_chat = require("gp").not_chat(buf, file_name) == nil
        return is_chat and require("gp")._chat_agents or require("gp")._command_agents
      end

      vim.keymap.set("n", "<c-g>z", function()
        local agents = get_agent()
        vim.ui.select(agents, {
          prompt = "Models> ",
          format_item = function(item)
            return item
          end,
        }, function(selected)
          if selected then
            vim.cmd("GpAgent " .. selected)
          end
        end)
      end, { desc = "GPT prompt Choose Agent" })
    end,
    keys = {
      { "<C-g>z", desc = "GPT prompt Choose Agent" },
      { "<C-g>c", "<cmd>GpChatNew vsplit<cr>", mode = { "n", "i" }, desc = "New Chat" },
      { "<C-g>t", "<cmd>GpChatToggle<cr>", mode = { "n", "i" }, desc = "Toggle Chat" },
      { "<C-g>f", "<cmd>GpChatFinder<cr>", mode = { "n", "i" }, desc = "Chat Finder" },

      { "<C-g>c", ":'<,'>GpChatNew vsplit<cr>", mode = "v", desc = "Visual Chat New" },
      { "<C-g>p", ":'<,'>GpChatPaste<cr>", mode = "v", desc = "Visual Chat Paste" },
      { "<C-g>t", ":'<,'>GpChatToggle<cr>", mode = "v", desc = "Visual Toggle Chat" },

      { "<C-g><C-x>", "<cmd>GpChatNew split<cr>", mode = { "n", "i" }, desc = "New Chat split" },
      { "<C-g><C-v>", "<cmd>GpChatNew vsplit<cr>", mode = { "n", "i" }, desc = "New Chat vsplit" },
      { "<C-g><C-t>", "<cmd>GpChatNew tabnew<cr>", mode = { "n", "i" }, desc = "New Chat tabnew" },
      { "<C-g><C-g>", "<cmd>GpChatRespond<cr>", mode = { "n", "i", "v" }, desc = "Chat Respond" },
      { "<C-g>d", "<cmd>GpChatDelete<cr>", mode = { "n", "v" }, desc = "Delete the current chat" },

      { "<C-g><C-x>", ":'<,'>GpChatNew split<cr>", mode = "v", desc = "Visual Chat New split" },
      { "<C-g><C-v>", ":'<,'>GpChatNew vsplit<cr>", mode = "v", desc = "Visual Chat New vsplit" },
      { "<C-g><C-t>", ":'<,'>GpChatNew tabnew<cr>", mode = "v", desc = "Visual Chat New tabnew" },

      { "<C-g>r", "<cmd>GpRewrite<cr>", mode = { "n", "i" }, desc = "Inline Rewrite" },
      { "<C-g>a", "<cmd>GpAppend<cr>", mode = { "n", "i" }, desc = "Append (after)" },
      { "<C-g>b", "<cmd>GpPrepend<cr>", mode = { "n", "i" }, desc = "Prepend (before)" },

      { "<C-g>r", ":'<,'>GpRewrite<cr>", mode = "v", desc = "Visual Rewrite" },
      { "<C-g>a", ":'<,'>GpAppend<cr>", mode = "v", desc = "Visual Append (after)" },
      { "<C-g>b", ":'<,'>GpPrepend<cr>", mode = "v", desc = "Visual Prepend (before)" },
      { "<C-g>i", ":'<,'>GpImplement<cr>", mode = "v", desc = "Implement selection" },

      { "<C-g>gp", "<cmd>GpPopup<cr>", mode = { "n", "i" }, desc = "Popup" },
      { "<C-g>ge", "<cmd>GpEnew<cr>", mode = { "n", "i" }, desc = "GpEnew" },
      { "<C-g>gn", "<cmd>GpNew<cr>", mode = { "n", "i" }, desc = "GpNew" },
      { "<C-g>gv", "<cmd>GpVnew<cr>", mode = { "n", "i" }, desc = "GpVnew" },
      { "<C-g>gt", "<cmd>GpTabnew<cr>", mode = { "n", "i" }, desc = "GpTabnew" },

      { "<C-g>gp", ":'<,'>GpPopup<cr>", mode = "v", desc = "Visual Popup" },
      { "<C-g>ge", ":'<,'>GpEnew<cr>", mode = "v", desc = "Visual GpEnew" },
      { "<C-g>gn", ":'<,'>GpNew<cr>", mode = "v", desc = "Visual GpNew" },
      { "<C-g>gv", ":'<,'>GpVnew<cr>", mode = "v", desc = "Visual GpVnew" },
      { "<C-g>gt", ":'<,'>GpTabnew<cr>", mode = "v", desc = "Visual GpTabnew" },

      { "<C-g>x", "<cmd>GpContext<cr>", mode = { "n", "i", "v", "x" }, desc = "Toggle Context" },
      { "<C-g>s", "<cmd>GpStop<cr>", mode = { "n", "i", "v", "x" }, desc = "Stop" },
      { "<C-g>n", "<cmd>GpNextAgent<cr>", mode = { "n", "i", "v", "x" }, desc = "Next Agent" },

      { "<C-g>ww", "<cmd>GpWhisper<cr>", mode = { "n", "i" }, desc = "Whisper" },
      { "<C-g>ww", ":'<,'>GpWhisper<cr>", mode = "v", desc = "Visual Whisper" },

      { "<C-g>wr", "<cmd>GpWhisperRewrite<cr>", mode = { "n", "i" }, desc = "Whisper Inline Rewrite" },
      { "<C-g>wa", "<cmd>GpWhisperAppend<cr>", mode = { "n", "i" }, desc = "Whisper Append (after)" },
      { "<C-g>wb", "<cmd>GpWhisperPrepend<cr>", mode = { "n", "i" }, desc = "Whisper Prepend (before) " },

      { "<C-g>wr", ":'<,'>GpWhisperRewrite<cr>", mode = "v", desc = "Visual Whisper Rewrite" },
      { "<C-g>wa", ":'<,'>GpWhisperAppend<cr>", mode = "v", desc = "Visual Whisper Append (after)" },
      { "<C-g>wb", ":'<,'>GpWhisperPrepend<cr>", mode = "v", desc = "Visual Whisper Prepend (before)" },

      { "<C-g>wp", "<cmd>GpWhisperPopup<cr>", mode = { "n", "i" }, desc = "Whisper Popup" },
      { "<C-g>we", "<cmd>GpWhisperEnew<cr>", mode = { "n", "i" }, desc = "Whisper Enew" },
      { "<C-g>wn", "<cmd>GpWhisperNew<cr>", mode = { "n", "i" }, desc = "Whisper New" },
      { "<C-g>wv", "<cmd>GpWhisperVnew<cr>", mode = { "n", "i" }, desc = "Whisper Vnew" },
      { "<C-g>wt", "<cmd>GpWhisperTabnew<cr>", mode = { "n", "i" }, desc = "Whisper Tabnew" },

      { "<C-g>wp", ":'<,'>GpWhisperPopup<cr>", mode = "v", desc = "Visual Whisper Popup" },
      { "<C-g>we", ":'<,'>GpWhisperEnew<cr>", mode = "v", desc = "Visual Whisper Enew" },
      { "<C-g>wn", ":'<,'>GpWhisperNew<cr>", mode = "v", desc = "Visual Whisper New" },
      { "<C-g>wv", ":'<,'>GpWhisperVnew<cr>", mode = "v", desc = "Visual Whisper Vnew" },
      { "<C-g>wt", ":'<,'>GpWhisperTabnew<cr>", mode = "v", desc = "Visual Whisper Tabnew" },
    },
  },
}
