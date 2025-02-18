return {
  "rebelot/heirline.nvim",
  dependencies = { { "Zeioth/heirline-components.nvim" } },
  lazy = vim.fn.argc(-1) == 0,
  event = "VeryLazy",
  opts = function()
    local lib = require("heirline-components.all")
    local conditions = require("heirline.conditions")
    local FileInfo = lib.component.file_info()
    local Space = setmetatable({ provider = " " }, {
      __call = function(_, n)
        return { provider = string.rep(" ", n) }
      end,
    })
    local FilePath = {
      provider = function(_)
        local filepath = vim.fn.expand("%:p") -- 获取当前文件的完整路径
        local home = vim.env.HOME -- 获取用户的主目录
        -- 将路径中的主目录替换为 ~
        filepath = filepath:gsub(home, "")
        -- 将路径中的斜杠替换为 >，兼容不同平台
        filepath = filepath:gsub("[\\/]", "  "):gsub("^", "")

        return filepath
      end,
      hl = { fg = "#c099ff" }, -- 设置高亮颜色
    }
    local virtual_env = {
      condition = function()
        return require("utils").has("venv-selector.nvim")
      end,
      provider = function(_)
        local python_path = require("venv-selector").python()
        if python_path == nil then
          return ""
        end

        if Utils.is_win() then
          local venv_name = python_path:match(".*\\([^\\]+)\\.venv\\Scripts\\python.exe$")
          if venv_name == nil then
            venv_name = python_path:match(".*\\([^\\]+)\\python%.exe$")
          end
          if venv_name ~= nil then
            return "   " .. venv_name
          end
        else
          local venv_name = python_path:match(".*/([^/]+)/.venv/bin/python")
          if venv_name == nil then
            venv_name = python_path:match(".*/([^/]+)/bin/python")
          end
          if venv_name ~= nil then
            return "   " .. venv_name
          end
        end
        return "   " .. python_path
      end,
      hl = { fg = "#c099ff" }, -- 设置高亮颜色
      on_click = {
        name = "heirline_virtual_env",
        callback = function()
          if is_available("venv-selector.nvim") then
            vim.schedule(vim.cmd.VenvSelect)
          end
        end,
      },
    }
    local FittenCode = {
      condition = function()
        return require("utils").has("fittencode.nvim")
      end,
      Space(2),
      {
        provider = " Fitten",
        hl = function()
          if vim.g.fittencode_enabled then
            return { fg = "#98bb6c", bold = true }
          else
            return { fg = "#ed8796", bold = true }
          end
        end,
        on_click = {
          name = "heirline_fittencode",
          callback = function()
            require("utils.toggle").fittencode()
          end,
        },
      },
    }
    local SuperMaven = {
      condition = function()
        return require("utils").has("supermaven-nvim")
      end,
      Space(2),
      {
        provider = " SuperMaven",
        hl = function()
          if vim.g.supermaven_enabled then
            return { fg = "#98bb6c", bold = true }
          else
            return { fg = "#ed8796", bold = true }
          end
        end,
        on_click = {
          name = "heirline_supermaven",
          callback = function()
            require("utils.toggle").supermaven()
          end,
        },
      },
    }
    local Rime = {
      condition = function()
        local clients = vim.lsp.get_clients({ bufnr = vim.api.nvim_get_current_buf() })
        for _, client in ipairs(clients) do
          if client.name == "rime_ls" then
            return true
          end
        end
        return false
      end,
      {
        provider = "  ",
      },
      {
        hl = function()
          if vim.g.rime_enabled then
            return { fg = "#98bb6c", bold = true }
          else
            return { fg = "#ed8796", bold = true }
          end
        end,
        on_click = {
          name = "heirline_rime",
          callback = function()
            vim.cmd("RimeToggle")
          end,
        },
        provider = "ㄓRime",
      },
    }
    local FileCode = {
      condition = function()
        return vim.bo.fenc ~= ""
      end,
      Space(2),
      {
        hl = { fg = "#50a4e9", bold = true },
        provider = function()
          local enc = vim.bo.fenc
          if enc == "euc-cn" then
            enc = "gbk"
          end
          return enc ~= "" and enc:upper() .. "[" .. vim.bo.ff:sub(1, 1):upper() .. vim.bo.ff:sub(2) .. "]"
        end,
      },
    }
    local Mode = lib.component.mode({
      hl = {
        fg = "#1a1d23",
        bg = "mode_bg",
        bold = true,
      },
      mode_text = { pad_text = "center" }, -- if set, displays text.
    })
    local LspServer = {
      {
        condition = function(self)
          return #self.lsp_filtered_table > 0
        end,
        Space(2),
      },
      {
        on_click = {
          name = "heirline_lsp_info",
          callback = function()
            vim.cmd("LspInfo")
          end,
        },
        provider = function(self)
          local names = self.lsp_filtered_table
          if #names == 0 then
            names = ""
          else
            names = " [" .. table.concat(names, ", ") .. "]"
            -- names = table.concat(names, ", ")
          end
          return names
        end,
      },
    }
    local Lsp = {
      condition = conditions.lsp_attached,
      init = function(self)
        local names = {}
        self.ignore_lsp = { "rime_ls" }
        local lsp_filtered_table = {}

        for _, server in pairs(vim.lsp.get_clients({ bufnr = 0 })) do
          table.insert(names, server.name)
          if not Utils.value_in_list(server.name, self.ignore_lsp) then
            table.insert(lsp_filtered_table, server.name)
          end
        end

        for _, lint in pairs(require("lint")._resolve_linter_by_ft(vim.bo.filetype)) do
          table.insert(names, lint)
          if not Utils.value_in_list(lint, self.ignore_lsp) then
            table.insert(lsp_filtered_table, lint)
          end
        end

        for _, formatter in pairs(require("conform").list_formatters()) do
          table.insert(names, formatter.name)
          if not Utils.value_in_list(formatter.name, self.ignore_lsp) then
            table.insert(lsp_filtered_table, formatter.name)
          end
        end

        self.lsp_names = names
        self.lsp_filtered_table = lsp_filtered_table
      end,
      update = {
        "LspAttach",
        "LspDetach",
        "BufEnter",
        "VimResized",
        callback = vim.schedule_wrap(function()
          vim.cmd.redrawstatus()
        end),
      },
      hl = { fg = "#98bb6c", bold = true },
      LspServer,
    }
    local Overseer = {
      condition = function()
        local ok, _ = pcall(require, "overseer")
        if ok then
          return true
        end
      end,
      init = function(self)
        self.overseer = require("overseer")
        self.tasks = self.overseer.task_list
        self.STATUS = self.overseer.constants.STATUS
      end,
      static = {
        symbols = {
          ["FAILURE"] = "󰅙 ",
          ["CANCELED"] = " ",
          ["SUCCESS"] = "󰄴 ",
          ["RUNNING"] = "󰑮 ",
        },
        colors = {
          ["FAILURE"] = "red",
          ["CANCELED"] = "gray",
          ["SUCCESS"] = "#c3e88d",
          ["RUNNING"] = "yellow",
        },
      },
      {
        Space(2),
        {
          provider = function(self)
            local tasks_by_status = self.overseer.util.tbl_group_by(self.tasks.list_tasks({ unique = true }), "status")

            if next(tasks_by_status) == nil then
              self.color = "#c3e88d"
              return "󰑮"
            end
            for _, status in ipairs(self.STATUS.values) do
              local status_tasks = tasks_by_status[status]
              if self.symbols[status] and status_tasks then
                self.color = self.colors[status]
                return self.symbols[status]
              end
            end
          end,
          hl = function(self)
            return { fg = self.color }
          end,
          on_click = {
            name = "heirline_overseer",
            callback = function()
              vim.cmd("OverseerToggle")
            end,
          },
        },
      },
    }
    return {
      opts = {
        disable_winbar_cb = function(args) -- We do this to avoid showing it on the greeter.
          local is_disabled = not require("heirline-components.buffer").is_valid(args.buf)
            or lib.condition.buffer_matches({
              buftype = { "terminal", "prompt", "nofile", "help", "quickfix" },
              filetype = { "NvimTree", "neo%-tree", "dashboard", "Outline", "aerial" },
            }, args.buf)
          return is_disabled
        end,
      },
      tabline = { -- UI upper bar
        lib.component.tabline_conditional_padding(),
        lib.component.tabline_buffers(),
        lib.component.fill({ hl = { bg = "tabline_bg" } }),
        lib.component.tabline_tabpages(),
      },
      winbar = { -- UI breadcrumbs bar
        init = function(self)
          self.bufnr = vim.api.nvim_get_current_buf()
        end,
        fallthrough = false,
        {
          lib.component.neotree(),
          lib.component.compiler_play(),
          {
            condition = conditions.is_active, -- 只在活动窗口中显示
            FilePath,
          },
          lib.component.fill(),
          lib.component.compiler_redo(),
        },
      },
      statusline = { -- UI statusbar
        hl = { fg = "fg", bg = "bg", bold = true },
        Mode,
        lib.component.git_branch(),
        FileInfo,
        lib.component.git_diff({}),
        lib.component.diagnostics(),
        lib.component.fill(),
        lib.component.cmd_info(),
        lib.component.fill(),
        Lsp,
        FittenCode,
        SuperMaven,
        Rime,
        FileCode,
        virtual_env,
        Overseer,
        lib.component.nav(),
      },
    }
  end,
  config = function(_, opts)
    local heirline = require("heirline")
    local heirline_components = require("heirline-components.all")

    -- Setup
    heirline_components.init.subscribe_to_events()
    heirline.load_colors(heirline_components.hl.get_colors())
    heirline.setup(opts)
  end,
}
