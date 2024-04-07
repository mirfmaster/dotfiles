local keymap = vim.keymap.set

local defaultOpts = {
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
}

keymap("n", "<C-w><C-v>", "<NOP>", defaultOpts)
keymap("n", "<C-w><C-s>", "<NOP>", defaultOpts)
keymap("n", "<F1>", "<NOP>", defaultOpts)
-----------------------------------------------------------

-- Normal mode key mappings
lvim.keys.normal_mode = {
  -- NVIM management
  ["<C-x>"] = { ":qa<CR>", desc = "Close buffer", defaultOpts },
  ["<C-q>"] = { ":q<CR>", desc = "Close buffer", defaultOpts },
  ["<M-q>"] = { ":q<CR>", desc = "Close buffer", defaultOpts },

  -- File operations
  ["<C-s>"] = { ":w<cr>", desc = "Save", defaultOpts },
  ["<C-S-s>"] = { ":noa w<cr>", desc = "Save without formatting", defaultOpts },

  -- Git integration
  ["<C-g>"] = { "<cmd>lua _lazygit_toggle()<CR>", desc = "Lazygit integration", defaultOpts },

  -- Buffer navigation
  ["<S-l>"] = { ":BufferLineCycleNext<cr>", desc = "Next buffer", defaultOpts },
  ["<S-h>"] = { ":BufferLineCyclePrev<cr>", desc = "Prev buffer", defaultOpts },
  ["<C-p>"] = { "<cmd>Telescope find_files<CR>", desc = "Find files", defaultOpts },
  ["<C-S-p>"] = { "<cmd>Telescope projects<CR>", desc = "Projects", defaultOpts },
  ["F"] = { ":Telescope buffers<cr>", desc = "Search buffers", defaultOpts },

  -- Tab management
  -- ["<C-w><C-h>"] = { ":tabp<cr>", desc = "Previous tab" },
  -- ["<C-w><C-l>"] = { ":tabn<cr>", desc = "Next tab" },
  -- ["<C-w><C-t>"] = { ":terminal<cr>", desc = "Open terminal" },
  -- ["<C-w><C-a>"] = { ":tabnew<cr>", desc = "Open new tab" },
  -- ["<C-w><C-q>"] = { ":tabc<cr>", desc = "Close current tab" },
  -- NOTE: currently trying to use C@M config
  -- Tab management
  ["<M-t>"] = { ":tabnew<cr>", desc = "Open new tab", defaultOpts },
  ["<M-w>"] = { ":tabc<cr>", desc = "Close current tab", defaultOpts },
  ["<M-r>"] = { ":terminal<cr>", desc = "Open terminal", defaultOpts },
  ["<M-h>"] = { ":tabp<cr>", desc = "Previous tab", defaultOpts },
  ["<M-l>"] = { ":tabn<cr>", desc = "Next tab", defaultOpts },
  -- Window
  ["<M-s>"] = { ":split<cr>", desc = "Split window" },
  ["<M-v>"] = { ":vsplit<cr>", desc = "Vsplit window" },

  -- Window resize
  ["<Up>"] = { ":resize +5<cr>", desc = "Upsize", defaultOpts },
  ["<Down>"] = { ":resize -5<cr>", desc = "Downsize", defaultOpts },
  ["<Left>"] = { ":vertical resize -5<cr>", desc = "Vertical resize -5", defaultOpts },
  ["<Right>"] = { ":vertical resize +5<cr>", desc = "Vertical resize +5", defaultOpts },

  -- Text and content manipulation
  ["<C-a>"] = { "ggVG", desc = "Select all", defaultOpts },
  ["<M-CR>"] = { ":lua vim.lsp.buf.code_action()<CR>", desc = "Code action", defaultOpts },

  -- HARPOON
  [";r"] = { ':lua require("harpoon.ui").toggle_quick_menu()<cr>', defaultOpts },
  [";a"] = { ':lua require("harpoon.mark").add_file()<cr>', defaultOpts },
  [";s"] = { ":Telescope session-lens search_session<cr>", defaultOpts },

  -- Others
  ["gR"] = { "<cmd>Trouble lsp_references<CR>", desc = "LSP References", defaultOpts },
  ["f"] = { ":HopChar2<cr>", desc = "Hop", defaultOpts },

  -- ["gl"] = { ":Glow<cr>", desc = "Glow - Markdown preview", defaultOpts },
}

-- Insert mode key mappings
lvim.keys.insert_mode = {
  -- File operations
  ["<C-s>"] = { "<Esc>:w<CR>", desc = "Save while insert mode", defaultOpts },

  ["<C-c>"] = { "<Esc>", desc = "Exit insert mode", defaultOpts },

  -- Text manipulation
  ["<C-BS>"] = { "<C-w>", desc = "Ctrl Backspace", defaultOpts },
  ["<S-Tab>"] = { "<C-d>", desc = "Shift Tab", defaultOpts },

  -- Cursor movement
  ["<C-k>"] = { "<Up>", desc = "Move cursor up", defaultOpts },
  ["<C-h>"] = { "<Left>", desc = "Move cursor left", defaultOpts },
  ["<C-l>"] = { "<Right>", desc = "Move cursor right", defaultOpts },
  ["<C-j>"] = { "<Down>", desc = "Move cursor down", defaultOpts }
}


lvim.keys.visual_mode = {
  -- Better indenting
  ["<"] = { "<gv", defaultOpts },
  [">"] = { ">gv", defaultOpts },

  -- -- Paste most recent yank
  ["p"] = { '"0p', defaultOpts },
  ["P"] = { '"0P', defaultOpts },
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
keymap("n", "<m-h>", "<C-w>h", defaultOpts)
keymap("n", "<m-j>", "<C-w>j", defaultOpts)
keymap("n", "<m-k>", "<C-w>k", defaultOpts)
keymap("n", "<m-l>", "<C-w>l", defaultOpts)

-- keymap("n", "<c-j>", "<c-d>", defaultOpts)
-- keymap("n", "<c-k>", "<c-u>", defaultOpts)
keymap("n", "<c-m>", "<s-m>", defaultOpts)

keymap("n", "n", "nzz", defaultOpts)
keymap("n", "N", "Nzz", defaultOpts)
keymap("n", "*", "*zz", defaultOpts)
keymap("n", "#", "#zz", defaultOpts)
keymap("n", "g*", "g*zz", defaultOpts)
keymap("n", "g#", "g#zz", defaultOpts)

keymap("n", "<C-z>", "<cmd>ZenMode<cr>", defaultOpts)

keymap("n", "<m-f>", ":call QuickFixToggle()<cr>", defaultOpts)
keymap("n", "<C-i>", "<C-i>", defaultOpts)
