-- if true then return {} end -- WARN: REMOVE THIS LINE TO ACTIVATE THIS FILE

-- AstroCore provides a central place to modify mappings, vim options, autocommands, and more!
-- Configuration documentation can be found with `:h astrocore`
-- NOTE: We highly recommend setting up the Lua Language Server (`:LspInstall lua_ls`)
--       as this provides autocomplete and documentation while editing
---
local resession = require("resession")
resession.setup()
-- -- Resession does NOTHING automagically, so we have to set up some keymaps
-- vim.keymap.set("n", "<leader>ss", resession.save)
-- vim.keymap.set("n", "<leader>sl", resession.load)
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

        swapfile = false,
        backup = false,
        writebackup = false,
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
        -- [";f"] = { ":HopChar2<cr>", desc = "Hop" },
        ["F"] = { ":HopChar2<cr>", desc = "Hop" },
        ["f"] = { ":HopWord<cr>", desc = "Hop Word" },
        ["<C-a>"] = { "ggVG" },
        ["<a-s>"] = { ":noa w<CR>" },

        -- TERMINAL
        [";wq"] = { ":tabc<cr>", desc = "Close current tab" },
        [";wa"] = { ":tabnew<cr>", desc = "Open current tab" },
        [";m"] = { ":terminal<cr>", desc = "Open terminal" },
        [";h"] = { ":tabp<cr>", desc = "Previous tab" },
        [";l"] = { ":tabn<cr>", desc = "Next tab" },

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
        [";s"] = { resession.load},
        -- [";s"] = {
        --   function()
        --     local resession = require("resession")
        --     resession.setup().load
        --   end,
        --   desc = "test"
        -- },

        -- ZEN MODE
        [";z"] = { ':ZenMode<cr>' },
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
        [";;"] = { "<C-\\><C-n>", desc = "Escape the terminal" },
        [";h"] = { "<C-\\><C-n>:tabp<cr>", desc = "Previous tab" },
        [";l"] = { "<C-\\><C-n>:tabn<cr>", desc = "Next tab" },

        ["<M-h>"] = { "<Left>", desc = "Buffers" },
        ["<M-k>"] = { "<Up>", desc = "Buffers" },
        ["<M-j>"] = { "<Down>", desc = "Buffers" },
        ["<M-l>"] = { "<Right>", desc = "Buffers" },

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
