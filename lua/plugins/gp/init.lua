return {
  "ziboh/gp.nvim",
  config = function()
    local trans_win
    local prompt = require("plugins.gp.prompt")
    local chat_system_prompt_cn = require("gp.defaults").chat_system_prompt
      .. "You need to answer the question in Chinese.\n"
    require("gp").setup({
      chat_dir = vim.env.GP_DIR == nil and vim.fn.stdpath("data"):gsub("/$", "") .. "/gp/chats"
        or vim.env.GP_DIR .. "/chats",
      log_dir = vim.env.GP_DIR == nil and vim.fn.stdpath("data"):gsub("/$", "") .. "/gp/gp.nvim.log"
        or vim.env.GP_DIR .. "/gp.nvim.log",
      state_dir = vim.env.GP_DIR == nil and vim.fn.stdpath("data"):gsub("/$", "") .. "/gp/persisted"
        or vim.env.GP_DIR .. "/persisted",
      chat_free_cursor = true,
      openai_api_key = false,
      providers = {
        openai = {
          endpoint = os.getenv("AIPROXY_URL") .. "/v1/chat/completions",
          secret = os.getenv("AIPROXY_API_KEY"),
        },
      },
      -- You can provide state preservation for agents with customized commands.
      custom_state = { "translate", "gitcommit" },

      agents = {
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
          name = "ChatGLM-4-5-Flash",
          chat = true,
          command = false,
          model = { model = "glm-4.5-flash", temperature = 1, top_p = 1 },
          system_prompt = require("gp.defaults").chat_system_prompt,
        },
        {
          provider = "openai",
          name = "CodeGLM-4-5-Flash",
          chat = false,
          command = true,
          model = { model = "glm-4.5-flash", temperature = 0.8, top_p = 1 },
          system_prompt = require("gp.defaults").code_system_prompt,
        },
        {
          provider = "openai",
          name = "ChatDeepseekThink",
          chat = true,
          command = false,
          model = { model = "deepseek-reasoner", temperature = 1, top_p = 1 },
          system_prompt = require("gp.defaults").chat_system_prompt,
        },
        {
          provider = "openai",
          name = "CodeDeepseek",
          chat = false,
          command = true,
          model = { model = "deepseek-chat", temperature = 0.8, top_p = 1 },
          system_prompt = require("gp.defaults").code_system_prompt,
        },
        {
          provider = "openai",
          name = "ChatClaude-Haiku-4-5",
          chat = true,
          command = false,
          model = { model = "claude-haiku-4-5", temperature = 1, top_p = 1 },
          system_prompt = require("gp.defaults").chat_system_prompt,
        },
        {
          provider = "openai",
          name = "CodeClaude-3-5-Sonnet",
          chat = false,
          command = true,
          model = { model = "claude-3-5-sonnet-20241022", temperature = 0.8, top_p = 1 },
          system_prompt = require("gp.defaults").code_system_prompt,
        },
        {
          provider = "openai",
          name = "ChatGemini",
          chat = true,
          command = false,
          model = { model = "gemini-2.5-flash", temperature = 1, top_p = 1 },
          system_prompt = chat_system_prompt_cn,
        },
        {
          provider = "openai",
          name = "CodeGemini",
          chat = false,
          command = true,
          model = { model = "gemini-2.5-flash", temperature = 0.8, top_p = 1 },
          system_prompt = require("gp.defaults").code_system_prompt,
        },
        {
          provider = "openai",
          name = "ChatGeminiPro",
          chat = true,
          command = false,
          model = { model = "gemini-2.5-pro", temperature = 1, top_p = 1 },
          system_prompt = chat_system_prompt_cn,
        },
        {
          provider = "openai",
          name = "CodeGeminiPro",
          chat = false,
          command = true,
          model = { model = "gemini-2.5-pro", temperature = 0.8, top_p = 1 },
          system_prompt = require("gp.defaults").code_system_prompt,
        },
        {
          provider = "openai",
          name = "ChatGPT5-Mini",
          chat = true,
          command = false,
          model = { model = "gpt-5-mini", temperature = 1, top_p = 1 },
          system_prompt = chat_system_prompt_cn,
        },
        {
          provider = "openai",
          name = "CodeGPT5-Mini",
          chat = false,
          command = true,
          model = { model = "gpt-5-mini", temperature = 0.8, top_p = 1 },
          system_prompt = require("gp.defaults").code_system_prompt,
        },
        {
          provider = "openai",
          name = "CodeGPT5-Nano",
          chat = false,
          command = true,
          model = { model = "gpt-5-nano", temperature = 0.8, top_p = 1 },
          system_prompt = require("gp.defaults").code_system_prompt,
        },
        {
          provider = "openai",
          name = "ChatGPT5-Nano",
          chat = true,
          command = false,
          model = { model = "gpt-5-nano", temperature = 1, top_p = 1 },
          system_prompt = require("gp.defaults").chat_system_prompt,
        },
        {
          name = "ChatGPT4o",
          disable = true,
        },
        {
          name = "ChatGPT4o-mini",
          disable = true,
        },
        {
          name = "CodeGPT4o-mini",
          disable = true,
        },
        {
          name = "CodeClaude-3-5-Sonnet",
          disable = true,
        },
        {
          name = "CodeGPT4o",
          disable = true,
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
        {
          name = "CodeOllamaLlama3.1-8B",
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
        SetAgent = function(gp, params)
          local state
          local bang = params.bang
          if params.fargs[1] ~= nil then
            state = params.fargs[1]
          end
          local custom_state = vim.deepcopy(gp.opts.custom_state or gp.config.custom_state)
          vim.list_extend(custom_state, { "chat_agent", "command_agent" })
          local all_agents = gp.agents
          local all_agents_name = vim.tbl_keys(all_agents)
          local picker_agent_state = function(state)
            local select_agent_items = all_agents_name
            if state == "chat_agent" then
              select_agent_items = gp._chat_agents
            elseif state == "command_agent" then
              select_agent_items = gp._command_agents
            end
            local items = vim.tbl_map(function(value)
              return {
                text = value,
                preview = {
                  text = vim.inspect(all_agents[value]),
                  ft = "lua",
                  title = value,
                },
              }
            end, select_agent_items)
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
                gp.set_agent_state(state, item.text)
              end,
            })
          end
          if state == nil and not bang then
            local buf = vim.api.nvim_get_current_buf()
            local file_name = vim.api.nvim_buf_get_name(buf)
            local is_chat = gp.not_chat(buf, file_name) == nil
            if is_chat then
              picker_agent_state("chat_agent")
            else
              picker_agent_state("command_agent")
            end
          elseif bang then
            local items = vim.tbl_map(function(value)
              return {
                text = value,
                preview = {
                  text = vim.inspect(gp.get_agent_from_state(value)),
                  ft = "lua",
                  title = value,
                },
              }
            end, custom_state)
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
                vim.schedule(function()
                  picker_agent_state(item.text)
                end)
              end,
            })
          else
            picker_agent_state(state)
          end
        end,
        ChatFinder = function(gp)
          Snacks.picker("grep", {
            cwd = gp.config.chat_dir,
            args = { "--sort", "path", "--sortr", "path" },
            layout = { preset = "max" },
            title = "Find Gp Chat",
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
                  ["<c-f>"] = { "edit_popup", mode = { "n", "i" } },
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
          local translate_prompt = prompt.translate_prompt

          local text = Utils.GetVisualSelection()
          local lang = Utils.detect_language(text) == "Chinese" and "English" or "Chinese"
          table.insert(messages, { role = "system", content = translate_prompt })
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
          local agent = gp.get_agent_from_state("translate")
          vim.schedule(function()
            local handler = gp.dispatcher.create_handler(buf, trans_win.win, 0, true, "", false, false)
            local on_exit = function()
              vim.api.nvim_create_autocmd("CursorMoved", {
                group = vim.api.nvim_create_augroup("Translator", { clear = true }),
                callback = function()
                  if trans_win:win_valid() and vim.api.nvim_get_current_win() ~= trans_win.win then
                    trans_win:close()
                    vim.api.nvim_del_augroup_by_name("Translator")
                  elseif not trans_win:win_valid() then
                    vim.api.nvim_del_augroup_by_name("Translator")
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
          local buf
          local win
          if vim.bo.filetype ~= "gitcommit" then
            buf = vim.api.nvim_create_buf(false, true)
            win = Snacks.win({
              show = false,
              width = 0.4,
              buf = buf,
              height = 0.4,
              border = "rounded",
              wo = {
                spell = false,
                wrap = false,
                signcolumn = "yes",
                statuscolumn = " ",
                conceallevel = 3,
              },
              footer_keys = true, -- 启用底部快捷键提示
              footer_pos = "center", -- 底部提示居中显示
              keys = { -- 定义快捷键
                ["q"] = "close",
                ["<Esc>"] = "close",
                ["<Enter>"] = "提交",
              },
            })
            vim.bo[buf].filetype = "gitcommit"
          else
            buf = vim.api.nvim_get_current_buf()
          end
          local agent = gp.get_agent_from_state("gitcommit")
          vim.schedule(function()
            local on_exit = function() end
            local messages = {}
            local commit_prompt_template = prompt.commit_prompt_template
            local git_diff_msg = vim.fn.system("git diff --no-ext-diff --staged")
            if git_diff_msg == "" then
              Snacks.notify.warn("没有新增或修改的文件", { title = "Gp Commit" })
              return
            end
            local user_prompt = gp.render.template(commit_prompt_template, {
              ["{{git_diff}}"] = git_diff_msg,
            })
            table.insert(messages, { role = "user", content = user_prompt })

            vim.api.nvim_buf_set_lines(buf, 0, -1, false, {})

            local handler = gp.dispatcher.create_handler(buf, 0, 0, true, "", false, false)
            if win ~= nil then
              win:show()
              -- 动画状态
              local spinner = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }
              local spinner_idx = 1
              local timer = nil

              -- 启动动画
              local function start_spinner()
                timer = vim.loop.new_timer()
                timer:start(100, 100, function()
                  vim.schedule(function()
                    if win and win:valid() then
                      local title = " " .. spinner[spinner_idx] .. " 生成 commit 消息"
                      spinner_idx = (spinner_idx % #spinner) + 1
                      win:set_title(title)
                    end
                  end)
                end)
              end

              -- 停止动画
              local function stop_spinner()
                if timer then
                  timer:close()
                  timer = nil
                  if win and win:valid() then
                    win:set_title(" 生成 commit 消息")
                  end
                end
              end

              win:on("User", function(_, ev)
                if ev.match == "GpDone" then
                  stop_spinner()
                end
              end)

              -- 启动动画
              start_spinner()
              vim.api.nvim_buf_set_keymap(
                0,
                "n",
                "<cr>",
                "<cmd>lua " .. [[Snacks.notify.warn("生成Commit中，请稍等",{ title = "Gp Commit"})<cr>]],
                { desc = "提交更改" }
              )
            end

            gp.dispatcher.query(
              buf,
              agent.provider,
              gp.dispatcher.prepare_payload(messages, agent.model, agent.provider),
              handler,
              vim.schedule_wrap(function()
                on_exit()
                if win == nil then
                  vim.api.nvim_command("w")
                else
                  local git_commit_path = vim.fn.stdpath("data"):gsub("/$", "") .. "/gp/gpcommit.txt"
                  git_commit_path = git_commit_path:gsub("\\", "/")
                  vim.fn.writefile(vim.api.nvim_buf_get_lines(buf, 0, -1, false), git_commit_path, "p")
                  local git_commit = [[vim.fn.system("git commit -F ]] .. git_commit_path .. [[")]]

                  vim.api.nvim_buf_set_keymap(
                    0,
                    "n",
                    "<cr>",
                    "<cmd>lua "
                      .. git_commit
                      .. [[;vim.api.nvim_win_close(0, false);Snacks.notify("已提交更改",{ title = "Gp Commit"})<cr>]],
                    { desc = "提交更改" }
                  )
                end
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
    { "<leader>gc", "<cmd>GpGitCommit<cr>", desc = "Git commits", mode = { "n", "v" } },
    { "<C-g>z", "<cmd>GpSetAgent<cr>", desc = "GPT prompt Choose Agent" },
    { "<C-g>Z", "<cmd>GpSetAgent!<cr>", desc = "Get Agent From State" },
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
  },
}
