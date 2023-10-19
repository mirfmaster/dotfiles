-- INIT
vim.cmd "autocmd! TermOpen term://* lua set_terminal_keymaps()"
local map = vim.api.nvim_set_keymap
local Terminal = require("toggleterm.terminal").Terminal
local lazygit = Terminal:new { cmd = "lazygit", hidden = true, direction = "float" }

---@diagnostic disable-next-line: lowercase-global
function _lazygit_toggle() lazygit:toggle() end

map("n", "<C-g>", "<cmd>lua _lazygit_toggle()<CR>", { noremap = true, silent = true, desc = 'Lazygit integration' })

-- GLOBAL GENERAL CONFIG
lvim.leader = "space"
lvim.log.level = "warn"
lvim.format_on_save.enabled = true

vim.opt.relativenumber = true
vim.opt.wrap = true

vim.g.codeium_no_map_tab = true

-- BIND NEW KEYMAPS
-- UTILITIES
map("i", "<C-s>", [[<Esc><C-s>]], { noremap = true, silent = true, desc = "Save" })
map("i", "<C-c>", [[<Esc>]], { noremap = true, silent = true, desc = "Exit insert mode" })
map("i", "<C-BS>", [[<C-w>]], { noremap = true, silent = false, desc = 'Ctrl Backspace' })
map("i", "<S-Tab>", [[<C-d>]], { noremap = true, silent = false })

map("n", "<C-s>", ":w<cr>", { noremap = true, silent = true, desc = "Save" })
map("n", "<S-l>", ":BufferLineCycleNext<cr>", { noremap = true, silent = true, desc = "Next buffer" })
map("n", "<S-h>", ":BufferLineCyclePrev<cr>", { noremap = true, silent = true, desc = "Prev buffer" })
map("n", "<S-s>", ":noa w<cr>", { noremap = true, silent = true, desc = 'Save without formatting' })
map("n", "<A-s>", ":noa w<cr>", { noremap = true, silent = true, desc = 'Save without formatting' })

-- doesnt seems work on alacritty
map("n", "<C-.>", ":Telescope session-lens search_session<cr>", { noremap = true, silent = true, desc = 'Open session' })
map("n", "<C-a>", [[ggVG]], { noremap = true, silent = true, desc = "Select all" })
map("n", "<M-CR>", ":lua vim.lsp.buf.code_action()<CR>", { desc = "Code action, <Alt-Enter> to use" })
map("n", "<C-p>", "<cmd>Telescope find_files<CR>", { noremap = true, silent = true })
map("n", "<C-S-p>", "<cmd>Telescope projects<CR>", { noremap = true, silent = true })
-- map("n", "<leader>qf", ":lua hu_toggle_qf()<cr>", { desc = "Toggle quickfix list" })

-- Navigation tab
-- map("n", "<C-w><C-t>", ":tabnew<cr>", { desc = "Open new tab (?)" })
-- map("n", "<C-w><C-q>", ":tabc<cr>", { desc = "Close current tab" })
map("n", "<C-w><C-h>", ":tabp<cr>", { noremap = true, silent = true, desc = "Prevous tab" })
map("n", "<C-w><C-l>", ":tabn<cr>", { noremap = true, silent = true, desc = "Next tab" })

map("n", "<C-w><C-t>", ":terminal<cr>", { noremap = true, silent = true, desc = "Make it as terminal" })
map("n", "<C-w><C-a>", ":tabnew<cr>", { noremap = true, silent = true, desc = "Open new tab (?)" })
map("n", "<C-w><C-q>", ":tabc<cr>", { noremap = true, silent = true, desc = "Close current tab" })
map("n", "<C-9>", ":tabp<cr>", { noremap = true, silent = true, desc = "Prevous tab" })
map("n", "<C-0>", ":tabn<cr>", { noremap = true, silent = true, desc = "Next tab" })

-- NAVIGATION KEYS
map("i", "<C-k>", [[<Up>]], { noremap = true, silent = true, desc = "Equivalent arrow Up" })
map("i", "<C-h>", [[<Left>]], { noremap = true, silent = true, desc = "Equivalent arrow Left" })
map("i", "<C-l>", [[<Right>]], { noremap = true, silent = true, desc = "Equivalent arrow Right" })
map("i", "<C-j>", [[<Down>]], { noremap = true, silent = true, desc = "Equivalent arrow Down" })

map("n", "<S-b>", [[^]], { noremap = true, silent = true, desc = "Go to beginning" })
map("n", "<S-e>", [[$]], { noremap = true, silent = true, desc = "Go to end" })

map("n", "f", ":HopChar2<cr>", { noremap = true, silent = true, desc = "Hop char" })
map("n", "F", ":Telescope buffers<cr>", { noremap = true, silent = true, desc = "Search buffers" })

-- HARPOON
-- lvim.lsp.buffer_mappings.normal_mode[';'] = nil
lvim.keys.normal_mode[';'] = ':lua require("harpoon.ui").toggle_quick_menu()<cr>'
map("n", "<A-1>", ":lua require(\"harpoon.ui\").nav_file(1)<cr>", { noremap = true, silent = true })
map("n", "<A-2>", ":lua require(\"harpoon.ui\").nav_file(2)<cr>", { noremap = true, silent = true })
map("n", "<A-3>", ":lua require(\"harpoon.ui\").nav_file(3)<cr>", { noremap = true, silent = true })
map("n", "<A-4>", ":lua require(\"harpoon.ui\").nav_file(4)<cr>", { noremap = true, silent = true })
map("n", "<A-a>", ":lua require(\"harpoon.mark\").add_file()<cr>", { noremap = true, silent = true })
map("n", "<A-k>", ":lua require(\"harpoon.ui\").nav_prev()<cr>", { noremap = true, silent = true })
map("n", "<A-j>", ":lua require(\"harpoon.ui\").nav_next()<cr>", { noremap = true, silent = true })

-- TERMINAL

map("n", "<C-t>", [[:ToggleTerm direction=float size=100<cr>]], { noremap = true, silent = true })
-- map("n", "<F3>", [[:ToggleTerm direction=vertical size=200<cr>]], { noremap = true, silent = true })

-- TOGGLETERM
function _G.set_terminal_keymaps()
  local opts = { buffer = 0 }
  vim.keymap.set("t", "<C-t>", [[<Cmd>ToggleTerm<CR>]], opts)
  vim.keymap.set("t", "<F3>", [[<Cmd>ToggleTerm<CR>]], opts)

  vim.keymap.set("t", "<C-Space>", [[<C-\><C-n>]], opts) -- esc to normal mode
  vim.keymap.set("t", "<C-;>", [[<C-\><C-n>]], opts)     -- esc to normal mode
  vim.keymap.set("t", "<C-j>", [[<Down>]], opts)
  vim.keymap.set("t", "<C-k>", [[<Up>]], opts)
  vim.keymap.set("t", "<C-h>", [[<Left>]], opts)
  vim.keymap.set("t", "<C-l>", [[<Right>]], opts)
  vim.keymap.set("t", "<C-,>", [[<C-Left>]], opts)
  vim.keymap.set("t", "<C-.>", [[<C-Right>]], opts)

  vim.keymap.set("t", "<C-w><C-h>", [[<Cmd>tabp<cr>]], opts)
  vim.keymap.set("t", "<C-w><C-l>", [[<Cmd>tabn<cr>]], opts)

  vim.keymap.set("t", "<C-9>", [[<Cmd>tabp<cr>]], opts)
  vim.keymap.set("t", "<C-0>", [[<Cmd>tabn<cr>]], opts)
end

-- unmap a default keymapping
-- vim.keymap.del("n", "")
-- override a default keymapping
lvim.keys.normal_mode["<C-x>"] = ":qa<cr>"
lvim.keys.normal_mode["<C-q>"] = ":q<cr>"

-- TELESCOPE ACTIONS
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
-- lvim.builtin.which_key.mappings['h'] = {}
-- lvim.builtin.which_key.mappings[';'] = {}
-- lvim.builtin.which_key.mappings["h"] = {
--   name = "+Harpoon",
--   a = { ":lua require('harpoon.mark').add_file()<cr>", "Add Mark File" },
--   x = { ":lua require('harpoon.mark').delete_file()<cr>", "Delete Mark File" },
--   h = { ":lua require('harpoon.ui').toggle_quick_menu()<cr>", "Toggle Quick Menu" },
-- }

-- TODO: User Config for predefined plugins
-- After changing plugin config exit and reopen LunarVim, Run :PackerInstall :PackerCompile
lvim.builtin.alpha.active = true
lvim.builtin.alpha.mode = "dashboard"
lvim.builtin.terminal.active = true

local gwidth = vim.api.nvim_list_uis()[1].width
local gheight = vim.api.nvim_list_uis()[1].height
local width = 100
local height = 60
lvim.builtin.nvimtree.setup.view = {
  width = width,
  hide_root_folder = false,
  number = false,
  relativenumber = false,
  signcolumn = "yes",
  -- height = height,
  mappings = {
    custom_only = false,
    list = {},
  },
  float = {
    enable = true,
    open_win_config = {
      relative = "editor",
      width = width,
      height = height,
      row = (gheight - height) * 0.4,
      col = (gwidth - width) * 0.5,
    }
  }
}


lvim.builtin.nvimtree.setup.renderer.icons.show.git = false

lvim.builtin.treesitter.ensure_installed = {
  "javascript",
  "json",
  "typescript",
  "tsx",
  "css",
  "yaml",
}

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
    command = "eslint_d",
    exe = "prettierd",
    -- command = "rome",
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
  { command = "eslint_d" },
}

-- Autosession
vim.opt.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal"

-- Theme
lvim.colorscheme = "tokyonight-moon"
-- lvim.colorscheme = "tokyonight"
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
}
