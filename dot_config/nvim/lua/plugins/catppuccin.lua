-- Disabled initially (like example.lua)
-- To enable: change `if true` to `if false`
if true then return {} end

return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = true,
    priority = 1000,
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "catppuccin",
    },
  },
}
