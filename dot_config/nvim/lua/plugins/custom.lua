return {
  -- 1. Refactoring.nvim - Code refactoring tools
  {
    "ThePrimeagen/refactoring.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    config = function()
      require("refactoring").setup({
        print_var_statements = {
          php = { 'dump(\'Variable: %s %s\', %s, PHP_EOL);' },
          go = { 'fmt.Println(fmt.Sprintf("%s %%+v ", %s))' },
        },
        printf_statements = {
          php = { 'dump("Debugging: %s");' },
        },
      })
    end,
    keys = {
      { "<Leader>rv", function() require("refactoring").debug.print_var({}) end, desc = "Print var after" },
      { "<Leader>rV", function() require("refactoring").debug.print_var({ below = false }) end, desc = "Print var before" },
      { "<Leader>rf", function() require("refactoring").debug.printf({}) end, desc = "Print debug after" },
      { "<Leader>rF", function() require("refactoring").debug.printf({ below = false }) end, desc = "Print debug before" },
      { "<Leader>rc", function() require("refactoring").debug.cleanup({}) end, desc = "Clear debugging" },
    },
  },

  -- 2. Neotest - Test runner
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
      { "<Leader>ta", function() require("neotest").run.attach() end, desc = "Neotest attach" },
      { "<Leader>ts", function() require("neotest").summary.toggle() end, desc = "Neotest summary" },
      { "<Leader>tp", function() require("neotest").output_panel.toggle() end, desc = "Neotest output-panel" },
      { "<Leader>to", function() require("neotest").output.open() end, desc = "Neotest output" },
      { "<Leader>tt", function() require("neotest").run.run() end, desc = "Neotest current test" },
      { "<Leader>td", function() require("neotest").run.run({ strategy = "dap" }) end, desc = "Neotest current debug" },
      { "<Leader>tf", function() require("neotest").run.run(vim.fn.expand("%")) end, desc = "Neotest current file" },
    },
  },

  -- 3. Better Escape - Better escape from insert mode
  {
    "max397574/better-escape.nvim",
    config = function()
      require("better_escape").setup({
        timeout = vim.o.timeoutlen,
        default_mappings = false,
        mappings = {
          i = {
            j = {
              k = "<Esc>",
              j = "<Esc>",
            },
          },
          c = {
            j = {
              k = "<Esc>",
              j = "<Esc>",
            },
          },
          s = {
            j = {
              k = "<Esc>",
            },
          },
        },
      })
    end,
  },

  -- 4. Obsidian.nvim - Obsidian vault integration
  {
    "obsidian-nvim/obsidian.nvim",
    version = "*",
    lazy = true,
    ft = "markdown",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    opts = {
      workspaces = {
        {
          name = "The-Second-Brain",
          path = "~/Documents/Vaults/The-Second-Brain",
        },
        {
          name = "Personal",
          path = "~/Documents/Vaults/Personal",
          overrides = {
            daily_notes = {
              folder = "01 Timebox",
              date_format = "%Y/%m/%d",
              template = "00 ZK/9 Templates/Time boxing template.md",
            },
          },
        },
      },
      notes_subdir = "00 ZK/3 Notes",
      daily_notes = {
        folder = "00 ZK/1 Daily",
        date_format = "%Y/Week %U/%Y-%m-%d",
        template = "00 ZK/9 Templates/Daily template.md",
      },
      completion = {
        nvim_cmp = true,
        min_chars = 0,
      },
      new_notes_location = "notes_subdir",
      note_id_func = function(title)
        return title
      end,
      note_path_func = function(spec)
        local path = spec.dir / tostring(spec.id)
        return path:with_suffix(".md")
      end,
      wiki_link_func = function(opts)
        return require("obsidian.util").wiki_link_id_prefix(opts)
      end,
      markdown_link_func = function(opts)
        return require("obsidian.util").markdown_link(opts)
      end,
      preferred_link_style = "wiki",
      image_name_func = function()
        return string.format("%s-", os.time())
      end,
      disable_frontmatter = true,
      templates = {
        subdir = "00 ZK/9 Templates",
        date_format = "%Y-%m-%d",
        time_format = "%H:%M",
      },
      follow_url_func = function(url)
        vim.fn.jobstart({ "xdg-open", url })
      end,
      open_app_foreground = true,
      picker = {
        name = "telescope.nvim",
        mappings = {
          new = "<C-x>",
          insert_link = "<C-l>",
        },
      },
      sort_by = "modified",
      sort_reversed = true,
      ui = {
        enable = false,
      },
      attachments = {
        img_folder = "99 Assets",
      },
    },
    keys = {
      -- Mnemonic keybindings for Obsidian
      { "<Leader>on", ":ObsidianNew<CR>", desc = "Obsidian [n]ew note" },
      { "<Leader>ot", ":ObsidianToday<CR>", desc = "Obsidian [t]oday" },
      { "<Leader>oy", ":ObsidianYesterday<CR>", desc = "Obsidian [y]esterday" },
      { "<Leader>om", ":ObsidianTomorrow<CR>", desc = "Obsidian to[m]orrow" },
      { "<Leader>od", ":ObsidianDailies<CR>", desc = "Obsidian [d]ailies" },
      { "<Leader>oq", ":ObsidianQuickSwitch<CR>", desc = "Obsidian [q]uick switch" },
      { "<Leader>of", ":ObsidianFollowLink<CR>", desc = "Obsidian [f]ollow link" },
      { "<Leader>ob", ":ObsidianBacklinks<CR>", desc = "Obsidian [b]acklinks" },
      { "<Leader>oc", ":ObsidianTOC<CR>", desc = "Obsidian table of [c]ontents" },
      { "<Leader>oa", ":ObsidianTags<CR>", desc = "Obsidian t[a]gs" },
      { "<Leader>op", ":ObsidianPasteImg<CR>", desc = "Obsidian [p]aste image" },
      { "<Leader>or", ":ObsidianRename<CR>", desc = "Obsidian [r]ename" },
      { "<Leader>oo", ":ObsidianOpen<CR>", desc = "Obsidian [o]pen app" },
      -- Visual mode mappings
      { "ox", ":ObsidianExtractNote<CR>", mode = "v", desc = "Obsidian e[x]tract note" },
      { "ol", ":ObsidianLink<CR>", mode = "v", desc = "Obsidian [l]ink selection" },
    },
  },
}