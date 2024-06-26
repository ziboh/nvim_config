return {
  {
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "pschmitt/telescope-yadm.nvim",
      "nvim-telescope/telescope-project.nvim",
    },
    config = function()
      local project_actions = require "telescope._extensions.project.actions"
      require("telescope").setup {
        extensions = {
          project = {
            base_dirs = {
              -- "~/project",
              "~/.config",
              -- "~/gitdir",
            },
            hidden_files = true, -- default: false
            theme = "dropdown",
            -- order_by = "asc",
            search_by = "title",
            sync_with_nvim_tree = false, -- default false
            -- default for on_project_selected = find project files
            -- on_project_selected = function(prompt_bufnr)
            --   -- Do anything you want in here. For example:
            --   project_actions.change_working_directory(prompt_bufnr, false)
            -- end,
          },
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
      require("telescope").load_extension "project"
    end,
  },
  {
    "nvim-telescope/telescope-fzf-native.nvim",
    build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build",
  },
}
