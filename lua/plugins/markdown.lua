return {
  {
    "iamcco/markdown-preview.nvim",
    enabled = vim.uv.os_uname().sysname:find("Windows") ~= nil or require("utils").is_wsl(),
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    build = "cd app && yarn install",
    init = function()
      vim.g.mkdp_filetypes = { "markdown" }
    end,
    ft = { "markdown" },
  },
}
