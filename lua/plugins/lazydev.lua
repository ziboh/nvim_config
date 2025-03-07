return {
  {
    "folke/lazydev.nvim",
    ft = "lua", -- only load on lua files
    spec = {
      { "Bilal2453/luvit-meta", lazy = true }, -- optional `vim.uv` typings
      { "justinsgithub/wezterm-types", lazy = true },
      {
        "saghen/blink.cmp",
        opts = {
          sources = {
            default = { "lazydev" },
            providers = {
              lazydev = {
                name = "LazyDev",
                module = "lazydev.integrations.blink",
                score_offset = 100, -- show at a higher priority than lsp
              },
            },
          },
        },
      },
    },
    opts = {
      library = {
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
        { path = "snacks.nvim", words = { "Snacks" } },
        { path = vim.fn.stdpath("config") .. "/lua/utils", words = { "Utils" } },
        { path = "lazy.nvim", words = { "Utils" } },
        { path = "wezterm-types", mods = { "wezterm" } },
      },
    },
  },
}
