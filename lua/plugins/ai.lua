return {
  "robitx/gp.nvim",
  config = function()
    require("gp").setup {
      -- Please start with minimal config possible.
      -- Just openai_api_key if you don't have OPENAI_API_KEY env set up.
      -- Defaults change over time to improve things, options might get deprecated.
      -- It's better to change only things where the default doesn't fit your needs.

      -- required openai api key (string or table with command and arguments)
      -- openai_api_key = { "cat", "path_to/openai_api_key" },
      -- openai_api_key = { "bw", "get", "password", "OPENAI_API_KEY" },
      -- openai_api_key: "sk-...",
      -- openai_api_key = os.getenv("env_name.."),
      openai_api_key = os.getenv "OPENAI_API_KEY",
      -- api endpoint (you can change this to azure endpoint)
      openai_api_endpoint = "https://35.yunai.xyz/v1/chat/completions",
      -- openai_api_endpoint = "https://$URL.openai.azure.com/openai/deployments/{{model}}/chat/completions?api-version=2023-03-15-preview",
      -- prefix for all commands
      cmd_prefix = "Gp",
      -- optional curl parameters (for proxy, etc.)
      -- curl_params = { "--proxy", "http://X.X.X.X:XXXX" }
      curl_params = {},

      -- directory for persisting state dynamically changed by user (like model or persona)
      state_dir = vim.fn.stdpath("data"):gsub("/$", "") .. "/gp/persisted",

      -- default command agents (model + persona)
      -- name, model and system_prompt are mandatory fields
      -- to use agent for chat set chat = true, for command set command = true
      -- to remove some default agent completely set it just with the name like:
      -- agents = {  { name = "ChatGPT4" }, ... },
      agents = {
        {
          name = "ChatGPT4",
          chat = true,
          command = false,
          -- string with model name or table with model name and parameters
          model = { model = "gpt-4-1106-preview", temperature = 1.1, top_p = 1 },
          -- system prompt (use this to specify the persona/role of the AI)
          system_prompt = "You are a general AI assistant.\n\n"
            .. "The user provided the additional info about how they would like you to respond:\n\n"
            .. "- If you're unsure don't guess and say you don't know instead.\n"
            .. "- Ask question if you need clarification to provide better answer.\n"
            .. "- Think deeply and carefully from first principles step by step.\n"
            .. "- Zoom out first to see the big picture and then zoom in to details.\n"
            .. "- Use Socratic method to improve your thinking and coding skills.\n"
            .. "- Don't elide any code from your output if the answer requires coding.\n"
            .. "- Take a deep breath; You've got this!\n",
        },
        {
          name = "ChatGPT3-5",
          chat = true,
          command = false,
          -- string with model name or table with model name and parameters
          model = { model = "gpt-3.5-turbo-1106", temperature = 1.1, top_p = 1 },
          -- system prompt (use this to specify the persona/role of the AI)
          system_prompt = "You are a general AI assistant.\n\n"
            .. "The user provided the additional info about how they would like you to respond:\n\n"
            .. "- If you're unsure don't guess and say you don't know instead.\n"
            .. "- Ask question if you need clarification to provide better answer.\n"
            .. "- Think deeply and carefully from first principles step by step.\n"
            .. "- Zoom out first to see the big picture and then zoom in to details.\n"
            .. "- Use Socratic method to improve your thinking and coding skills.\n"
            .. "- Don't elide any code from your output if the answer requires coding.\n"
            .. "- Take a deep breath; You've got this!\n",
        },
        {
          name = "CodeGPT4",
          chat = false,
          command = true,
          -- string with model name or table with model name and parameters
          model = { model = "gpt-4-1106-preview", temperature = 0.8, top_p = 1 },
          -- system prompt (use this to specify the persona/role of the AI)
          system_prompt = "You are an AI working as a code editor.\n\n"
            .. "Please AVOID COMMENTARY OUTSIDE OF THE SNIPPET RESPONSE.\n"
            .. "START AND END YOUR ANSWER WITH:\n\n```",
        },
        {
          name = "CodeGPT3-5",
          chat = false,
          command = true,
          -- string with model name or table with model name and parameters
          model = { model = "gpt-3.5-turbo-1106", temperature = 0.8, top_p = 1 },
          -- system prompt (use this to specify the persona/role of the AI)
          system_prompt = "You are an AI working as a code editor.\n\n"
            .. "Please AVOID COMMENTARY OUTSIDE OF THE SNIPPET RESPONSE.\n"
            .. "START AND END YOUR ANSWER WITH:\n\n```",
        },
      },

      -- directory for storing chat files
      chat_dir = vim.fn.stdpath("data"):gsub("/$", "") .. "/gp/chats",
      -- chat user prompt prefix
      chat_user_prefix = "🗨:",
      -- chat assistant prompt prefix (static string or a table {static, template})
      -- first string has to be static, second string can contain template {{agent}}
      -- just a static string is legacy and the [{{agent}}] element is added automatically
      -- if you really want just a static string, make it a table with one element { "🤖:" }
      chat_assistant_prefix = { "🤖:", "[{{agent}}]" },
      -- chat topic generation prompt
      chat_topic_gen_prompt = "Summarize the topic of our conversation above"
        .. " in two or three words. Respond only with those words.",
      -- chat topic model (string with model name or table with model name and parameters)
      chat_topic_gen_model = "gpt-3.5-turbo-16k",
      -- explicitly confirm deletion of a chat file
      chat_confirm_delete = true,
      -- conceal model parameters in chat
      chat_conceal_model_params = true,
      -- local shortcuts bound to the chat buffer
      -- (be careful to choose something which will work across specified modes)
      chat_shortcut_respond = { modes = { "n", "i", "v", "x" }, shortcut = "<C-g><C-g>" },
      chat_shortcut_delete = { modes = { "n", "i", "v", "x" }, shortcut = "<C-g>d" },
      chat_shortcut_stop = { modes = { "n", "i", "v", "x" }, shortcut = "<C-g>s" },
      chat_shortcut_new = { modes = { "n", "i", "v", "x" }, shortcut = "<C-g>c" },
      -- default search term when using :GpChatFinder
      chat_finder_pattern = "topic ",
      -- if true, finished ChatResponder won't move the cursor to the end of the buffer
      chat_free_cursor = false,

      -- how to display GpChatToggle or GpContext: popup / split / vsplit / tabnew
      toggle_target = "vsplit",

      -- styling for chatfinder
      -- border can be "single", "double", "rounded", "solid", "shadow", "none"
      style_chat_finder_border = "single",
      -- margins are number of characters or lines
      style_chat_finder_margin_bottom = 8,
      style_chat_finder_margin_left = 1,
      style_chat_finder_margin_right = 2,
      style_chat_finder_margin_top = 2,
      -- how wide should the preview be, number between 0.0 and 1.0
      style_chat_finder_preview_ratio = 0.5,

      -- styling for popup
      -- border can be "single", "double", "rounded", "solid", "shadow", "none"
      style_popup_border = "single",
      -- margins are number of characters or lines
      style_popup_margin_bottom = 8,
      style_popup_margin_left = 1,
      style_popup_margin_right = 2,
      style_popup_margin_top = 2,
      style_popup_max_width = 160,

      -- command config and templates bellow are used by commands like GpRewrite, GpEnew, etc.
      -- command prompt prefix for asking user for input (supports {{agent}} template variable)
      command_prompt_prefix_template = "🤖 {{agent}} ~ ",
      -- auto select command response (easier chaining of commands)
      -- if false it also frees up the buffer cursor for further editing elsewhere
      command_auto_select_response = true,

      -- templates
      -- .. "\n\n```{{filetype}}\n{{selection}}\n```\n\n{{command}}",
      template_selection = "我有来自 {{filename}}的文件中的代码片段:"
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
        Translator = function(gp, params)
          local agent = gp.get_command_agent()
          local chat_system_prompt = "You are a Translator, please translate between English and Chinese."
          gp.cmd.ChatNew(params, agent.model, chat_system_prompt)
        end,
        -- Translator = function(gp, params)
        --   local agent = gp.get_command_agent()
        --   local chat_system_prompt =
        --     "Translate the following source text to Chinese, Output translation directly without any additional text.\nSource Text: {{selection}}\nTranslated Text:"
        --   gp.cmd.ChatNew(params, agent.model, chat_system_prompt)
        -- end,
      },
    }
  end,
}
