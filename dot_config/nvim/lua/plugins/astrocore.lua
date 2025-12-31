-- if true then return {} end -- WARN: REMOVE THIS LINE TO ACTIVATE THIS FILE

local function smart_navigate(direction)
  local directions = {
    h = "Left",
    j = "Down",
    k = "Up",
    l = "Right",
  }

  -- Always leave terminal insert mode
  if vim.fn.mode() == "t" then
    vim.cmd("stopinsert")
  end

  local buftype = vim.bo.buftype
  local in_terminal = buftype == "terminal"
  local in_tmux = vim.env.TMUX ~= nil
  local cmd = "wincmd " .. direction

  -- Only use TmuxNavigate if we're NOT in a Neovim terminal
  if in_tmux and not in_terminal then
    cmd = "TmuxNavigate" .. directions[direction]
  end

  pcall(vim.cmd, cmd)
end

-- AstroCore provides a central place to modify mappings, vim options, autocommands, and more!
-- Configuration documentation can be found with `:h astrocore`
-- NOTE: We highly recommend setting up the Lua Language Server (`:LspInstall lua_ls`)
--       as this provides autocomplete and documentation while editing
---
---@type LazySpec
return {
  "AstroNvim/astrocore",
  ---@type AstroCoreOpts
  opts = {
    -- Configure core features of AstroNvim
    features = {
      large_buf = { size = 1024 * 500, lines = 10000 }, -- set global limits for large files for disabling features like treesitter
      autopairs = true,                                 -- enable autopairs at start
      cmp = true,                                       -- enable completion at start
      diagnostics_mode = 3,                             -- diagnostic mode on start (0 = off, 1 = no signs/virtual text, 2 = no virtual text, 3 = on)
      highlighturl = true,                              -- highlight URLs at start
      notifications = true,                             -- enable notifications at start

      conceallevel = 2, -- disable conceal
      -- linebreak = true, -- linebreak soft wrap at words
      list = true, -- show whitespace characters
    },
    -- Diagnostics configuration (for vim.diagnostics.config({...})) when diagnostics are on
    diagnostics = {
      virtual_text = true,
      underline = true,
    },
    -- vim options can be configured here
    options = {
      opt = {                  -- vim.opt.<key>
        relativenumber = true, -- sets vim.opt.relativenumber
        number = true,         -- sets vim.opt.number
        spell = false,         -- sets vim.opt.spell
        signcolumn = "auto",   -- sets vim.opt.signcolumn to auto
        wrap = true,           -- sets vim.opt.wrap
        breakindent = true,    -- sets vim.opt.breakindent
        conceallevel = 2, -- disable conceal
        scrolloff = 8,
        scrolljump = 1,
        
        shiftwidth = 4,
        tabstop = 4,

        swapfile = false,
        backup = false,
        writebackup = false,
        foldenable = false,
      },
      g = {                    -- vim.g.<key>
        -- configure global vim variables (vim.g)
        -- NOTE: `mapleader` and `maplocalleader` must be set in the AstroNvim opts or before `lazy.setup`
        -- This can be found in the `lua/lazy_setup.lua` file
      },
    },
    -- Mappings can be configured through AstroCore as well.
    -- NOTE: keycodes follow the casing in the vimdocs. For example, `<Leader>` must be capitalized
    mappings = {
      -- first key is the mode
      n = {
        ["<C-h>"] = "<Nop>",
        ["<C-j>"] = "<Nop>",
        ["<C-k>"] = "<Nop>",
        ["<C-l>"] = "<Nop>",
        -- second key is the lefthand side of the map

        -- navigate buffer tabs with `H` and `L`
        L = { function() require("astrocore.buffer").nav(vim.v.count1) end, desc = "Next buffer" },
        H = { function() require("astrocore.buffer").nav(-vim.v.count1) end, desc = "Previous buffer" },

        -- mappings seen under group name "Buffer"
        ["<Leader>bD"] = {
          function()
            require("astroui.status.heirline").buffer_picker(
              function(bufnr) require("astrocore.buffer").close(bufnr) end
            )
          end,
          desc = "Pick to close",
        },
        ["<Leader>E"] = { ":Neotree dir=./<CR>", desc = "NeoTree reset dir", },
        -- tables with just a `desc` key will be registered with which-key if it's installed
        -- this is useful for naming menus
        ["<Leader>b"] = { desc = "Buffers" },
        -- quick save
        -- ["<C-s>"] = { ":w!<cr>", desc = "Save File" },  -- change description but the same command
        -- NOTE: user defined keymapping
        ["n"] = { "nzz" },
        ["N"] = { "Nzz" },
        ["*"] = { "*zz" },
        ["#"] = { "#zz" },
        ["g*"] = { "g*zz" },
        ["g#"] = { "g#zz" },
        [";f"] = { ":HopChar2<cr>", desc = "Hop" },
        -- ["F"] = { ":HopChar2<cr>", desc = "Hop" },
        ["F"] = { ":Telescope buffers<cr>", desc = "Find buffers" },
        ["f"] = { ":HopWord<cr>", desc = "Hop Word" },
        ["<C-a>"] = { "ggVG" },
        ["<a-s>"] = { ":noa w<CR>" },

        -- TAB MANAGEMENT(or window)
        [";wq"] = { ":tabc<cr>", desc = "Close current tab" },
        [";wa"] = { ":tabnew<cr>", desc = "Open current tab" },
	      [";wf"] = { ":tab split<cr>", desc = "Open current file in new tab" },
        [";m"] = { ":terminal<cr>", desc = "Open terminal" },
        [";h"] = { ":tabp<cr>", desc = "Previous tab" },
        [";l"] = { ":tabn<cr>", desc = "Next tab" },

        [";wo"] = { ":tabonly<cr>", desc = "Close all other tabs" },
        [";wh"] = { ":tabprevious<cr>", desc = "Previous tab" },
        [";wl"] = { ":tabnext<cr>", desc = "Next tab" },
        [";wm"] = { ":terminal<cr>", desc = "Open terminal in current tab" },
        [";wr"] = { ":tabedit %<cr>", desc = "Reopen current file in this tab" },
        [";ws"] = { ":w<cr>", desc = "Save current file" },
        [";ww"] = { ":w<cr>:tabnext<cr>", desc = "Save and move to next tab" },
        [";wn"] = { ":tabnew %<cr>", desc = "Duplicate current file in new tab" },
        [";wi"] = { ":tabmove +1<cr>", desc = "Move current tab right" },
        [";wu"] = { ":tabmove -1<cr>", desc = "Move current tab left" },

        -- REFACTOR
        [";dV"] = { function() require('refactoring').debug.print_var({below = false}) end, desc = "Print var before" },
        [";dv"] = { function() require('refactoring').debug.print_var({}) end, desc = "Print var after" },
        [";dF"] = { function() require('refactoring').debug.printf({below = false}) end, desc = "Print debug before" },
        [";df"] = { function() require('refactoring').debug.printf({}) end, desc = "Print debug after" },
        [";dc"] = { function() require('refactoring').debug.cleanup({}) end, desc = "Clear debugging" },

        -- Neotest
        [";na"] = { ":Neotest attach<cr>", desc = "Neotest attach" },
        [";ns"] = { ":Neotest summary<cr>", desc = "Neotest summary" },
        [";np"] = { ":Neotest output-panel<cr>", desc = "Neotest output-panel" },
        [";no"] = { ":Neotest output<cr>", desc = "Neotest output" },
        [";nt"] = { function() require("neotest").run.run() end, desc = "Neotest current test" },
        [";nd"] = { function() require("neotest").run.run({ strategy="dap" }) end, desc = "Neotest current debug" },
        [";nf"] = { function() require("neotest").run.run(vim.fn.expand("%")) end, desc = "Neotest current file" },

        -- Obsidian.nvim
        [";od"] = { ":ObsidianDailies<cr>", desc = "Obisidian Dailies" },
        [";ob"] = { ":ObsidianBacklinks<cr>", desc = "Obisidian Backlinks" },
        [";or"] = { ":ObsidianRename<cr>", desc = "Obisidian Rename" },
        [";on"] = { ":ObsidianNew<cr>", desc = "Obisidian New Files" },
        [";ow"] = { ":ObsidianWorkspace<cr>", desc = "Obisidian Workspace" },
        [";og"] = { ":ObsidianTags<cr>", desc = "Obisidian Workspace" },
        [";ot"] = { ":ObsidianTemplate<cr>", desc = "Obisidian Templates" },
        [";oo"] = { ":ObsidianOpen<cr>", desc = "Obisidian Open" },


        -- HARPOON
        [";r"] = { ':lua require("harpoon.ui").toggle_quick_menu()<cr>' },
        [";a"] = { ':lua require("harpoon.mark").add_file()<cr>' },

        -- ZEN MODE
        [";z"] = { ':ZenMode<cr>' },

        ["<Leader>tl"] = {
          function()
            if vim.env.TMUX then
              -- Inside tmux: open lazygit in a new tmux window
              vim.fn.system("tmux new-window -n lazygit -c '#{pane_current_path}' 'lazygit'")
            else
              -- Not in tmux: open lazygit normally within Neovim
              require("astronvim.utils").toggle_term_cmd("lazygit")
            end
          end,
          desc = "Open lazygit (tmux window if available)"
        },
      },
      i = {
        ["<M-h>"] = { "<Left>", desc = "Buffers" },
        ["<M-k>"] = { "<Up>", desc = "Buffers" },
        ["<M-j>"] = { "<Down>", desc = "Buffers" },
        ["<M-l>"] = { "<Right>", desc = "Buffers" },

        ["<C-c>"] = false, -- disable to force brain use jj / jk

        ["<C-h>"] = { "<Left>", desc = "Buffers" },
        ["<C-l>"] = { "<Right>", desc = "Buffers" },
        ["<C-BS>"] = { "<C-w>", desc = "Delete a word" },
      },
      t = {
        -- setting a mapping to false will disable it
        -- ["<esc>"] = false,
        -- [";;"] = { "<C-\\><C-n>", desc = "Escape the terminal" },
        ["//"] = { "<C-\\><C-n>", desc = "Escape the terminal" },
        [";h"] = { "<C-\\><C-n>:tabp<cr>", desc = "Previous tab" },
        [";l"] = { "<C-\\><C-n>:tabn<cr>", desc = "Next tab" },
        [";wf"] = {
          function()
            local toggleterm = require("toggleterm")
            toggleterm.toggle(1, 15, nil, "float")
          end,
          desc = "Toggle floating terminal",
        },

        -- ["<M-h>"] = { "<Left>", desc = "Buffers" },
        -- ["<M-k>"] = { "<Up>", desc = "Buffers" },
        -- ["<M-j>"] = { "<Down>", desc = "Buffers" },
        -- ["<M-l>"] = { "<Right>", desc = "Buffers" },

        -- Alternative with <C-w><C-h> style
        ["<C-w><C-h>"] = { "<C-\\><C-n><C-w>h", desc = "Move to left window" },
        ["<C-w><C-j>"] = { "<C-\\><C-n><C-w>j", desc = "Move to bottom window" },
        ["<C-w><C-k>"] = { "<C-\\><C-n><C-w>k", desc = "Move to top window" },
        ["<C-w><C-l>"] = { "<C-\\><C-n><C-w>l", desc = "Move to right window" },

        -- ["<C-h>"] = { "<C-\\><C-n>:TmuxNavigateLeft<cr>", desc = "Navigate left" },
        -- ["<M-h>"] = { "<C-\\><C-n>:TmuxNavigateLeft<cr>", desc = "Navigate left" },

        -- ["<C-l>"] = { "<C-\\><C-n>:TmuxNavigateRight<cr>", desc = "Navigate right" },
        -- ["<M-l>"] = { "<C-\\><C-n>:TmuxNavigateRight<cr>", desc = "Navigate right" },
        -- Safe navigation (works with or without tmux)
        -- ["<C-h>"] = {
        --   function()
        --     vim.cmd("stopinsert") -- escape terminal insert mode
        --     if vim.env.TMUX then
        --       vim.cmd("TmuxNavigateLeft")
        --     else
        --       vim.cmd("wincmd h")
        --     end
        --   end,
        --   desc = "Move to left window",
        -- },
        -- ["<C-l>"] = {
        --   function()
        --     vim.cmd("stopinsert")
        --     if vim.env.TMUX then
        --       vim.cmd("TmuxNavigateRight")
        --     else
        --       vim.cmd("wincmd l")
        --     end
        --   end,
        --   desc = "Move to right window",
        -- },

        
  ["<C-h>"] = { function() smart_navigate "h" end, desc = "Smart move left" },
  ["<C-j>"] = { function() smart_navigate "j" end, desc = "Smart move down" },
  ["<C-k>"] = { function() smart_navigate "k" end, desc = "Smart move up" },
  ["<C-l>"] = { function() smart_navigate "l" end, desc = "Smart move right" },

        ["<C-w><C-v>"] = { "<C-\\><C-n>:vsplit<cr>", desc = "Buffers" },
        ["<C-w><C-s>"] = { "<C-\\><C-n>:split<cr>", desc = "Buffers" },
      },
      v = {
        -- Better indenting
        ["<"] = { "<gv" },
        [">"] = { ">gv" },

        -- -- Paste most recent yank
        ["p"] = { '"0p' },
        ["P"] = { '"0P' },
      },
      x = {
        [";dv"] = { function() require('refactoring').debug.print_var({}) end, desc = "Next tab" },
        [";dV"] = { function() require('refactoring').debug.print_var({below = false}) end, desc = "Next tab" },
      },
    },
  },
}
