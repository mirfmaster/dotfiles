-- INIT
vim.cmd "autocmd! TermOpen term://* lua set_terminal_keymaps()"
local Terminal = require("toggleterm.terminal").Terminal
local lazygit = Terminal:new { cmd = "lazygit", hidden = true }

function _lazygit_toggle() lazygit:toggle() end

-- general
lvim.leader = "space"
lvim.log.level = "warn"
lvim.format_on_save.enabled = true

vim.opt.relativenumber = true
vim.opt.wrap = true

-- add your own keymapping
lvim.keys.normal_mode["<C-s>"] = ":w<cr>"
lvim.keys.normal_mode["<S-l>"] = ":BufferLineCycleNext<CR>"
lvim.keys.normal_mode["<S-h>"] = ":BufferLineCyclePrev<CR>"
-- lvim.keys.normal_mode["<S-j>"] = ":tabprev<CR>"
-- lvim.keys.normal_mode["<S-k>"] = ":tabnext<CR>"
-- lvim.keys.normal_mode["<S-h>"] = ":tabmove -1<CR>"
-- lvim.keys.normal_mode["<S-l>"] = ":tabmove +1<CR>"
local map = vim.api.nvim_set_keymap
-- BIND NEW KEYMAPS
-- UTILITIES
map("i", "<C-s>", [[<Esc><C-s>]], { noremap = true, silent = true })
map("n", "<S-s>", ":noa w<cr>", { noremap = true, silent = true, desc = 'Save without formatting' })
map("n", "<A-s>", ":noa w<cr>", { noremap = true, silent = true, desc = 'Save without formatting' })
map("i", "<C-c>", [[<Esc>]], { noremap = true, silent = true })
map("n", "<C-a>", [[ggVG]], { noremap = true, silent = true })
map("i", "<C-BS>", [[<C-w>]], { noremap = true, silent = false, desc = 'Ctrl Backspace' })
map("n", "<C-a>", [[ggVG]], { noremap = true, silent = true })
map("n", "<C-p>", ":Telescope session-lens search_session<cr>", { noremap = true, silent = true, desc = 'Open session' })
map("i", "<S-Tab>", [[<C-d>]], { noremap = true, silent = false })

-- map("n", "<f8>", ":cprev<cr>", { desc = "Previous item in quickfix list" })
-- map("n", "<f9>", ":cnext<cr>", { desc = "Next item in quickfix list" })
map("n", "<M-CR>", ":lua vim.lsp.buf.code_action()<CR>", {})
-- map("n", "<leader>qf", ":lua hu_toggle_qf()<cr>", { desc = "Toggle quickfix list" })

-- Navigation tab
-- map("n", "<C-w><C-t>", ":tabnew<cr>", { desc = "Open new tab (?)" })
-- map("n", "<C-w><C-q>", ":tabc<cr>", { desc = "Close current tab" })
map("n", "<C-w><C-h>", ":tabp<cr>", { desc = "Prevous tab" })
map("n", "<C-w><C-l>", ":tabn<cr>", { desc = "Next tab" })

map("n", "<C-w><C-t>", ":terminal<cr>", { desc = "Make it as terminal" })
map("n", "<C-w><C-a>", ":tabnew<cr>", { desc = "Open new tab (?)" })
map("n", "<C-w><C-q>", ":tabc<cr>", { desc = "Close current tab" })
map("n", "<C-9>", ":tabp<cr>", { desc = "Prevous tab" })
map("n", "<C-0>", ":tabn<cr>", { desc = "Next tab" })

-- NAVIGATION KEYS
map("i", "<C-k>", [[<Up>]], { noremap = true, silent = true })
map("i", "<C-h>", [[<Left>]], { noremap = true, silent = true })
map("i", "<C-l>", [[<Right>]], { noremap = true, silent = true })
map("i", "<C-j>", [[<Down>]], { noremap = true, silent = true })

map("n", "<S-b>", [[^]], { noremap = true, silent = true })
map("n", "<S-e>", [[$]], { noremap = true, silent = true })
-- map("n", "F", ":HopChar2<cr>", { silent = true })
map("n", "f", ":HopChar2<cr>", { silent = true })
-- map("n", "f", ":HopWord<cr>", { silent = true })

-- map('n', '<C-p>', ":lua require'telescope'.extensions.project.project{}<CR>", { noremap = true, silent = true })

-- TERMINAL
map("n", "<C-g>", "<cmd>lua _lazygit_toggle()<CR>",
    { noremap = true, silent = true, desc = 'Lazygit terminal integration' })

map("n", "<C-t>", [[:ToggleTerm<cr>]], { noremap = true, silent = true })
-- map("n", "<C-t><C-k>", [[:ToggleTerm direction=float<cr>]], { noremap = true, silent = true })
-- map("n", "<C-t><C-k>", [[:ToggleTerm direction=horizontal<cr>]], { noremap = true, silent = true })
-- map("n", "<C-t><C-l>", [[:ToggleTerm direction=vertical size=80<cr>]], { noremap = true, silent = true })

-- TOGGLETERM
function _G.set_terminal_keymaps()
  local opts = { buffer = 0 }
  vim.keymap.set("t", "<C-t>", [[<Cmd>ToggleTerm<CR>]], opts)

  vim.keymap.set("t", "<C-Space>", [[<C-\><C-n>]], opts) -- esc to normal mode
  vim.keymap.set("t", "<C-j>", [[<Down>]], opts)
  vim.keymap.set("t", "<C-k>", [[<Up>]], opts)
  -- vim.keymap.set("t", "<C-h>", [[<Cmd>wincmd h<CR>]], opts)
  -- vim.keymap.set("t", "<C-j>", [[<Cmd>wincmd j<CR>]], opts)
  -- vim.keymap.set("t", "<C-k>", [[<Cmd>wincmd k<CR>]], opts)
  -- vim.keymap.set("t", "<C-l>", [[<Cmd>wincmd l<CR>]], opts)
  -- vim.keymap.set("t", "<S-h>", [[<Cmd>BufferLineCyclePrev<CR>]], opts)
  -- vim.keymap.set("t", "<S-l>", [[<Cmd>BufferLineCycleNext<CR>]], opts)

  vim.keymap.set("t", "<C-w><C-h>", [[<Cmd>tabp<cr>]], opts)
  vim.keymap.set("t", "<C-w><C-l>", [[<Cmd>tabn<cr>]], opts)

  vim.keymap.set("t", "<C-9>", [[<Cmd>tabp<cr>]], opts)
  vim.keymap.set("t", "<C-0>", [[<Cmd>tabn<cr>]], opts)
end

-- unmap a default keymapping
-- vim.keymap.del("n", "")
-- override a default keymapping
lvim.keys.normal_mode["<C-q>"] = ":q<cr>" -- or vim.keymap.set("n", "<C-q>", ":q<cr>" )

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
    -- for normal mode
    n = {
        ["<C-j>"] = actions.move_selection_next,
        ["<C-k>"] = actions.move_selection_previous,
    },
}

-- Use which-key to add extra bindings with the leader-key prefix
lvim.builtin.which_key.mappings["P"] = { "<cmd>Telescope projects<CR>", "Projects" }
lvim.builtin.which_key.mappings["t"] = {
    name = "+Trouble",
    r = { "<cmd>Trouble lsp_references<cr>", "References" },
    f = { "<cmd>Trouble lsp_definitions<cr>", "Definitions" },
    d = { "<cmd>Trouble document_diagnostics<cr>", "Diagnostics" },
    q = { "<cmd>Trouble quickfix<cr>", "QuickFix" },
    l = { "<cmd>Trouble loclist<cr>", "LocationList" },
    w = { "<cmd>Trouble workspace_diagnostics<cr>", "Workspace Diagnostics" },
    t = { "<cmd>TodoTelescope<cr>", "Workspace TODO" },
}
lvim.builtin.which_key.mappings['h'] = {}
lvim.builtin.which_key.mappings[';'] = {}
lvim.builtin.which_key.mappings[";"] = {
    name = "+Harpoon",
    a = { ":lua require('harpoon.mark').add_file()<cr>", "Add Mark File" },
    d = { ":lua require('harpoon.mark').delete_file()<cr>", "Delete Mark File" },
    [";"] = { ":lua require('harpoon.ui').toggle_quick_menu()<cr>", "Toggle Quick Menu" },
}

-- TODO: User Config for predefined plugins
-- After changing plugin config exit and reopen LunarVim, Run :PackerInstall :PackerCompile
lvim.builtin.alpha.active = true
lvim.builtin.alpha.mode = "dashboard"
lvim.builtin.terminal.active = true
lvim.builtin.nvimtree.setup.view.side = "left"
lvim.builtin.nvimtree.setup.renderer.icons.show.git = false

-- if you don't want all the parsers change this to a table of the ones you want
lvim.builtin.treesitter.ensure_installed = {
    "bash",
    "c",
    "javascript",
    "json",
    "lua",
    "typescript",
    "tsx",
    "css",
    "yaml",
}

lvim.builtin.treesitter.ignore_install = { "haskell" }
lvim.builtin.treesitter.highlight.enable = true

-- generic LSP settings

-- -- make sure server will always be installed even if the server is in skipped_servers list
-- lvim.lsp.installer.setup.ensure_installed = {
--     "sumneko_lua",
--     "jsonls",
-- }
-- -- change UI setting of `LspInstallInfo`
-- -- see <https://github.com/williamboman/nvim-lsp-installer#default-configuration>
-- lvim.lsp.installer.setup.ui.check_outdated_servers_on_open = false
-- lvim.lsp.installer.setup.ui.border = "rounded"
-- lvim.lsp.installer.setup.ui.keymaps = {
--     uninstall_server = "d",
--     toggle_server_expand = "o",
-- }

-- ---@usage disable automatic installation of servers
-- lvim.lsp.installer.setup.automatic_installation = false

-- -- set a formatter, this will override the language server formatting capabilities (if it exists)
local formatters = require "lvim.lsp.null-ls.formatters"
formatters.setup {
    {
        -- command = "eslint_d",
        exe = "prettierd",
        filetypes = {
            "javascriptreact",
            "javascript",
            "typescriptreact",
            "typescript",
            "json",
            "html"
        },
    },
}

-- -- set additional linters
local linters = require "lvim.lsp.null-ls.linters"
linters.setup {
    { command = "eslint" },
}

-- Autosession
vim.opt.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal"

-- Theme
lvim.colorscheme = "tokyonight-moon"
-- lvim.colorscheme = "tokyodark"
-- vim.colorscheme = "substrata"
-- lvim.colorscheme = "carbonfox"

-- lvim.colorscheme = "nordfox"
-- lvim.colorscheme = "vn-night"

-- Additional Plugins
lvim.plugins = {
    -- COLORSCHEME
    -- ref: https://github.com/rockerBOO/awesome-neovim#colorscheme
    { 'tiagovla/tokyodark.nvim' },
    { 'kvrohit/substrata.nvim' },
    { "EdenEast/nightfox.nvim" },
    { 'nxvu699134/vn-night.nvim' },
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
        requires = { 'rmagatti/auto-session', 'nvim-telescope/telescope.nvim' },
        config = function()
          require('session-lens').setup {
              -- path_display = { 'shorten' },
              previewer = true
          }
        end
    },
    {
        "nvim-telescope/telescope-project.nvim",
        event = "BufWinEnter",
        setup = function()
          vim.cmd [[packadd telescope.nvim]]
        end,
    },
    {
        "folke/todo-comments.nvim",
        requires = "nvim-lua/plenary.nvim",
        config = function()
          require("todo-comments").setup {
              -- your configuration comes here
              -- or leave it empty to use the default settings
              -- refer to the configuration section below
          }
        end
    },
    { 'godlygeek/tabular', },
    -- { 'ThePrimeagen/harpoon' },
    {
        'Exafunction/codeium.vim',
        config = function()
          -- Change '<C-g>' here to any keycode you like.
          vim.keymap.set('i', '<c-;>', function() return vim.fn['codeium#Accept']() end, { expr = true })
          vim.keymap.set('i', '<c-.>', function() return vim.fn['codeium#CycleCompletions'](1) end, { expr = true })
          vim.keymap.set('i', '<c-,>', function() return vim.fn['codeium#CycleCompletions']( -1) end, { expr = true })
          vim.keymap.set('i', '<c-x>', function() return vim.fn['codeium#Clear']() end, { expr = true })
        end
    }
}
