return {
  "windwp/nvim-autopairs",
  event = "InsertEnter",
  config = function(opts)
    local npairs = require "nvim-autopairs"
    npairs.setup(opts)
    local utils = require "utils"
    utils.on_load(
      "nvim-cmp",
      function()
        require("cmp").event:on(
          "confirm_done",
          require("nvim-autopairs.completion.cmp").on_confirm_done { tex = false }
        )
      end
    )
  end,
}
