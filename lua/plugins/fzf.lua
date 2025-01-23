vim.g.lazyvim_picker = "fzf"

local picker = {
  name = "fzf",
  commands = {
    files = "files",
  },

  ---@param command string
  ---@param opts? FzfLuaOpts
  open = function(command, opts)
    opts = opts or {}
    if opts.cmd == nil and command == "git_files" and opts.show_untracked then
      opts.cmd = "git ls-files --exclude-standard --cached --others"
    end
    return require("fzf-lua")[command](opts)
  end,
}

if not Utils.pick.register(picker) then
  return {}
end

return {
  "ibhagwan/fzf-lua",
  cmd = "FzfLua",
  -- enabled = false,
  opts = function(_, opts)
    local config = require("fzf-lua.config")
    local actions = require("fzf-lua.actions")

    -- Quickfix
    config.defaults.keymap.fzf["ctrl-q"] = "select-all+accept"
    config.defaults.keymap.fzf["ctrl-u"] = "half-page-up"
    config.defaults.keymap.fzf["ctrl-d"] = "half-page-down"
    config.defaults.keymap.fzf["ctrl-x"] = "jump"
    config.defaults.keymap.fzf["ctrl-b"] = "preview-page-down"
    config.defaults.keymap.fzf["ctrl-f"] = "preview-page-up"
    config.defaults.keymap.builtin["<c-b>"] = "preview-page-down"
    config.defaults.keymap.builtin["<c-f>"] = "preview-page-up"

    -- Trouble
    if Utils.has("trouble.nvim") then
      config.defaults.actions.files["ctrl-t"] = require("trouble.sources.fzf").actions.open
    end

    -- Toggle root dir / cwd
    config.defaults.actions.files["ctrl-r"] = function(_, ctx)
      local o = vim.deepcopy(ctx.__call_opts)
      o.root = o.root == false
      o.cwd = nil
      o.buf = ctx.__CTX.bufnr
      require("utils.pick").open(ctx.__INFO.cmd, o)
    end
    config.defaults.actions.files["alt-c"] = config.defaults.actions.files["ctrl-r"]
    config.set_action_helpstr(config.defaults.actions.files["ctrl-r"], "toggle-root-dir")

    local img_previewer ---@type string[]?
    for _, v in ipairs({
      { cmd = "ueberzug", args = {} },
      { cmd = "chafa", args = { "{file}", "--format=symbols" } },
      { cmd = "viu", args = { "-b" } },
    }) do
      if vim.fn.executable(v.cmd) == 1 then
        img_previewer = vim.list_extend({ v.cmd }, v.args)
        break
      end
    end

    return {
      "default-title",
      fzf_colors = true,
      fzf_opts = {
        ["--no-scrollbar"] = true,
      },
      defaults = {
        -- formatter = "path.filename_first",
        formatter = "path.dirname_first",
      },
      previewers = {
        builtin = {
          extensions = {
            ["png"] = img_previewer,
            ["jpg"] = img_previewer,
            ["jpeg"] = img_previewer,
            ["gif"] = img_previewer,
            ["webp"] = img_previewer,
          },
          ueberzug_scaler = false,
        },
      },
      -- Custom LazyVim option to configure vim.ui.select
      ui_select = function(fzf_opts, items)
        return vim.tbl_deep_extend("force", fzf_opts, {
          prompt = " ",
          winopts = {
            title = " " .. vim.trim((fzf_opts.prompt or "Select"):gsub("%s*:%s*$", "")) .. " ",
            title_pos = "center",
          },
        }, fzf_opts.kind == "codeaction" and {
          winopts = {
            layout = "vertical",
            -- height is number of items minus 15 lines for the preview, with a max of 80% screen height
            height = math.floor(math.min(vim.o.lines * 0.8 - 16, #items + 2) + 0.5) + 16,
            width = 0.5,
            preview = not vim.tbl_isempty(Utils.lsp.get_clients({ bufnr = 0, name = "vtsls" })) and {
              layout = "vertical",
              vertical = "down:15,border-top",
              hidden = "hidden",
            } or {
              layout = "vertical",
              vertical = "down:15,border-top",
            },
          },
        } or {
          winopts = {
            width = 0.5,
            -- height is number of items, with a max of 80% screen height
            height = math.floor(math.min(vim.o.lines * 0.8, #items + 2) + 0.5),
          },
        })
      end,
      winopts = {
        width = 0.8,
        height = 0.8,
        row = 0.5,
        col = 0.5,
        preview = {
          scrollchars = { "┃", "" },
        },
      },
      files = {
        cwd_prompt = false,
        actions = {
          ["alt-i"] = { actions.toggle_ignore },
          ["alt-h"] = { actions.toggle_hidden },
        },
      },
      grep = {
        actions = {
          ["alt-i"] = { actions.toggle_ignore },
          ["alt-h"] = { actions.toggle_hidden },
        },
      },
      lsp = {
        symbols = {
          symbol_hl = function(s)
            return "TroubleIcon" .. s
          end,
          symbol_fmt = function(s)
            return s:lower() .. "\t"
          end,
          child_prefix = false,
        },
        code_actions = {
          previewer = vim.fn.executable("delta") == 1 and "codeaction_native" or nil,
        },
      },
    }
  end,
  config = function(_, opts)
    if opts[1] == "default-title" then
      -- use the same prompt for all pickers for profile `default-title` and
      -- profiles that use `default-title` as base profile
      local function fix(t)
        t.prompt = t.prompt ~= nil and " " or nil
        for _, v in pairs(t) do
          if type(v) == "table" then
            fix(v)
          end
        end
        return t
      end
      opts = vim.tbl_deep_extend("force", fix(require("fzf-lua.profiles.default-title")), opts)
      opts[1] = nil
    end
    require("fzf-lua").setup(opts)
  end,
  init = function()
    Utils.on_very_lazy(function()
      ---@diagnostic disable-next-line: duplicate-set-field
      vim.ui.select = function(...)
        require("lazy").load({ plugins = { "fzf-lua" } })
        local opts = Utils.opts("fzf-lua") or {}
        require("fzf-lua").register_ui_select(opts.ui_select or nil)
        return vim.ui.select(...)
      end
    end)
  end,
  keys = {
    { "<c-j>", "<c-j>", ft = "fzf", mode = "t", nowait = true },
    { "<c-k>", "<c-k>", ft = "fzf", mode = "t", nowait = true },
    {
      "<leader>,",
      "<cmd>FzfLua buffers sort_mru=true sort_lastused=true<cr>",
      desc = "Switch Buffer",
    },
    { "<leader>:", "<cmd>FzfLua command_history<cr>", desc = "Command History" },
    { "<leader><space>", require("utils.pick")("files"), desc = "Find Files (Root Dir)" },
    -- find
    { "<leader>fb", "<cmd>FzfLua buffers sort_mru=true sort_lastused=true<cr>", desc = "Buffers" },
    { "<leader>fa", require("utils.pick").config_files(), desc = "Find Config File" },
    { "<leader>fF", require("utils.pick")("files", { root = false }), desc = "Find Files (cwd)" },
    { "<leader>fg", "<cmd>FzfLua git_files<cr>", desc = "Find Files (git-files)" },
    { "<leader>fo", "<cmd>FzfLua oldfiles<cr>", desc = "Old Files" },
    { "<leader>fr", "<cmd>FzfLua registers<cr>", desc = "Registers" },
    ---@diagnostic disable-next-line: assign-type-mismatch
    { "<leader>fR", require("utils.pick")("oldfiles", { cwd = vim.uv.cwd() }), desc = "Recent (cwd)" },
    -- git
    { "<leader>gc", "<cmd>FzfLua git_commits<CR>", desc = "Commits" },
    { "<leader>gs", "<cmd>FzfLua git_status<CR>", desc = "Status" },
    -- search
    { '<leader>f"', "<cmd>FzfLua registers<cr>", desc = "Registers" },
    { "<leader>fA", "<cmd>FzfLua autocmds<cr>", desc = "Auto Commands" },
    { "<leader>fB", "<cmd>FzfLua grep_curbuf<cr>", desc = "Buffer" },
    { "<leader>fc", "<cmd>FzfLua command_history<cr>", desc = "Command History" },
    { "<leader>fC", "<cmd>FzfLua commands<cr>", desc = "Commands" },
    { "<leader>fd", "<cmd>FzfLua diagnostics_document<cr>", desc = "Document Diagnostics" },
    { "<leader>lD", "<cmd>FzfLua diagnostics_document<cr>", desc = "Document Diagnostics" },
    { "<leader>fD", "<cmd>FzfLua diagnostics_workspace<cr>", desc = "Workspace Diagnostics" },
    { "<leader>ff", require("utils.pick")("live_grep"), desc = "Grep (Root Dir)" },
    { "<leader>fG", require("utils.pick")("live_grep", { root = false }), desc = "Grep (cwd)" },
    { "<leader>fh", "<cmd>FzfLua help_tags<cr>", desc = "Help Pages" },
    { "<leader>fH", "<cmd>FzfLua highlights<cr>", desc = "Search Highlight Groups" },
    { "<leader>fj", "<cmd>FzfLua jumps<cr>", desc = "Jumplist" },
    { "<leader>fk", "<cmd>FzfLua keymaps<cr>", desc = "Key Maps" },
    { "<leader>fl", "<cmd>FzfLua loclist<cr>", desc = "Location List" },
    { "<leader>fM", "<cmd>FzfLua man_pages<cr>", desc = "Man Pages" },
    { "<leader>fm", "<cmd>FzfLua marks<cr>", desc = "Jump to Mark" },
    { "<leader>f<enter>", "<cmd>FzfLua resume<cr>", desc = "Resume" },
    { "<leader>fq", "<cmd>FzfLua quickfix<cr>", desc = "Quickfix List" },
    { "<leader>fw", require("utils.pick")("grep_cword"), desc = "Word (Root Dir)" },
    { "<leader>fW", require("utils.pick")("grep_cword", { root = false }), desc = "Word (cwd)" },
    { "<leader>fw", require("utils.pick")("grep_visual"), mode = "v", desc = "Selection (Root Dir)" },
    { "<leader>fW", require("utils.pick")("grep_visual", { root = false }), mode = "v", desc = "Selection (cwd)" },
    { "<leader>ft", require("utils.pick")("colorschemes"), desc = "Colorscheme with Preview" },
    -- {
    --   "<leader>ss",
    --   function()
    --     require("fzf-lua").lsp_document_symbols({
    --       regex_filter = symbols_filter,
    --     })
    --   end,
    --   desc = "Goto Symbol",
    -- },
    -- {
    --   "<leader>sS",
    --   function()
    --     require("fzf-lua").lsp_live_workspace_symbols({
    --       regex_filter = symbols_filter,
    --     })
    --   end,
    --   desc = "Goto Symbol (Workspace)",
    -- },
  },
}
