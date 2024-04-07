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

lvim.builtin.which_key.mappings[";"] = nil
-- lvim.builtin.which_key.mappings["c"] = nil
-- lvim.builtin.which_key.mappings["L"] = nil
-- lvim.builtin.which_key.mappings["s"] = nil
lvim.builtin.which_key.mappings["w"] = nil

lvim.builtin.which_key.mappings["l"] = {
  name = "LSP",
  a = { "<cmd>lua vim.lsp.buf.code_action()<cr>", "Code Action" },
  -- c = { "<cmd>lua require('copilot.suggestion').toggle_auto_trigger()<cr>", "Get Capabilities" },
  -- c = { "<cmd>lua require('user.lsp').server_capabilities()<cr>", "Get Capabilities" },
  d = { "<cmd>TroubleToggle<cr>", "Diagnostics" },
  w = {
    "<cmd>Telescope lsp_workspace_diagnostics<cr>",
    "Workspace Diagnostics",
  },
  f = { "<cmd>lua vim.lsp.buf.format({ async = true })<cr>", "Format" },
  F = { "<cmd>LspToggleAutoFormat<cr>", "Toggle Autoformat" },
  i = { "<cmd>LspInfo<cr>", "Info" },
  h = { "<cmd>lua require('lsp-inlayhints').toggle()<cr>", "Toggle Hints" },
  -- H = { "<cmd>IlluminationToggle<cr>", "Toggle Doc HL" },
  -- I = { "<cmd>LspInstallInfo<cr>", "Installer Info" },
  j = {
    "<cmd>lua vim.diagnostic.goto_next({buffer=0})<CR>",
    "Next Diagnostic",
  },
  k = {
    "<cmd>lua vim.diagnostic.goto_prev({buffer=0})<cr>",
    "Prev Diagnostic",
  },
  -- v = { "<cmd>lua require('lsp_lines').toggle()<cr>", "Virtual Text" },
  l = { "<cmd>lua vim.lsp.codelens.run()<cr>", "CodeLens Action" },
  -- o = { "<cmd>SymbolsOutline<cr>", "Outline" },
  -- q = { "<cmd>lua vim.lsp.diagnostic.set_loclist()<cr>", "Quickfix" },
  r = { "<cmd>lua vim.lsp.buf.rename()<cr>", "Rename" },
  R = { "<cmd>TroubleToggle lsp_references<cr>", "References" },
  s = { "<cmd>Telescope lsp_document_symbols<cr>", "Document Symbols" },
  S = {
    "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>",
    "Workspace Symbols",
  },
  t = { '<cmd>lua require("user.functions").toggle_diagnostics()<cr>', "Toggle Diagnostics" },
  u = { "<cmd>LuaSnipUnlinkCurrent<cr>", "Unlink Snippet" },
}

lvim.builtin.which_key.mappings["f"] = {
  name = "Find",
  b = { "<cmd>Telescope git_branches<cr>", "Checkout branch" },
  c = { "<cmd>Telescope colorscheme<cr>", "Colorscheme" },
  f = { "<cmd>Telescope find_files<cr>", "Find files" },
  t = { "<cmd>Telescope live_grep<cr>", "Find Text" },
  s = { "<cmd>Telescope grep_string<cr>", "Find String" },
  h = { "<cmd>Telescope help_tags<cr>", "Help" },
  H = { "<cmd>Telescope highlights<cr>", "Highlights" },
  i = { "<cmd>lua require('telescope').extensions.media_files.media_files()<cr>", "Media" },
  l = { "<cmd>Telescope resume<cr>", "Last Search" },
  M = { "<cmd>Telescope man_pages<cr>", "Man Pages" },
  r = { "<cmd>Telescope oldfiles<cr>", "Recent File" },
  R = { "<cmd>Telescope registers<cr>", "Registers" },
  k = { "<cmd>Telescope keymaps<cr>", "Keymaps" },
  C = { "<cmd>Telescope commands<cr>", "Commands" },
}
