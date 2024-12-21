return {
  "rebelot/heirline.nvim",
  dependencies = { { "mathjiajia/heirline-components.nvim", branch = "fix_conform" } },
  opts = function()
    local lib = require("heirline-components.all")
    local conditions = require("heirline.conditions")
    -- 定义一个组件来显示文件路径
    local FilePath = {
      provider = function(_)
        local filepath = vim.fn.expand("%:p") -- 获取当前文件的完整路径
        local home = vim.env.HOME -- 获取用户的主目录
        -- 将路径中的主目录替换为 ~
        filepath = filepath:gsub(home, "")
        -- 将路径中的斜杠替换为 >，兼容不同平台
        filepath = filepath:gsub("[\\/]", "")

        return filepath
      end,
      hl = { fg = "#c099ff" }, -- 设置高亮颜色
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
        hl = { fg = "fg", bg = "bg" },
        lib.component.mode({
          hl = {
            fg = "#1a1d23",
            bg = "mode_bg",
            bold = true,
          },
          mode_text = { pad_text = "center" }, -- if set, displays text.
        }),
        lib.component.git_branch(),
        lib.component.file_info(),
        lib.component.git_diff({}),
        lib.component.diagnostics(),
        lib.component.fill(),
        lib.component.cmd_info(),
        lib.component.fill(),
        lib.component.lsp({
          lsp_progress = false,
        }),
        {
          provider = '%{&ft == "toggleterm" ? "terminal [".b:toggle_number."]" : ""}',
        },
        -- require("utils").has("fittencode.nvim")
        --     and {
        --       { provider = "   " },
        --       {
        --         provider = " Fitten",
        --         hl = function()
        --           if require("fittencode").get_current_status() ~= 1 then
        --             return { fg = "#82aa78", bold = true }
        --           else
        --             return { fg = "#ed8796", bold = true }
        --           end
        --         end,
        --         on_click = {
        --           name = "heirline_fittencode",
        --           callback = function()
        --             require("utils.toggle").fittencode(false)
        --           end,
        --         },
        --         update = {
        --           "User", -- events that make this component refresh.
        --           pattern = "ToggleFitten",
        --         },
        --       },
        --     }
        --   or { provider = "" },
        {
          condition = function()
            return vim.bo.fenc ~= ""
          end,
          {
            provider = "    ",
          },
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
        },
        lib.component.compiler_state(),
        lib.component.virtual_env(),
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
