local keymap = vim.keymap.set

DefaultOpts = {
  noremap = true,
  silent = true,
}
-- Key disabler
lvim.keys.insert_mode = {
  ["<Up>"] = { "<NOP>", desc = "Disable arrow keys" },
  ["<Down>"] = { "<NOP>", desc = "Disable arrow keys" },
  ["<Left>"] = { "<NOP>", desc = "Disable arrow keys" },
  ["<Right>"] = { "<NOP>", desc = "Disable arrow keys" },
  ["<M-1>"] = { "<NOP>" }
}
lvim.keys.normal_mode = {
  ["<C-w><C-h>"] = { "<NOP>", desc = "Previous tab" },
  ["<C-w><C-l>"] = { "<NOP>", desc = "Next tab" },
  ["<C-w><C-t>"] = { "<NOP>", desc = "Open terminal" },
  ["<C-w><C-a>"] = { "<NOP>", desc = "Open new tab" },
  ["<C-w><C-q>"] = { "<NOP>", desc = "Close current tab" },
  ["<F1>"] = { "<NOP>", desc = "Help", DefaultOpts },
}

keymap("n", "<C-w><C-v>", "<NOP>", DefaultOpts)
keymap("n", "<C-w><C-s>", "<NOP>", DefaultOpts)
-- vim.api.nvim_del_keymap('n', '<C-w><C-v>')
-- -- Disable <C-w><C-s>
-- vim.api.nvim_del_keymap('n', '<C-w><C-s>')
-- vim.api.nvim_del_keymap('n', '<F1>')
-----------------------------------------------------------

-- Normal mode key mappings
lvim.keys.normal_mode = {
  -- NVIM management
  ["<C-x>"] = { ":qa<CR>", desc = "Close buffer", DefaultOpts },
  ["<C-q>"] = { ":q<CR>", desc = "Close buffer", DefaultOpts },
  ["<M-q>"] = { ":q<CR>", desc = "Close buffer", DefaultOpts },

  -- File operations
  ["<C-s>"] = { ":w<cr>", desc = "Save", DefaultOpts },
  ["<C-S-s>"] = { ":noa w<cr>", desc = "Save without formatting", DefaultOpts },

  -- Git integration
  ["<C-g>"] = { "<cmd>lua _lazygit_toggle()<CR>", desc = "Lazygit integration", DefaultOpts },

  -- Buffer navigation
  ["<S-l>"] = { ":BufferLineCycleNext<cr>", desc = "Next buffer", DefaultOpts },
  ["<S-h>"] = { ":BufferLineCyclePrev<cr>", desc = "Prev buffer", DefaultOpts },
  ["<C-p>"] = { "<cmd>Telescope find_files<CR>", desc = "Find files", DefaultOpts },
  ["<C-S-p>"] = { "<cmd>Telescope projects<CR>", desc = "Projects", DefaultOpts },
  ["F"] = { ":Telescope buffers<cr>", desc = "Search buffers", DefaultOpts },

  -- Tab management
  -- ["<C-w><C-h>"] = { ":tabp<cr>", desc = "Previous tab" },
  -- ["<C-w><C-l>"] = { ":tabn<cr>", desc = "Next tab" },
  -- ["<C-w><C-t>"] = { ":terminal<cr>", desc = "Open terminal" },
  -- ["<C-w><C-a>"] = { ":tabnew<cr>", desc = "Open new tab" },
  -- ["<C-w><C-q>"] = { ":tabc<cr>", desc = "Close current tab" },
  -- NOTE: currently trying to use C@M config
  -- Tab management
  ["<M-t>"] = { ":tabnew<cr>", desc = "Open new tab" },
  ["<M-w>"] = { ":tabc<cr>", desc = "Close current tab" },
  ["<M-r>"] = { ":terminal<cr>", desc = "Open terminal" },
  ["<M-h>"] = { ":tabp<cr>", desc = "Previous tab" },
  ["<M-l>"] = { ":tabn<cr>", desc = "Next tab" },
  -- Window
  ["<M-s>"] = { ":split<cr>", desc = "Split window" },
  ["<M-v>"] = { ":vsplit<cr>", desc = "Vsplit window" },

  -- Window resize
  ["<Up>"] = { ":resize +5<cr>", desc = "Upsize", DefaultOpts },
  ["<Down>"] = { ":resize -5<cr>", desc = "Downsize", DefaultOpts },
  ["<Left>"] = { ":vertical resize -5<cr>", desc = "Vertical resize -5", DefaultOpts },
  ["<Right>"] = { ":vertical resize +5<cr>", desc = "Vertical resize +5", DefaultOpts },

  -- Text and content manipulation
  ["<C-a>"] = { "ggVG", desc = "Select all", DefaultOpts },
  ["<M-CR>"] = { ":lua vim.lsp.buf.code_action()<CR>", desc = "Code action", DefaultOpts },

  -- HARPOON
  -- ["<C-h>"] = { ':lua require("harpoon.ui").toggle_quick_menu()<cr>' },
  [";r"] = { ':lua require("harpoon.ui").toggle_quick_menu()<cr>' },
  [";a"] = { ':lua require("harpoon.mark").add_file()<cr>' },
  [";s"] = { ":Telescope session-lens search_session<cr>", DefaultOpts },

  -- Others
  ["gR"] = { "<cmd>Trouble lsp_references<CR>", desc = "LSP References", DefaultOpts },
  ["f"] = { ":HopChar2<cr>", desc = "Hop", DefaultOpts },

  -- ["gl"] = { ":Glow<cr>", desc = "Glow - Markdown preview", DefaultOpts },
}

-- Insert mode key mappings
lvim.keys.insert_mode = {
  -- File operations
  ["<C-s>"] = { "<Esc>:w<CR>", desc = "Save while insert mode" },

  ["<C-c>"] = { "<Esc>", desc = "Exit insert mode" },

  -- Text manipulation
  ["<C-BS>"] = { "<C-w>", desc = "Ctrl Backspace" },
  ["<S-Tab>"] = { "<C-d>", desc = "Shift Tab" },

  -- Cursor movement
  ["<C-k>"] = { "<Up>", desc = "Move cursor up" },
  ["<C-h>"] = { "<Left>", desc = "Move cursor left" },
  ["<C-l>"] = { "<Right>", desc = "Move cursor right" },
  ["<C-j>"] = { "<Down>", desc = "Move cursor down" }
}


lvim.keys.visual_mode = {
  -- Better indenting
  ["<"] = { "<gv" },
  [">"] = { ">gv" },

  -- -- Paste most recent yank
  ["p"] = { '"0p', { silent = true } },
  ["P"] = { '"0P', { silent = true } },
}

lvim.keys.term_mode = {
  -- Terminal window navigation
  -- [";h"] = "<C-\\><C-N><C-w>h",
  -- [";j"] = "<C-\\><C-N><C-w>j",
  -- [";k"] = "<C-\\><C-N><C-w>k",
  -- [";l"] = "<C-\\><C-N><C-w>l",
  ["<C-h>"] = "<C-\\><C-N><C-w>h",
  ["<C-j>"] = "<C-\\><C-N><C-w>j",
  ["<C-k>"] = "<C-\\><C-N><C-w>k",
  ["<C-l>"] = "<C-\\><C-N><C-w>l",

  -- ToggleTerm
  ["<C-\\>"] = "<Cmd>ToggleTerm<CR>",

  -- Esc to normal mode
  ["<C-Space>"] = "<C-\\><C-n>",
  [";;"] = "<C-\\><C-n>",

  -- Movement
  ["<M-j>"] = "<Down>",
  ["<M-k>"] = "<Up>",
  ["<M-h>"] = "<Left>",
  ["<M-l>"] = "<Right>",
  ["<C-,>"] = "<C-Left>",
  ["<C-.>"] = "<C-Right>",

  -- Tab navigation
  ["<C-w><C-h>"] = "<Cmd>tabp<CR>",
  ["<C-w><C-l>"] = "<Cmd>tabn<CR>",
  ["<C-9>"] = "<Cmd>tabp<CR>",
  ["<C-0>"] = "<Cmd>tabn<CR>",
}

-- C@Machine config
local opts = DefaultOpts
keymap("n", "<m-h>", "<C-w>h", opts)
keymap("n", "<m-j>", "<C-w>j", opts)
keymap("n", "<m-k>", "<C-w>k", opts)
keymap("n", "<m-l>", "<C-w>l", opts)

-- keymap("n", "<c-j>", "<c-d>", opts)
-- keymap("n", "<c-k>", "<c-u>", opts)
keymap("n", "<c-m>", "<s-m>", opts)

keymap("n", "n", "nzz", opts)
keymap("n", "N", "Nzz", opts)
keymap("n", "*", "*zz", opts)
keymap("n", "#", "#zz", opts)
keymap("n", "g*", "g*zz", opts)
keymap("n", "g#", "g#zz", opts)

keymap("n", "<C-z>", "<cmd>ZenMode<cr>", opts)

keymap("n", "<m-f>", ":call QuickFixToggle()<cr>", opts)
keymap("n", "<C-i>", "<C-i>", opts)
