-- general
lvim.log.level = "warn"
lvim.format_on_save = true
lvim.builtin.cmp.completion.keyword_length = 2
lvim.builtin.nvimtree.hide_dotfiles = false
-- lvim.builtin.alpha.startify.config
lvim.lsp.diagnostics.virtual_text = false
-- to disable icons and use a minimalist setup, uncomment the following
lvim.use_icons = true

-- unmap a default keymapping
-- vim.keymap.del("n", "<C-S>")

-- keymappings [view all the defaults by pressing <leader>Lk]
lvim.leader = "space"

-- add your own keymapping
lvim.keys.normal_mode["<C-s>"] = ":w<cr>"
-- lvim.keys.normal_mode["<C-W>"] = ":noa w<cr>"
lvim.keys.normal_mode["<C-x>"] = ":qa!<cr>]" -- or vim.keymap.set("n", "<C-q>", ":q<cr>" )
lvim.keys.normal_mode["<C-q>"] = ":q<cr>"

-- UTILITY
lvim.keys.normal_mode["<A-r>"] = ":%s//g<left><left>" -- Search/Replace
vim.api.nvim_set_keymap('i', '<C-s>', [[<Esc><C-s>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-a>', [[ggVG]], { noremap = true, silent = true })

-- NAVIGATION TAB
lvim.keys.normal_mode["("] = ":bp<cr>"
lvim.keys.normal_mode[")"] = ":bn<cr>"
lvim.keys.normal_mode["<Tab>"] = ":bn<cr>"
lvim.keys.normal_mode["<S-Tab>"] = ":bp<cr>"
lvim.keys.normal_mode["<C-S-p>"] = ":Telescope command_center<cr>"

-- NAVIGATION KEYS
vim.api.nvim_set_keymap('i', '<A-k>', [[<Up>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap('i', '<A-h>', [[<Left>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap('i', '<A-l>', [[<Right>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap('i', '<A-j>', [[<Down>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<S-b>', [[^]], { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<S-e>', [[$]], { noremap = true, silent = true })

-- override a default keymapping
-- vim.api.nvim_set_keymap("n", "<C-p>", [[<Cmd>Telescope find_files<cr>]], { noremap = true, silent = true, expr = true })
-- Change Telescope navigation to use j and k for navigation and n and p for history in both input and normal mode.
-- we use protected-mode (pcall) just in case the plugin wasn't loaded yet.
local _, actions = pcall(require, "telescope.actions")
lvim.builtin.telescope.defaults.mappings = {
  -- for input mode
  i = {
    ["<C-j>"] = actions.move_selection_next,
    ["<C-k>"] = actions.move_selection_previous,
    ["<C-n>"] = actions.cycle_history_next,
    ["<C-p>"] = actions.cycle_history_prev,
  },
  -- for normal mode"
  n = {
    ["<C-j>"] = actions.move_selection_next,
    ["<C-k>"] = actions.move_selection_previous,
  },
}

-- Use which-key to add extra bindings with the leader-key prefix
lvim.builtin.which_key.mappings["P"] = { "<cmd>Telescope projects<cr>", "Projects" }
lvim.builtin.which_key.mappings["t"] = {
  name = "+Trouble",
  r = { "<cmd>Trouble lsp_references<cr>", "References" },
  f = { "<cmd>Trouble lsp_definitions<cr>", "Definitions" },
  d = { "<cmd>Trouble document_diagnostics<cr>", "Diagnostics" },
  q = { "<cmd>Trouble quickfix<cr>", "QuickFix" },
  l = { "<cmd>Trouble loclist<cr>", "LocationList" },
  w = { "<cmd>Trouble workspace_diagnostics<cr>", "Wordspace Diagnostics" },
}
lvim.builtin.which_key.mappings["T"] = {
  name = "+T Keyword",
  W = { "<cmd>Twilight<cr>", "Twilight Toggle" },
  D = { "<cmd>TwilightDisable<cr>", "Twilight Disable" },
  E = { "<cmd>TwilightEnable<cr>", "Twilight Enable" },
  T = { "<cmd>TodoTrouble<cr>", "Todo Trouble" },
}
lvim.builtin.which_key.mappings["S"] = {
  name = "Session",
  c = { "<cmd>lua require('persistence').load()<cr>", "Restore last session for current dir" },
  l = { "<cmd>lua require('persistence').load({ last = true })<cr>", "Restore last session" },
  Q = { "<cmd>lua require('persistence').stop()<cr>", "Quit without saving session" },
}

lvim.builtin.lualine.style = "lvim" -- or "none"
-- TODO: User Config for predefined plugins
-- After changing plugin config exit and reopen LunarVim, Run :PackerInstall :PackerCompile
lvim.builtin.alpha.active = true
lvim.builtin.alpha.mode = "dashboard"
lvim.builtin.notify.active = true
lvim.builtin.terminal.active = true

-- if you don't want all the parsers change this to a table of the ones you want
-- lvim.builtin.treesitter.ensure_installed = {
--   "javascript",
--   "lua",
--   "typescript",
--   "tsx",
--   "css",
--   "yaml",
--   "php"
-- }
lvim.builtin.treesitter.highlight.enabled = false

-- THEME
lvim.colorscheme = "tokyonight"
vim.g.tokyonight_style = "night"
vim.g.tokyonight_colors = { hint = "orange", error = "#ff0000", }
-- lvim.colorscheme = "onedarkpro"

-- Additional Plugins
lvim.plugins = {
  { 'folke/tokyonight.nvim', },
  {
    "olimorris/onedarkpro.nvim",
    config = function()
      require("onedarkpro").setup()
    end
  },
  { "psliwka/vim-smoothie" },
  {
    "folke/trouble.nvim",
    requires = "kyazdani42/nvim-web-devicons"
  },
  { 'mg979/vim-visual-multi' },
  { 'neoclide/coc.nvim', branch = 'release' },
  { "lukas-reineke/indent-blankline.nvim" },
  { 'farmergreg/vim-lastplace' },
  { "folke/twilight.nvim" },
  {
    "folke/persistence.nvim",
    event = "BufReadPre", -- this will only start session saving when an actual file was opened
    module = "persistence",
    config = function()
      require("persistence").setup {
        dir = vim.fn.expand(vim.fn.stdpath "config" .. "/session/"),
        options = { "buffers", "curdir", "tabpages", "winsize" },
      }
    end,
  },
  {
    "folke/todo-comments.nvim",
    requires = "nvim-lua/plenary.nvim",
    event = "BufRead",
    config = function()
      require("todo-comments").setup()
    end
  }
}
