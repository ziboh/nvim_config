return {
  {
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    dependencies = { "nvim-lua/plenary.nvim", "pschmitt/telescope-yadm.nvim" },
    config = function()
      require("telescope").setup {
        extensions = {
          -- Your extension configuration goes here:
          -- extension_name = {
          --   extension_config_key = value,
          -- }
          -- please take a look at the readme of the extension you want to configure
          fzf = {
            fuzzy = true, -- false will only do exact matching
            override_generic_sorter = true, -- override the generic sorter
            override_file_sorter = true, -- override the file sorter
            case_mode = "smart_case", -- or "ignore_case" or "respect_case"
            -- the default case_mode is "smart_case"
          },
          workspaces = {
            -- keep insert mode after selection in the picker, default is false
            keep_insert = true,
          },
        },
      }
      require("telescope").load_extension "fzf"
      require("telescope").load_extension "yadm_files"
      require("telescope").load_extension "git_or_files"
      require("telescope").load_extension "git_or_yadm_files"
    end,
  },
  {
    "nvim-telescope/telescope-fzf-native.nvim",
    build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build",
  },
}
