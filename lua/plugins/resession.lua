return {
  "stevearc/resession.nvim",
  config = function()
    require("resession").setup {
      -- Options for automatically saving sessions on a timer
      autosave = {
        enabled = false,
        -- How often to save (in seconds)
        interval = 60,
        -- Notify when autosaved
        notify = true,
      },
      -- Save and restore these options
      options = {
        "binary",
        "bufhidden",
        "buflisted",
        "cmdheight",
        "diff",
        "filetype",
        "modifiable",
        "previewwindow",
        "readonly",
        "scrollbind",
        "winfixheight",
        "winfixwidth",
      },
      -- Custom logic for determining if the buffer should be included
      buf_filter = require("resession").default_buf_filter,
      -- Custom logic for determining if a buffer should be included in a tab-scoped session
      tab_buf_filter = function(tabpage, bufnr) return true end,
      -- The name of the directory to store sessions in
      dir = "session",
      -- Show more detail about the sessions when selecting one to load.
      -- Disable if it causes lag.
      load_detail = true,
      -- List order ["modification_time", "creation_time", "filename"]
      load_order = "modification_time",
      -- Configuration for extensions
      extensions = {
        quickfix = {},
      },
    }
  end,
}
