return {
  "christoomey/vim-tmux-navigator",
  lazy = false,
  event = "VeryLazy",
  keys = {
    { "<C-h>", "<cmd> TmuxNavigateLeft<cr>", mode = { "n", "i", "t" } },
    { "<C-j>", "<cmd> TmuxNavigateDown<cr>", mode = { "n", "i", "t" } },
    { "<C-k>", "<cmd> TmuxNavigateUp<cr>", mode = { "n", "i", "t" } },
    { "<C-l>", "<cmd> TmuxNavigateRight<cr>", mode = { "n", "i", "t" } },
    { "<C-\\>", "<cmd> TmuxNavigatePrevious<cr>", mode = { "n", "i", "t" } },
  },
}
