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
  },
  {
    "ziboh/gp.nvim",
    config = function()
      local trans_win
      local chat_system_prompt_cn = require("gp.defaults").chat_system_prompt
        .. "You need to answer the question in Chinese.\n"
      local ollama_endpoint = os.getenv("WSL_DISTRO_NAME")
          and "http://" .. vim.env.WSL_ROUTER_IP .. ":11434/v1/chat/completions"
        or "http://localhost:11434/v1/chat/completions"
      require("gp").setup({
        chat_dir = vim.env.GP_DIR == nil and vim.fn.stdpath("data"):gsub("/$", "") .. "/gp/chats"
          or vim.env.GP_DIR .. "/chats",
        log_dir = vim.env.GP_DIR == nil and vim.fn.stdpath("data"):gsub("/$", "") .. "/gp/gp.nvim.log"
          or vim.env.GP_DIR .. "/gp.nvim.log",
        static_dir = vim.env.GP_DIR == nil and vim.fn.stdpath("data"):gsub("/$", "") .. "/gp/persisted"
          or vim.env.GP_DIR .. "/persisted",
        chat_free_cursor = true,
        providers = {
          openai = {
            endpoint = os.getenv("ONEAPI_URL") .. "/v1/chat/completions",
            secret = os.getenv("ONEAPI_API_KEY"),
          },
          ollama = {
            endpoint = ollama_endpoint,
          },
        },
        agents = {
          {
            provider = "openai",
            name = "ChatDoubao",
            chat = true,
            command = false,
            model = { model = "doubao-pro-256k", temperature = 1, top_p = 1 },
            system_prompt = require("gp.defaults").chat_system_prompt,
          },
          {
            provider = "openai",
            name = "CodeDoubao",
            chat = true,
            command = true,
            model = { model = "doubao-pro-256k", temperature = 0.8, top_p = 1 },
            system_prompt = require("gp.defaults").code_system_prompt,
          },
          {
            provider = "openai",
            name = "ChatDeepseek",
            chat = true,
            command = false,
            model = { model = "deepseek-chat", temperature = 1, top_p = 1 },
            system_prompt = require("gp.defaults").chat_system_prompt,
          },
          {
            provider = "openai",
            name = "ChatDeepseekR1",
            chat = true,
            command = false,
            model = { model = "deepseek-r1", temperature = 1, top_p = 1 },
            system_prompt = require("gp.defaults").chat_system_prompt,
          },
          {
            provider = "openai",
            name = "CodeDeepseek",
            chat = true,
            command = true,
            model = { model = "deepseek-chat", temperature = 0.8, top_p = 1 },
            system_prompt = require("gp.defaults").code_system_prompt,
          },
          {
            provider = "openai",
            name = "ChatGrok",
            chat = true,
            command = false,
            model = { model = "grok-2" },
            system_prompt = chat_system_prompt_cn,
          },
          {
            provider = "openai",
            name = "ChatGrok3",
            chat = true,
            command = false,
            model = { model = "grok-3" },
            system_prompt = chat_system_prompt_cn,
          },
          {
            provider = "openai",
            name = "CodeGrok",
            chat = true,
            command = true,
            model = { model = "grok-2" },
            system_prompt = require("gp.defaults").code_system_prompt,
          },
          {
            provider = "openai",
            name = "CodeGrok",
            chat = true,
            command = true,
            model = { model = "grok-3" },
            system_prompt = require("gp.defaults").code_system_prompt,
          },
          {
            provider = "openai",
            name = "ChatClaude-3-5-Sonnet",
            chat = true,
            command = false,
            model = { model = "claude-3-5-sonnet-20241022", temperature = 1, top_p = 1 },
            system_prompt = require("gp.defaults").chat_system_prompt,
          },
          {
            provider = "openai",
            name = "CodeClaude-3-5-Sonnet",
            chat = true,
            command = true,
            model = { model = "claude-3-5-sonnet-20241022", temperature = 0.8, top_p = 1 },
            system_prompt = require("gp.defaults").code_system_prompt,
          },
          {
            provider = "openai",
            name = "ChatGemini",
            chat = true,
            command = false,
            model = { model = "gemini-2.0-flash", temperature = 1, top_p = 1 },
            system_prompt = chat_system_prompt_cn,
          },
          {
            provider = "openai",
            name = "CodeGemini",
            chat = true,
            command = true,
            model = { model = "gemini-2.0-flash", temperature = 0.8, top_p = 1 },
            system_prompt = require("gp.defaults").code_system_prompt,
          },
          {
            provider = "openai",
            name = "ChatGPT4o",
            chat = true,
            command = false,
            model = { model = "gpt-4o", temperature = 1, top_p = 1 },
            system_prompt = chat_system_prompt_cn,
          },
          {
            provider = "openai",
            name = "CodeGPT4o",
            chat = true,
            command = true,
            model = { model = "gpt-4o", temperature = 0.8, top_p = 1 },
            system_prompt = require("gp.defaults").code_system_prompt,
          },
          {
            provider = "openai",
            name = "CodeGPT4o-mini",
            chat = true,
            command = true,
            model = { model = "gpt-4o-mini", temperature = 0.8, top_p = 1 },
            system_prompt = require("gp.defaults").code_system_prompt,
          },
          {
            provider = "ollama",
            name = "CodeQwen",
            chat = true,
            command = true,
            model = {
              model = "qwen2.5-coder:7b",
              temperature = 0.8,
              top_p = 1,
              num_ctx = 8192,
            },
            system_prompt = require("gp.defaults").code_system_prompt,
          },
          {
            provider = "ollama",
            name = "ChatQwen",
            chat = true,
            command = false,
            model = {
              model = "qwen2.5-coder:7b",
              temperature = 0.97,
              top_p = 1,
              num_ctx = 8192,
            },
            system_prompt = require("gp.defaults").chat_system_prompt,
          },
          {
            provider = "openai",
            name = "ChatGPT4o-mini",
            chat = true,
            command = false,
            model = { model = "gpt-4o-mini", temperature = 1, top_p = 1 },
            system_prompt = require("gp.defaults").chat_system_prompt,
          },
          {
            name = "ChatClaude-3-Haiku",
            disable = true,
          },
          {
            name = "CodeClaude-3-Haiku",
            disable = true,
          },
          {
            name = "ChatOllamaLlama3.1-8B",
            disable = true,
          },
        },
        template_selection = "我有来自 {{filename}} 文件中的内容如下:"
          .. "\n\n```{{filetype}}\n{{selection}}\n```\n\n{{command}}",
        chat_template = "# topic: ?\n\n"
          .. "- file: {{filename}}\n"
          .. "{{optional_headers}}\n"
          .. "在 {{user_prefix}} 后输入您的问题。使用 `{{respond_shortcut}}` 或 :{{cmd_prefix}}ChatRespond 生成请求。\n"
          .. "可以通过使用 `{{stop_shortcut}}` 或 :{{cmd_prefix}}ChatStop 命令来终止响应。\n"
          .. "聊天内容会自动保存。要删除此聊天，请使用 `{{delete_shortcut}}` 或 :{{cmd_prefix}}ChatDelete。\n"
          .. "请注意非常长的聊天。使用 `{{new_shortcut}}` 或 :{{cmd_prefix}}ChatNew 开始一个新的聊天。\n\n"
          .. "---\n\n"
          .. "{{user_prefix}}\n",
        hooks = {
          -- example of adding command which opens new chat dedicated for translation
          Explain = function(gp, params)
            local template = "I have the following code from {{filename}}:\n\n"
              .. "```{{filetype}}\n{{selection}}\n```\n\n"
              .. "Please respond by explaining the code above."
            local agent = gp.get_chat_agent()
            gp.Prompt(params, gp.Target.popup, agent, template)
          end,
          SelectAgent = function(gp)
            local get_agent = function()
              local buf = vim.api.nvim_get_current_buf()
              local file_name = vim.api.nvim_buf_get_name(buf)
              local is_chat = gp.not_chat(buf, file_name) == nil
              return is_chat and gp._chat_agents or gp._command_agents
            end
            local agents = get_agent()
            local all_agents = gp.agents
            local items = vim.tbl_map(function(value)
              return {
                text = value,
                preview = {
                  text = vim.inspect(all_agents[value]),
                  ft = "lua",
                  title = value,
                },
              }
            end, agents)
            Snacks.picker({
              items = items,
              format = "text",
              title = "Select Agent",
              preview = function(ctx)
                ctx.preview:reset()
                local lines = vim.split(ctx.item.preview.text, "\n")
                ctx.preview:set_lines(lines)
                ctx.preview:highlight({ ft = ctx.item.preview.ft })
                ctx.preview:wo({
                  signcolumn = "no",
                  number = false,
                })
                ctx.preview:set_title(ctx.item.preview.title)
              end,
              confirm = function(picker, item)
                picker:close()
                vim.cmd("GpAgent " .. item.text)
              end,
            })
          end,
          ChatFinder = function(gp)
            Snacks.picker("grep", {
              cwd = gp.config.chat_dir,
              args = { "--sort", "path", "--sortr", "path" },
              layout = { preset = "max" },
              title = "Find Gp Chat",
              actions = {
                open_popup = function(picker, item)
                  picker:close()
                  Snacks.win({
                    file = item._path,
                    width = 100,
                    height = 30,
                    bo = {
                      buftype = "",
                      buflisted = false,
                      bufhidden = "hide",
                      swapfile = false,
                      modifiable = true,
                    },
                    minimal = false,
                    noautocmd = false,
                    zindex = 20,
                    wo = {
                      winhighlight = "NormalFloat:Normal",
                    },
                    border = "rounded",
                    title_pos = "center",
                    footer_pos = "center",
                  })
                  -- HACK: this should fix folds
                  if vim.wo.foldmethod == "expr" then
                    vim.schedule(function()
                      vim.opt.foldmethod = "expr"
                    end)
                  end
                end,
                open_vsplit = function(picker, item)
                  picker:close()
                  Snacks.win({
                    file = item._path,
                    position = "right",
                    width = 0.5,
                    minimal = false,
                    wo = {
                      winhighlight = "NormalFloat:Normal",
                    },
                    bo = {
                      modifiable = true,
                    },
                  })

                  -- HACK: this should fix folds
                  if vim.wo.foldmethod == "expr" then
                    vim.schedule(function()
                      vim.opt.foldmethod = "expr"
                    end)
                  end
                end,
              },
              layouts = {
                max = {
                  fullscreen = true,
                  preset = "default",
                },
              },
              win = {
                input = {
                  keys = {
                    ["<c-d>"] = { "delect_file", mode = { "n", "i" } },
                    ["<c-f>"] = { "open_popup", mode = { "n", "i" } },
                    ["<c-v>"] = { "vsplit", mode = { "n", "i" } },
                    ["<c-s>"] = { "split", mode = { "n", "i" } },
                    ["<c-t>"] = { "tab", mode = { "n", "i" } },
                  },
                },
                list = {
                  keys = {
                    ["<c-d>"] = "delect_file",
                    ["<c-f>"] = "open_popup",
                    ["<c-v>"] = "vsplit",
                    ["<c-s>"] = "split",
                    ["<c-t>"] = "tab",
                  },
                },
              },
              search = function()
                return "^# topic: "
              end,
            })
          end,
          Translator = function(gp)
            local mode = vim.fn.mode()
            if trans_win ~= nil and trans_win:win_valid() then
              trans_win:focus()
              return
            end
            if not (mode == "v" or mode == "V") then
              return
            end
            local buf = vim.api.nvim_create_buf(false, true)
            local messages = {}
            local sys_prompt =
              "You are a professional translation engine, please translate the text into a colloquial, professional, elegant and fluent content, without the style of machine translation.You must only translate the text content, never interpret it. Don't have any extra symbols.There's no need to use ``` to enclose the result."

            local text = Utils.GetVisualSelection()
            local lang = Utils.detect_language(text) == "Chinese" and "English" or "Chinese"
            table.insert(messages, { role = "system", content = sys_prompt })
            local user_prompt = "Translate into " .. lang .. ":\n" .. '"""\n' .. text .. '\n"""'
            table.insert(messages, { role = "user", content = user_prompt })

            trans_win = Snacks.win({
              relative = "cursor",
              buf = buf,
              width = 80,
              height = 8,
              col = 1,
              row = 1,
              title = "Translator",
              title_pos = "center",
              enter = false,
              backdrop = false,
              border = "rounded",
              wo = {
                wrap = true,
              },
              bo = {
                filetype = "markdown",
              },
            })
            local agent = gp.get_chat_agent("CodeQwen")
            vim.schedule(function()
              local handler = gp.dispatcher.create_handler(buf, trans_win.win, 0, true, "", false, false)
              local on_exit = function()
                vim.api.nvim_create_autocmd("CursorMoved", {
                  group = vim.api.nvim_create_augroup("MyGroup", { clear = true }),
                  callback = function()
                    if trans_win:win_valid() and vim.api.nvim_get_current_win() ~= trans_win.win then
                      trans_win:close()
                      vim.api.nvim_del_augroup_by_name("MyGroup")
                    elseif not trans_win:win_valid() then
                      vim.api.nvim_del_augroup_by_name("MyGroup")
                    end
                  end,
                })
              end

              gp.dispatcher.query(
                buf,
                agent.provider,
                gp.dispatcher.prepare_payload(messages, agent.model, agent.provider),
                handler,
                vim.schedule_wrap(function()
                  on_exit()
                  vim.cmd("doautocmd User GpDone")
                end),
                nil
              )
            end)
          end,
          GitCommit = function(gp)
            if vim.bo.filetype ~= "gitcommit" then
              return
            end
            local buf = vim.api.nvim_get_current_buf()
            local agent = gp.get_chat_agent()
            vim.schedule(function()
              local on_exit = function() end
              local messages = {}
              local commit_prompt_template = [[
You are an expert at following the Conventional Commit specification. Given the git diff listed below, please generate a commit message for me:
      1. First line: conventional commit format (type: concise description) (remember to use semantic types like feat, fix, docs, style, refactor, perf, test, chore, etc.)
      2. Optional bullet points if more context helps:
        - Keep the second line blank
        - Keep them short and direct
        - Focus on what changed
        - Always be terse
        - Don't overly explain
        - Drop any fluffy or formal language

      Return ONLY the commit message - no introduction, no explanation, no quotes around it.

      Examples:
      feat: add user auth system

      - Add JWT tokens for API auth
      - Handle token refresh for long sessions

      fix: resolve memory leak in worker pool

      - Clean up idle connections
      - Add timeout for stale workers

      Simple change example:
      fix: typo in README.md

      Very important: Do not respond with any of the examples. Your message must be based off the diff that is about to be provided, with a little bit of styling informed by the recent commits you're about to see.

      Based on this format, generate appropriate commit messages. Respond with message only. DO NOT format the message in Markdown code blocks, DO NOT use backticks:

      ```diff
	  {{git_diff}}
      ```
      ]]
              local user_prompt = gp.render.template(commit_prompt_template, {
                ["{{git_diff}}"] = vim.fn.system("git diff --no-ext-diff --staged"),
              })

              table.insert(messages, { role = "user", content = user_prompt })

              vim.api.nvim_buf_set_lines(buf, 0, -1, false, {})
              local handler = gp.dispatcher.create_handler(buf, 0, 0, true, "", false, false)
              gp.dispatcher.query(
                buf,
                agent.provider,
                gp.dispatcher.prepare_payload(messages, agent.model, agent.provider),
                handler,
                vim.schedule_wrap(function()
                  on_exit()
                  vim.cmd("doautocmd User GpDone")
                end),
                nil
              )
            end)
          end,
        },
      })
    end,
    keys = {
      { "<leader>ts", "<cmd>GpTranslator<cr>", desc = "Translate", mode = { "n", "v" } },
      { "<leader>tc", "<cmd>GpGitCommit<cr>", desc = "Git commits", mode = { "n", "v" } },
      { "<C-g>z", "<cmd>GpSelectAgent<cr>", desc = "GPT prompt Choose Agent" },
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
