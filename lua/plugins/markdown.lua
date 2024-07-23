return {
  "iamcco/markdown-preview.nvim",
  enabled = vim.fn.has "win32" == 1,
  cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
  ft = { "markdown" },
  build = function() vim.fn["mkdp#util#install"]() end,
}
