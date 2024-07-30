return {
  "Robitx/gp.nvim",
  event = "VeryLazy",
  config = function()
    require("gp").setup {
      providers = {
        openai = {
          endpoint = os.getenv "OPENAI_ENDPOINT",
          secret = os.getenv "OPENAI_API_KEY",
        },
      },
      agents = {
        {
          name = "ChatGPT3-5",
          disable = true,
        },
        {
          name = "ChatGPT4o",
          disable = true,
        },
        {
          name = "CodeGPT3-5",
          disable = true,
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
}
