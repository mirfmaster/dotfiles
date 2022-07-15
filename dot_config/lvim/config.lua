--[[
lvim is the global options object

Linters should be
filled in as strings with either
a global executable or a path to
an executable
]]
-- general
lvim.log.level = "warn"
lvim.format_on_save = true
lvim.builtin.cmp.completion.keyword_length = 2

-- lvim.builtin.treesitter.highlight.enabled = true
-- lvim.builtin.nvimtree.setup.view.side = "right"
-- lvim.builtin.nvimtree.show_icons.git = 1
-- lvim.lsp.diagnostics.virtual_text = true
-- lvim.builtin.nvimtree.hide_dotfiles = 0
-- to disable icons and use a minimalist setup, uncomment the following
lvim.use_icons = true

-- unmap a default keymapping
-- vim.keymap.del("n", "<C-e>")

-- keymappings [view all the defaults by pressing <leader>Lk]
lvim.leader = "space"

-- add your own keymapping
lvim.keys.normal_mode["<C-s>"] = ":w<cr>"
lvim.keys.normal_mode["<C-q>"] = ":q<cr>]" -- or vim.keymap.set("n", "<C-q>", ":q<cr>" )
lvim.keys.normal_mode["S"] = ":%s//g<left><left>" -- Search/Replace

-- NAVIGATION TAB
lvim.keys.normal_mode["("] = ":bp<cr>"
lvim.keys.normal_mode[")"] = ":bn<cr>"
lvim.keys.normal_mode["<Tab>"] = ":bn<cr>"
lvim.keys.normal_mode["<S-Tab>"] = ":bp<cr>"
vim.api.nvim_set_keymap('n', '<C-a>', [[ggVG]], { noremap = true, silent = true })

-- NAVIGATION KEYS
vim.api.nvim_set_keymap('i', '<A-j>', [[<Down>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap('i', '<A-k>', [[<Up>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap('i', '<A-h>', [[<Left>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap('i', '<A-l>', [[<Right>]], { noremap = true, silent = true })

-- vim.api.nvim_set_keymap('n', '<C-e>', [[<End>]], { noremap = true, silent = true })
-- vim.api.nvim_set_keymap('n', '<C-b>', [[^]], { noremap = true, silent = true })
-- vim.api.nvim_set_keymap('n', '<C-e>', [[<Leader>e]], { noremap = true, silent = true })
lvim.keys.normal_mode["<C-e>"] = "<Leader>e"

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

-- lvim.keys.normal_mode["C-p"] = "<space>f"
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

lvim.builtin.lualine.style = "lvim" -- or "none"
-- TODO: User Config for predefined plugins
-- After changing plugin config exit and reopen LunarVim, Run :PackerInstall :PackerCompile
lvim.builtin.alpha.active = true
lvim.builtin.alpha.mode = "startify"
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

-- -- Prettier configuration
-- local formatters = require "lvim.lsp.null-ls.formatters"
-- vim.lsp.buf.formatting_sync(nil, 3000)
-- formatters.setup({
--   {
--     exe = "prettier",
--     filetypes = {
--       "javascriptreact",
--       "javascript",
--       "typescriptreact",
--       "typescript",
--       "json",
--       "html"
--     },
--   },
-- })
-- ESLint

-- local eslint = require("eslint")
-- eslint.setup({
--   bin = 'eslint', -- or `eslint_d`
--   code_actions = {
--     enable = true,
--     apply_on_save = {
--       enable = true,
--       types = { "problem" }, -- "directive", "problem", "suggestion", "layout"
--     },
--     disable_rule_comment = {
--       enable = true,
--       location = "separate_line", -- or `same_line`
--     },
--   },
--   diagnostics = {
--     enable = true,
--     report_unused_disable_directives = false,
--     run_on = "save", -- or `save`
--   },
-- })

-- THEME
-- lvim.colorscheme = "sonokai"
lvim.colorscheme = "onedarkpro"
-- lvim.colorscheme = "kanagawa"

-- Additional Plugins
lvim.plugins = {
  -- { "sainnhe/sonokai" },
  -- { "rebelot/kanagawa.nvim" },
  -- { 'MunifTanjim/eslint.nvim' },
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
  -- {
  --   "ray-x/lsp_signature.nvim",
  --   event = "BufRead",
  --   config = function() require "lsp_signature".on_attach() end,
  -- },
  -- {
  --   "sindrets/diffview.nvim",
  --   event = "BufRead",
  -- },
  -- {
  --   "f-person/git-blame.nvim",
  --   event = "BufRead",
  --   config = function()
  --     vim.cmd "highlight default link gitblame SpecialComment"
  --     vim.g.gitblame_enabled = 1
  --   end,
  -- },
}
