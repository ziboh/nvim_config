return {
  "nvim-treesitter/nvim-treesitter",
  lazy = true,
  config = function()
    require("nvim-treesitter.configs").setup {
      ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "toml", "rust", "cpp", "objc", "cuda", "proto" },
      sync_install = false,
      auto_install = true,
      ignore_install = { "javascript" },
      highlight = {
        enable = true,
        disable = { "c", "rust" },
        additional_vim_regex_highlighting = false,
      },
    }
  end,
}
