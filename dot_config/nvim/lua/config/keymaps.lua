-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local harpoon = require("harpoon")

vim.keymap.set("n", "<leader>ha", function() harpoon.mark.add_file() end, { desc = "Harpoon add file" })
vim.keymap.set("n", "<leader>hh", function() harpoon.ui.toggle_quick_menu() end, { desc = "Harpoon menu" })
vim.keymap.set("n", "<leader>h1", function() harpoon.ui.nav_file(1) end, { desc = "Harpoon nav file 1" })
vim.keymap.set("n", "<leader>h2", function() harpoon.ui.nav_file(2) end, { desc = "Harpoon nav file 2" })
vim.keymap.set("n", "<leader>h3", function() harpoon.ui.nav_file(3) end, { desc = "Harpoon nav file 3" })
vim.keymap.set("n", "<leader>h4", function() harpoon.ui.nav_file(4) end, { desc = "Harpoon nav file 4" })
vim.keymap.set("n", "<leader>hj", function() harpoon.ui.nav_next() end, { desc = "Harpoon nav next" })
vim.keymap.set("n", "<leader>hk", function() harpoon.ui.nav_prev() end, { desc = "Harpoon nav prev" })
