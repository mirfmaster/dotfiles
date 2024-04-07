-- TODO: User Config for predefined plugins
-- After changing plugin config exit and reopen LunarVim, Run :PackerInstall :PackerCompile

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
