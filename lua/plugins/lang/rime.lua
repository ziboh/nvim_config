return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        rime_ls = {
          enabled = false,
          on_attach = Utils.lsp.rime_on_attach,
          offset_encoding = "utf-8",
          on_new_config = function(new_config)
            if Utils.is_win() then
              new_config.init_options.user_data_dir = "D:\\软件\\rime\\config"
              new_config.init_options.log_dir = "D:\\软件\\rime\\logs"
              new_config.init_options.shared_data_dir = "D:\\软件\\rime\\data"
            end
          end,
          init_options = {
            enabled = vim.g.rime_enabled,
            shared_data_dir = "/usr/share/rime-data",
            user_data_dir = vim.fn.expand("~/.local/share/rime-ls"),
            log_dir = vim.fn.expand("~/.local/share/rime-ls/logs"),
            long_filter_text = true,
            schema_trigger_character = "&",
          },
        },
      },
      setup = {
        rime_ls = function(_, opts)
          if vim.fn.executable("rime_ls") == 0 and Utils.is_win() then
            Utils.warn("Rime LSP is not installed", { itle = "Rime LSP" })
            return true
          elseif vim.fn.executable("rime_ls") == 0 then
            vim.schedule(function()
              Utils.info("installing Rime LSP...")
              Utils.lsp.install_rime_ls(function(success)
                if success then
                  vim.schedule(function()
                    Utils.rime.setup({
                      filetype = vim.g.rime_ls_support_filetype,
                    })
                    require("lspconfig").rime_ls.setup(opts)
                    vim.cmd("LspStart rime_ls")
                  end)
                end
              end)
            end)
            return true
          end

          vim.g.rclone_sync_rime = false
          if Utils.is_remote() and vim.fn.executable("rclone") == 1 then
            vim.g.rclone_sync_rime = true
            vim.g.rclone_rime_remote_path = "od:webdav/rime"
            vim.g.rclone_rime_local_path = vim.fn.expand("~/rclone/rime")
          end

          Utils.rime.setup({
            filetype = vim.g.rime_ls_support_filetype,
          })
        end,
      },
    },
  },
}
