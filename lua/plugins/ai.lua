return {
  {
    "yetone/avante.nvim",
    event = "VeryLazy",
    enabled = true,
    lazy = false,
    version = false, -- set this if you want to always pull the latest change
    opts = function()
      return {
        ---@alias Provider "claude" | "openai" | "azure" | "gemini" | "cohere" | "copilot" | string
        provider = "grok", -- recommend using Claude
        auto_suggestions_provider = "claude", -- Since auto-suggestions are a high-frequency operation and therefore expensive, it is recommended to specify an inexpensive provider or even a free provider: copilot
        claude = {},
        openai = {
          endpoint = os.getenv "ONEAPI_URL" .. "/v1",
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
            endpoint = os.getenv "ONEAPI_URL" .. "/v1",
            model = "grok-2-1212",
          },

          claude_openai = {
            __inherited_from = "openai",
            api_key_name = "ONEAPI_API_KEY",
            endpoint = os.getenv "ONEAPI_URL" .. "/v1",
            model = "claude-3-5-sonnet-20241022",
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
            endpoint = os.getenv "ONEAPI_URL" .. "/v1",
            model = "qwen-coder-plus-latest",
          },
        },
      }
    end,
    build = "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false",
    dependencies = {
      {
        -- support for image pasting
        "HakonHarnes/img-clip.nvim",
        event = "VeryLazy",
        opts = {
          -- recommended settings
          default = {
            embed_image_as_base64 = false,
            prompt_for_file_name = false,
            drag_and_drop = {
              insert_mode = true,
            },
            -- required for Windows users
            use_absolute_path = true,
          },
        },
      },
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
    event = "VeryLazy",
    config = function()
      require("gp").setup {
        providers = {
          openai = {
            endpoint = os.getenv "ONEAPI_URL" .. "/v1/chat/completions",
            secret = os.getenv "ONEAPI_API_KEY",
          },
          lmstudio = {
            endpoint = "http://localhost:1234/v1/chat/completions",
          },
        },
        agents = {
          {
            provider = "openai",
            name = "ChatGrok",
            chat = true,
            command = false,
            -- string with model name or table with model name and parameters
            model = { model = "grok-2-1212", temperature = 0.8, top_p = 1 },
            -- system prompt (use this to specify the persona/role of the AI)
            system_prompt = require("gp.defaults").chat_system_prompt,
          },
          {
            provider = "openai",
            name = "CodeGrok",
            chat = false,
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
            model = { model = "claude-3-5-sonnet-20241022", temperature = 0.8, top_p = 1 },
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
            chat = false,
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
            model = { model = "gemini-1.5-flash", temperature = 1.1, top_p = 1 },
            -- system prompt (use this to specify the persona/role of the AI)
            system_prompt = require("gp.defaults").chat_system_prompt,
          },
          {
            provider = "openai",
            name = "CodeGemini",
            chat = false,
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
            model = { model = "gpt-4o", temperature = 1.1, top_p = 1 },
            -- system prompt (use this to specify the persona/role of the AI)
            system_prompt = require("gp.defaults").chat_system_prompt,
          },
          {
            provider = "openai",
            name = "CodeGPT4o",
            chat = false,
            command = true,
            -- string with model name or table with model name and parameters
            model = { model = "gpt-4o", temperature = 0.8, top_p = 1 },
            -- system prompt (use this to specify the persona/role of the AI)
            system_prompt = require("gp.defaults").code_system_prompt,
          },
          {
            provider = "openai",
            name = "CodeGPT4o-mini",
            chat = false,
            command = true,
            -- string with model name or table with model name and parameters
            model = { model = "gpt-4o-mini", temperature = 0.8, top_p = 1 },
            -- system prompt (use this to specify the persona/role of the AI)
            system_prompt = require("gp.defaults").code_system_prompt,
          },
          {
            provider = "lmstudio",
            name = "CodeQwen",
            chat = false,
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
            model = { model = "gpt-4o-mini", temperature = 1.1, top_p = 1 },
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
        hooks = {
          -- example of adding command which opens new chat dedicated for translation
          Translator = function(gp, params)
            local chat_system_prompt = "You are a Translator, please translate between English and Chinese."
            gp.cmd.ChatNew(params, chat_system_prompt)

            -- -- you can also create a chat with a specific fixed agent like this:
            -- local agent = gp.get_chat_agent("ChatGPT4o")
            -- gp.cmd.ChatNew(params, chat_system_prompt, agent)
          end,
        },
      }
      local pickers = require "telescope.pickers"
      local finders = require "telescope.finders"
      local actions = require "telescope.actions"
      local action_state = require "telescope.actions.state"
      local conf = require("telescope.config").values

      local models = function(opts)
        local buf = vim.api.nvim_get_current_buf()
        local file_name = vim.api.nvim_buf_get_name(buf)
        local is_chat = require("gp").not_chat(buf, file_name) == nil

        opts = opts or {}
        pickers
          .new(opts, {
            prompt_title = "Models",
            finder = finders.new_table {
              results = is_chat and require("gp")._chat_agents or require("gp")._command_agents,
            },
            sorter = conf.generic_sorter(opts),
            attach_mappings = function(prompt_bufnr)
              actions.select_default:replace(function()
                local selection = action_state.get_selected_entry()
                actions.close(prompt_bufnr)
                require("gp").cmd.Agent { args = selection[1] }
              end)
              return true
            end,
          })
          :find()
      end
      vim.keymap.set(
        "n",
        "<C-g>z",
        function()
          models(require("telescope.themes").get_dropdown {
            winblend = 10,
            previewer = false,
          })
        end,
        {
          noremap = true,
          silent = false,
          nowait = true,
          desc = "GPT prompt Choose Agent",
        }
      )
    end,
  },
  {
    "ziboh/fittencode.nvim",
    init = function() vim.g.enabled_fittencode = false end,
    enabled = false,
    config = function()
      require("fittencode").setup {
        completion_mode = "source",
      }
      if not vim.g.enabled_fittencode then require("fittencode").enable_completions { enable = false } end
    end,
    lazy = true,
  },
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    config = function() require("copilot").setup {} end,
  },
}
