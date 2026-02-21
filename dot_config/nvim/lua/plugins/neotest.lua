return {
  -- Neotest - Test runner
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-neotest/nvim-nio",
      "nvim-lua/plenary.nvim",
      "antoinemadec/FixCursorHold.nvim",
      "nvim-treesitter/nvim-treesitter",
      "nvim-neotest/neotest-go",
      "olimorris/neotest-phpunit",
      "nvim-neotest/neotest-vim-test",
    },
    config = function()
      require("neotest").setup({
        adapters = {
          require("neotest-go"),
          require("neotest-phpunit"),
          require("neotest-vim-test"),
        },
      })
    end,
    keys = {
      {
        "<Leader>ta",
        function()
          require("neotest").run.attach()
        end,
        desc = "Neotest attach",
      },
      {
        "<Leader>ts",
        function()
          require("neotest").summary.toggle()
        end,
        desc = "Neotest summary",
      },
      {
        "<Leader>tp",
        function()
          require("neotest").output_panel.toggle()
        end,
        desc = "Neotest output-panel",
      },
      {
        "<Leader>to",
        function()
          require("neotest").output.open()
        end,
        desc = "Neotest output",
      },
      {
        "<Leader>tt",
        function()
          require("neotest").run.run()
        end,
        desc = "Neotest current test",
      },
      {
        "<Leader>td",
        function()
          require("neotest").run.run({ strategy = "dap" })
        end,
        desc = "Neotest current debug",
      },
      {
        "<Leader>tf",
        function()
          require("neotest").run.run(vim.fn.expand("%"))
        end,
        desc = "Neotest current file",
      },
    },
  },
}
