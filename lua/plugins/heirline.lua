return {
  "rebelot/heirline.nvim",
  dependencies = { "zeioth/heirline-components.nvim" },
  opts = function()
    local lib = require "heirline-components.all"
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
        lib.component.fill { hl = { bg = "tabline_bg" } },
        lib.component.tabline_tabpages(),
      },
      winbar = { -- UI breadcrumbs bar
        init = function(self) self.bufnr = vim.api.nvim_get_current_buf() end,
        fallthrough = false,
        -- Winbar for terminal, neotree, and aerial.
        {
          condition = function() return not lib.condition.is_active() end,
          {
            lib.component.neotree(),
            lib.component.compiler_play(),
            lib.component.fill(),
            lib.component.compiler_redo(),
            lib.component.aerial(),
          },
        },
        -- Regular winbar
        {
          lib.component.neotree(),
          lib.component.compiler_play(),
          lib.component.fill(),
          lib.component.breadcrumbs(),
          lib.component.fill(),
          lib.component.compiler_redo(),
          lib.component.aerial(),
        },
      },
      statuscolumn = { -- UI left column
        init = function(self) self.bufnr = vim.api.nvim_get_current_buf() end,
        lib.component.foldcolumn(),
        lib.component.numbercolumn(),
        lib.component.signcolumn(),
      } or nil,
      statusline = { -- UI statusbar
        hl = { fg = "fg", bg = "bg" },
        lib.component.mode {
          mode_text = { pad_text = "center" }, -- if set, displays text.
          paste = { str = "", icon = { kind = "Paste" }, show_empty = true }, -- if set, displays if paste is enabled.
          spell = { str = "", icon = { kind = "Spellcheck" }, show_empty = true }, -- if set, displays if spellcheck is on.
          surround = {
            separator = "left", -- where to add the separator.
            color = lib.hl.mode_bg, -- you can set a custom background color, for example "#444444".
            update = { "ModeChanged", pattern = "*:*" },
          }, -- events that make the surround provider refresh.
          hl = { bold = true }, -- you can specify your own highlight group here.
          update = {
            "ModeChanged", -- events that make this component refresh.
            pattern = "*:*",
            callback = vim.schedule_wrap(function() vim.cmd.redrawstatus() end),
          },
        },
        lib.component.git_branch(),
        lib.component.file_info(),
        lib.component.git_diff {},
        lib.component.diagnostics(),
        lib.component.fill(),
        lib.component.cmd_info(),
        lib.component.fill(),
        lib.component.lsp(),
        {
          provider = '%{&ft == "toggleterm" ? "terminal [".b:toggle_number."]" : ""}',
        },
        {
          provider = "   ",
        },
        require("utils").is_available "fittencode.nvim"
            and {
              provider = " Fitten",
              hl = function()
                if require("fittencode").get_current_status() ~= 1 then
                  return { fg = "#82aa78", bold = true }
                else
                  return { fg = "#ed8796", bold = true }
                end
              end,
              on_click = {
                name = "heirline_fittencode",
                callback = function() require("utils.toggle").fittencode(false) end,
              },
              update = {
                "User", -- events that make this component refresh.
                pattern = "ToggleFitten",
              },
            }
          or nil,
        lib.component.compiler_state(),
        lib.component.virtual_env(),
        lib.component.nav(),
        -- lib.component.mode({ surround = { separator = "right" } }),
      },
    }
  end,
  config = function(_, opts)
    local heirline = require "heirline"
    local heirline_components = require "heirline-components.all"

    -- Setup
    heirline_components.init.subscribe_to_events()
    heirline.load_colors(heirline_components.hl.get_colors())
    heirline.setup(opts)
  end,
}
