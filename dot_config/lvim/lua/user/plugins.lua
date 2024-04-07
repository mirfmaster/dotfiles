-- Additional Plugins
lvim.plugins = {
  -- COLORSCHEME
  -- ref: https://github.com/rockerBOO/awesome-neovim#colorscheme
  { 'tiagovla/tokyodark.nvim' },
  { 'kvrohit/substrata.nvim' },
  { "EdenEast/nightfox.nvim" },
  { 'nxvu699134/vn-night.nvim' },
  { 'rebelot/kanagawa.nvim' },
  -- PLUGINS
  {
    "folke/trouble.nvim",
    cmd = "TroubleToggle",
  },
  { "tpope/vim-surround" },
  { "psliwka/vim-smoothie" },
  { 'mg979/vim-visual-multi' },
  {
    "phaazon/hop.nvim",
    event = "BufRead",
    config = function()
      require("hop").setup()
    end,
  },
  {
    "rmagatti/auto-session",
    config = function()
      require("auto-session").setup({
        log_level = "info",
        -- auto_session_enable_last_session = true,
        auto_session_root_dir = vim.fn.stdpath("data") .. "/sessions/",
        auto_session_enabled = true,
        auto_save_enabled = true,
        auto_restore_enabled = false,
        -- auto_session_suppress_dirs = { "~/", "~/Projects" },
        auto_session_suppress_dirs = nil,
        -- auto_session_use_git_branch = true,
      })
    end,
  },
  {
    'rmagatti/session-lens',
    dependencies = { 'rmagatti/auto-session', 'nvim-telescope/telescope.nvim' },
    config = function()
      require("telescope").load_extension("session-lens")
      require('session-lens').setup {
        -- path_display = { 'shorten' },
        previewer = true
      }
    end
  },
  {
    "folke/todo-comments.nvim",
    dependencies = "nvim-lua/plenary.nvim",
    config = function()
      require("todo-comments").setup {}
    end
  },
  { 'godlygeek/tabular', },
  { 'ThePrimeagen/harpoon' },
  {
    'Exafunction/codeium.vim',
    config = function()
      vim.keymap.set('i', '<c-;>', function() return vim.fn['codeium#Accept']() end, { expr = true })
      vim.keymap.set('i', '<c-.>', function() return vim.fn['codeium#CycleCompletions'](1) end, { expr = true })
      vim.keymap.set('i', '<c-,>', function() return vim.fn['codeium#CycleCompletions'](-1) end, { expr = true })
      vim.keymap.set('i', '<c-x>', function() return vim.fn['codeium#Clear']() end, { expr = true })
    end
  },
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v2.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
    config = function()
      require("neo-tree").setup({
        close_if_last_window = true,
        window = {
          width = 30,
        },
        buffers = {
          follow_current_file = true,
        },
        filesystem = {
          follow_current_file = true,
          filtered_items = {
            hide_dotfiles = false,
            hide_gitignored = false,
            hide_by_name = {
              "node_modules"
            },
            never_show = {
              ".DS_Store",
              "thumbs.db"
            },
          },
        },
      })
    end
  },
  { "folke/zen-mode.nvim", },
  -- {
  --   "ellisonleao/glow.nvim",
  --   config = function()
  --     require("glow").setup({
  --       install_path = "/usr/bin/glow", -- default path for installing glow binary
  --       width = 160,
  --       height = 300,
  --     })
  --   end
  -- }
}
