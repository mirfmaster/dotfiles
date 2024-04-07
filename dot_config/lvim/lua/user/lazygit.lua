local Terminal = require("toggleterm.terminal").Terminal
local lazygit = Terminal:new { cmd = "lazygit", hidden = true, direction = "float" }

---@diagnostic disable-next-line: lowercase-global
function _lazygit_toggle() lazygit:toggle() end
