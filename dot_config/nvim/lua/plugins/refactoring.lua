return {
  -- Refactoring.nvim - Code refactoring tools
  {
    "ThePrimeagen/refactoring.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    config = function()
      require("refactoring").setup({
        print_var_statements = {
          php = { "dump('Variable: %s %s', %s, PHP_EOL);" },
          go = { 'fmt.Println(fmt.Sprintf("%s %%+v ", %s))' },
        },
        printf_statements = {
          php = { 'dump("Debugging: %s");' },
        },
      })
    end,
    keys = {
      {
        "<Leader>rv",
        function()
          require("refactoring").debug.print_var({})
        end,
        desc = "Print var after",
      },
      {
        "<Leader>rV",
        function()
          require("refactoring").debug.print_var({ below = false })
        end,
        desc = "Print var before",
      },
      {
        "<Leader>rf",
        function()
          require("refactoring").debug.printf({})
        end,
        desc = "Print debug after",
      },
      {
        "<Leader>rF",
        function()
          require("refactoring").debug.printf({ below = false })
        end,
        desc = "Print debug before",
      },
      {
        "<Leader>rc",
        function()
          require("refactoring").debug.cleanup({})
        end,
        desc = "Clear debugging",
      },
    },
  },
}
