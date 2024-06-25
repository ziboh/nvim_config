return {
  "kevinhwang91/nvim-ufo",
  lazy = false,
  dependencies = {
    { "kevinhwang91/promise-async", lazy = true },
  },
  config = function()
    local ftMap = {
      vim = { "indent", "treesitter" },
      lua = "indent",
      python = { "indent" },
      git = "",
    }
    require("ufo").setup {
      preview = {
        mappings = {
        	scrollB = "<C-B>",
        	scrollF = "<C-F>",
        	scrollU = "<C-U>",
        	scrollD = "<C-D>",
        },
      },
      provider_selector = function(bufnr, filetype, buftype)
        -- if you prefer treesitter provider rather than lsp,
        -- return ftMap[filetype] or {'treesitter', 'indent'}
        return ftMap[filetype]

        -- refer to ./doc/example.lua for detail
      end,
    }
    vim.keymap.set("n", "zR", require("ufo").openAllFolds)
    vim.keymap.set("n", "zM", require("ufo").closeAllFolds)
    vim.keymap.set("n", "zr", require("ufo").openFoldsExceptKinds)
    vim.keymap.set("n", "zm", require("ufo").closeFoldsWith) -- closeAllFolds == closeFoldsWith(0)
    -- vim.keymap.set("n", "K", function()
    -- 	local winid = require("ufo").peekFoldedLinesUnderCursor()
    -- 	if not winid then
    -- 		vim.lsp.buf.hover()
    -- 	end
    -- end)
  end,
}
