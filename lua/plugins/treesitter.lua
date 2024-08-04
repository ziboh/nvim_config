return {
  "nvim-treesitter/nvim-treesitter",
  lazy = true,
  config = function()
    require("nvim-treesitter.configs").setup {
      ensure_installed = {
        "c",
        "lua",
        "vim",
        "vimdoc",
        "query",
        "toml",
        "rust",
        "cpp",
        "objc",
        "cuda",
        "proto",
        "http",
        "html",
      },
      sync_install = false,
      auto_install = true,
      highlight = {
        enable = true,
        disable = { "c", "rust" },
        additional_vim_regex_highlighting = false,
      },
    }
  end,
}
