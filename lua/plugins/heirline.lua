return {
  "rebelot/heirline.nvim",
  enabled = vim.fn.has "nvim-0.10" == 1,
  dependencies = { { "mathjiajia/heirline-components.nvim", branch = "fix_conform" } },
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
        {
          lib.component.neotree(),
          lib.component.compiler_play(),
          lib.component.fill(),
          lib.component.breadcrumbs(),
          lib.component.fill(),
          lib.component.compiler_redo(),
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
          hl = {
            fg = "#1a1d23",
            bg = "mode_bg",
            bold = true,
          },
          mode_text = { pad_text = "center" }, -- if set, displays text.
        },
        lib.component.git_branch(),
        lib.component.file_info(),
        lib.component.git_diff {},
        lib.component.diagnostics(),
        lib.component.fill(),
        lib.component.cmd_info(),
        lib.component.fill(),
        lib.component.lsp {
          lsp_progress = false,
        },
        {
          provider = '%{&ft == "toggleterm" ? "terminal [".b:toggle_number."]" : ""}',
        },
        require("utils").is_available "fittencode.nvim"
            and {
              { provider = "   " },
              {
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
              },
            }
          or { provider = "" },
        lib.component.compiler_state(),
        {

          condition = function() return vim.bo.fenc ~= "" end,
          {
            provider = "    ",
          },
          {
            hl = { fg = "#50a4e9", bold = true },
            provider = function()
              local enc = vim.bo.fenc
              if enc == "euc-cn" then enc = "gbk" end
              return enc ~= "" and enc:upper() .. "[" .. vim.bo.ff:sub(1, 1):upper() .. vim.bo.ff:sub(2) .. "]"
            end,
          },
        },
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
