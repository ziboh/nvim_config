return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        autohotkey_lsp = {
          enabled = Utils.is_win(),
          cmd = {
            "node",
            vim.fn.expand(vim.fn.stdpath("data") .. "/vscode-autohotkey2-lsp/server/dist/server.js"),
            "--stdio",
          },
          init_options = {
            locale = "zh-cn",
          },
        },
      },
      setup = {
        autohotkey_lsp = function(_, opts)
          local server_path = vim.fn.expand(vim.fn.stdpath("data") .. "/vscode-autohotkey2-lsp/server/dist/server.js")

          if vim.fn.filereadable(server_path) == 1 then
            return
          else
            vim.schedule(function()
              Utils.info("Installing AutoHotkey language server...")
              Utils.lsp.install_ahk2_lsp(function(success)
                if success then
                  vim.schedule(function()
                    require("lspconfig").autohotkey_lsp.setup(opts)
                    if vim.bo.filetype == "autohotkey" or vim.bo.filetype == "ahk" then
                      vim.cmd("LspStart autohotkey_lsp")
                    end
                  end)
                end
              end)
            end)
            return true
          end
        end,
      },
    },
  },
}
