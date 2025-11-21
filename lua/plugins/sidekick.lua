return {
  {
    "folke/sidekick.nvim",
    opts = {
      cli = {
        prompts = {
          changes = "你能审查我的更改吗？",
          diagnostics = "你能帮我修复 {file} 中的诊断问题吗？\n{diagnostics}",
          diagnostics_all = "你能帮我修复这些诊断问题吗？\n{diagnostics_all}",
          document = "为 {function|line} 添加文档",
          explain = "解释 {this}",
          fix = "你能修复 {this} 吗？",
          optimize = "{this} 如何优化？",
          review = "你能审查 {file} 中的任何问题或改进建议吗？",
          tests = "你能为 {this} 编写测试吗？",
          -- 简单上下文提示
          buffers = "{buffers}",
          file = "{file}",
          line = "{line}",
          position = "{position}",
          quickfix = "{quickfix}",
          selection = "{selection}",
          ["function"] = "{function}",
          class = "{class}",
        },
      },
    },
    keys = {
      {
        "<tab>",
        function()
          -- if there is a next edit, jump to it, otherwise apply it if any
          if not require("sidekick").nes_jump_or_apply() then
            return "<Tab>" -- fallback to normal tab
          end
        end,
        expr = true,
        desc = "Goto/Apply Next Edit Suggestion",
      },
      {
        "<C-A-F7>",
        function()
          require("sidekick.cli").toggle()
        end,
        desc = "Sidekick Toggle",
        mode = { "n", "t", "i", "x" },
      },
      {
        "<leader>aa",
        function()
          require("sidekick.cli").toggle()
        end,
        desc = "Sidekick Toggle CLI",
      },
      {
        "<leader>as",
        function()
          require("sidekick.cli").select()
        end,
        -- Or to select only installed tools:
        -- require("sidekick.cli").select({ filter = { installed = true } })
        desc = "Select CLI",
      },
      {
        "<leader>ad",
        function()
          require("sidekick.cli").close()
        end,
        desc = "Detach a CLI Session",
      },
      {
        "<leader>at",
        function()
          require("sidekick.cli").send({ msg = "{this}" })
        end,
        mode = { "x", "n" },
        desc = "Send This",
      },
      {
        "<leader>af",
        function()
          require("sidekick.cli").send({ msg = "{file}" })
        end,
        desc = "Send File",
      },
      {
        "<leader>av",
        function()
          require("sidekick.cli").send({ msg = "{selection}" })
        end,
        mode = { "x" },
        desc = "Send Visual Selection",
      },
      {
        "<leader>ap",
        function()
          require("sidekick.cli").prompt()
        end,
        mode = { "n", "x" },
        desc = "Sidekick Select Prompt",
      },
      -- Example of a keybinding to open Claude directly
      {
        "<leader>ac",
        function()
          require("sidekick.cli").toggle({ name = "claude", focus = true })
        end,
        desc = "Sidekick Toggle Claude",
      },
      {
        "<leader>aq",
        function()
          require("sidekick.cli").toggle({ name = "qwen", focus = true })
        end,
        desc = "Sidekick Toggle Claude",
      },
    },
  },
}
