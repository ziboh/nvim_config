return {
  {
    "saecki/crates.nvim",
    event = { "BufRead Cargo.toml" },
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("crates").setup({
        lsp = {
          enabled = true,
          on_attach = function(client, bufnr)
            -- the same on_attach function as for your other lsp's
          end,
          actions = true,
          completion = true,
          hover = true,
        },
      })
      Utils.lsp.on_attach(function(client, bufnr)
        local function show_documentation()
          local filetype = vim.bo.filetype
          if filetype == "vim" or filetype == "help" then
            vim.cmd("h " .. vim.fn.expand("<cword>"))
          elseif filetype == "man" then
            vim.cmd("Man " .. vim.fn.expand("<cword>"))
          elseif vim.fn.expand("%:t") == "Cargo.toml" and require("crates").popup_available() then
            require("crates").show_popup()
          else
            vim.lsp.buf.hover()
          end
        end

        vim.keymap.set("n", "<leader>h", show_documentation, { bufnr = bufnr, silent = true,desc = "Hover" })
        vim.keymap.set("n", "K", show_documentation, { bufnr = bufnr, silent = true,desc = "Hover" })
      end, "crates.nvim")
    end,
  },
  {
    "mrcjkb/rustaceanvim",
    version = "^5",
    ft = { "rust" },
    cofnig = function()
      local rustacean_logfile = vim.fn.tempname() .. "-rustacean.log"
      vim.g.rustaceanvim = {
        tools = {
          hover_actions = {
            replace_builtin_hover = false,
          },
        },
        -- LSP configuration
        server = {
          cmd = function()
            return { Utils.lsp.get_rust_anlayzer(), "--log-file", rustacean_logfile }
          end,

          ---@type string The path to the rust-analyzer log file.
          logfile = rustacean_logfile,
        },
        -- DAP configuration
        dap = { adapter = Utils.lsp.get_codelldb() },
      }
    end,
  },
}
