return {
  "nvim-neo-tree/neo-tree.nvim",
  dependencies = "MunifTanjim/nui.nvim",
  lazy = false,
  cmd = "Neotree",
  opts = function()
    vim.g.neo_tree_remove_legacy_commands = true
    local utils = require("utils")
    local get_icon = utils.get_icon
    return {
      auto_clean_after_session_restore = true,
      close_if_last_window = true,
      buffers = {
        show_unloaded = true,
      },
      sources = { "filesystem", "buffers", "git_status" },
      open_files_do_not_replace_types = { "terminal", "Trouble", "trouble", "qf", "Outline" },
      source_selector = {
        winbar = true,
        content_layout = "center",
        sources = {
          {
            source = "filesystem",
            display_name = get_icon("FolderClosed", 1, true) .. "File",
          },
          {
            source = "buffers",
            display_name = get_icon("DefaultFile", 1, true) .. "Bufs",
          },
          {
            source = "git_status",
            display_name = get_icon("Git", 1, true) .. "Git",
          },
          {
            source = "diagnostics",
            display_name = get_icon("Diagnostic", 1, true) .. "Diagnostic",
          },
        },
      },
      default_component_configs = {
        indent = { padding = 0 },
        icon = {
          folder_closed = get_icon("FolderClosed"),
          folder_open = get_icon("FolderOpen"),
          folder_empty = get_icon("FolderEmpty"),
          folder_empty_open = get_icon("FolderEmpty"),
          default = get_icon("DefaultFile"),
        },
        modified = { symbol = get_icon("FileModified") },
        git_status = {
          symbols = {
            added = get_icon("GitAdd"),
            deleted = get_icon("GitDelete"),
            modified = get_icon("GitChange"),
            renamed = get_icon("GitRenamed"),
            untracked = get_icon("GitUntracked"),
            ignored = get_icon("GitIgnored"),
            unstaged = get_icon("GitUnstaged"),
            staged = get_icon("GitStaged"),
            conflict = get_icon("GitConflict"),
          },
        },
      },
      -- A command is a function that we can assign to a mapping (below)
      commands = {
        image_wezterm = function(state)
          local node = state.tree:get_node()
          if node.type == "file" then
            require("image_preview").PreviewImage(node.path)
          end
        end,
        system_open = function(state)
          local node = state.tree:get_node()
          local path = node:get_id()
          if Utils.is_win() then
            vim.cmd("silent !start " .. path)
          end
        end,
        parent_or_close = function(state)
          local node = state.tree:get_node()
          if (node.type == "directory" or node:has_children()) and node:is_expanded() then
            state.commands.toggle_node(state)
          else
            require("neo-tree.ui.renderer").focus_node(state, node:get_parent_id())
          end
        end,
        child_or_open = function(state)
          local node = state.tree:get_node()
          if node.type == "directory" or node:has_children() then
            if not node:is_expanded() then -- if unexpanded, expand
              state.commands.toggle_node(state)
            else -- if expanded and has children, seleect the next child
              require("neo-tree.ui.renderer").focus_node(state, node:get_child_ids()[1])
            end
          else -- if not a directory just open it
            state.commands.open(state)
          end
        end,
        copy_selector = function(state)
          local node = state.tree:get_node()
          local filepath = node:get_id()
          local filename = node.name
          local modify = vim.fn.fnamemodify

          local results = {
            e = { val = modify(filename, ":e"), msg = "Extension only" },
            f = { val = filename, msg = "Filename" },
            F = {
              val = modify(filename, ":r"),
              msg = "Filename w/o extension",
            },
            h = {
              val = modify(filepath, ":~"),
              msg = "Path relative to Home",
            },
            p = {
              val = modify(filepath, ":."),
              msg = "Path relative to CWD",
            },
            P = { val = filepath, msg = "Absolute path" },
          }

          local messages = {
            { "\nChoose to copy to clipboard:\n", "Normal" },
          }
          for i, result in pairs(results) do
            if result.val and result.val ~= "" then
              vim.list_extend(messages, {
                { ("%s."):format(i), "Identifier" },
                { (" %s: "):format(result.msg) },
                { result.val, "String" },
                { "\n" },
              })
            end
          end
          vim.api.nvim_echo(messages, false, {})
          local result = results[vim.fn.getcharstr()]
          if result and result.val and result.val ~= "" then
            vim.notify("Copied: " .. result.val)
            vim.fn.setreg("+", result.val)
          end
        end,
        find_in_dir = function(state)
          local node = state.tree:get_node()
          local path = node:get_id()
          require("telescope.builtin").find_files({
            cwd = node.type == "directory" and path or vim.fn.fnamemodify(path, ":h"),
          })
        end,
        toggle_dir_or_open = function(state)
          local node = state.tree:get_node()
          if node.type == "directory" then
            state.commands.toggle_node(state)
          elseif Utils.is_image(node.path) then
            state.commands.image_wezterm(state)
          else
            state.commands.open(state)
          end
        end,
      },
      window = {
        width = 30,
        mappings = {
          ["<leader>p"] = "image_wezterm", -- " or another map
          -- ["<space>"] = false, -- disable space until we figure out which-key disabling
          ["<S-CR>"] = "system_open",
          ["<CR>"] = "toggle_dir_or_open",
          ["[b"] = "prev_source",
          ["]b"] = "next_source",
          F = utils.has("telescope.nvim") and "find_in_dir" or nil,
          O = "system_open",
          Y = "copy_selector",
          h = "parent_or_close",
          l = "child_or_open",
          -- ["<space>"] = "toggle_dir_or_open",
        },
      },
      filesystem = {
        bind_to_cwd = false,
        follow_current_file = {
          enabled = true,
        },
        hijack_netrw_behavior = "open_current",
        use_libuv_file_watcher = false,
      },
      event_handlers = {
        {
          event = "neo_tree_buffer_enter",
          handler = function(_)
            vim.opt_local.signcolumn = "auto"
          end,
        },
      },
    }
  end,
  keys = {
    {
      "<leader>e",
      function()
        require("neo-tree.command").execute({ toggle = true, dir = Utils.root() })
      end,
      desc = "Explorer NeoTree (Root Dir)",
    },
    {
      "<leader>E",
      function()
        require("neo-tree.command").execute({ toggle = true, dir = vim.uv.cwd() })
      end,
      desc = "Explorer NeoTree (cwd)",
    },
    { "<leader>E", "<leader>fE", desc = "Explorer NeoTree (cwd)", remap = true },
    {
      "<leader>ge",
      function()
        require("neo-tree.command").execute({ source = "git_status", toggle = true })
      end,
      desc = "Git Explorer",
    },
    {
      "<leader>be",
      function()
        require("neo-tree.command").execute({ source = "buffers", toggle = true })
      end,
      desc = "Buffer Explorer",
    },
  },
}
