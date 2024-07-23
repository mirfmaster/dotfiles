
-- vim.keymap.set(
-- 	{"n", "x"},
-- 	"<leader>rr",
-- 	function() require('telescope').extensions.refactoring.refactors() end
-- )

--tte
return {
  -- disabling alpha nvim
  {
    "rcarriga/nvim-notify",
    -- opts = {
    --   timeout = 1000,
    --   stages = "slide",
    --   fps = 144,
    --   max_width = 70,
    -- },
  },
  -- { "goolord/alpha-nvim", enabled = false },

  {
    "ray-x/lsp_signature.nvim",
    event = "BufRead",
    config = function() require("lsp_signature").setup() end,
  },
  {
    "L3MON4D3/LuaSnip",
    config = function(plugin, opts)
      require "astronvim.plugins.configs.luasnip"(plugin, opts) -- include the default astronvim config that calls the setup call
      -- add more custom luasnip configuration such as filetype extend or custom snippets
      local luasnip = require "luasnip"
      luasnip.filetype_extend("javascript", { "javascriptreact" })
    end,
  },
  { 'mg979/vim-visual-multi' },
  {
    "phaazon/hop.nvim",
    event = "BufRead",
    config = function()
      require("hop").setup()
    end,
  },
  { 'ThePrimeagen/harpoon' },
  {
    'andymass/vim-matchup',
    config = function()
      -- may set any options here
      vim.g.matchup_matchparen_offscreen = { method = "popup" }
    end
  },
  -- { 'nacro90/numb.nvim' },
  { "folke/zen-mode.nvim", },
  { "psliwka/vim-smoothie" },
  {
    "karb94/neoscroll.nvim",
    event = "BufRead",
    config = function()
      require("neoscroll").setup {
        -- All these keys will be mapped to their corresponding default scrolling animation
        mappings = { "<C-u>", "<C-d>", "<C-b>", "<C-f>", "<C-y>", "<C-e>", "zt", "zz", "zb" },
        hide_cursor = true, -- Hide cursor while scrolling
        stop_eof = true, -- Stop at <EOF> when scrolling downwards
        respect_scrolloff = false, -- Stop scrolling when the cursor reaches the scrolloff margin of the file
        cursor_scrolls_alone = true, -- The cursor will keep on scrolling even if the window cannot scroll further
        easing_function = nil, -- Default easing function
        pre_hook = nil, -- Function to run before the scrolling animation starts
        post_hook = nil, -- Function to run after the scrolling animation ends
        performance_mode = false, -- Disable "Performance Mode" on all buffers.
      }
    end,
  },
  {
    "ThePrimeagen/refactoring.nvim",
    lazy = true,
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    config = function()
      require('refactoring').setup({
        -- overriding printf statement for cpp
        print_var_statements = {
            -- add a custom print var statement for cpp
            php = {
                -- 'dump("Variable: %s", %s);'
                'dump(\'Variable: %s %s\', %s);'
            },
            go = {
                'fmt.Println(fmt.Sprintf("%s %%+v ", %s))'
            }
        },
        printf_statements = {
            -- add a custom print var statement for cpp
            php = {
                'dump("Debugging: %s");'
            }
        }
      })
      -- require("telescope").load_extension("refactoring")
    end,
  },
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-neotest/nvim-nio",
      "nvim-lua/plenary.nvim",
      "antoinemadec/FixCursorHold.nvim",
      "nvim-treesitter/nvim-treesitter",

      -- ADAPTERS
      "nvim-neotest/neotest-go",
      "nvim-neotest/neotest-vim-test",
    },
    config = function()
      -- get neotest namespace (api call creates or returns namespace)
      local neotest_ns = vim.api.nvim_create_namespace("neotest")
      vim.diagnostic.config({
        virtual_text = {
          format = function(diagnostic)
            local message =
              diagnostic.message:gsub("\n", " "):gsub("\t", " "):gsub("%s+", " "):gsub("^%s+", "")
            return message
          end,
        },
      }, neotest_ns)
      require("neotest").setup({
          -- your neotest config here
          adapters = {
            require("neotest-go"),
            require("neotest-vim-test"),
        },
      })
    end,
  },
  {
    "max397574/better-escape.nvim",
    enable = false,
    config = function(plugin,opts)
            -- lua, default settings
      require("better_escape").setup {
          timeout = vim.o.timeoutlen,
          default_mappings = false,
          mappings = {
              i = {
                  j = {
                      -- These can all also be functions
                      k = "<Esc>",
                      j = "<Esc>",
                  },
              },
              c = {
                  j = {
                      k = "<Esc>",
                      j = "<Esc>",
                  },
              },
              -- t = {
              --     j = {
              --         k = "<Esc>",
              --         j = "<Esc>",
              --     },
              -- },
              -- v = {
              --     j = {
              --         k = "<Esc>",
              --     },
              -- },
              s = {
                  j = {
                      k = "<Esc>",
                  },
              },
          },
      }
    end,
  },
  {
    "goolord/alpha-nvim",
    opts = function(_, opts)
      -- customize the dashboard header
      -- opts.section.header.val = {
      --   " █████  ███████ ████████ ██████   ██████",
      --   "██   ██ ██         ██    ██   ██ ██    ██",
      --   "███████ ███████    ██    ██████  ██    ██",
      --   "██   ██      ██    ██    ██   ██ ██    ██",
      --   "██   ██ ███████    ██    ██   ██  ██████",
      --   " ",
      --   "    ███    ██ ██    ██ ██ ███    ███",
      --   "    ████   ██ ██    ██ ██ ████  ████",
      --   "    ██ ██  ██ ██    ██ ██ ██ ████ ██",
      --   "    ██  ██ ██  ██  ██  ██ ██  ██  ██",
      --   "    ██   ████   ████   ██ ██      ██",
      -- }

      opts.section.header.val = {
        
  " ▄▄▄▄███▄▄▄▄      ▄████████    ▄████████    ▄████████     ███        ▄████████  ▄██████▄  ",
 "▄██▀▀▀███▀▀▀██▄   ███    ███   ███    ███   ███    ███ ▀█████████▄   ███    ███ ███    ███ ",
 "███   ███   ███   ███    ███   ███    █▀    ███    █▀     ▀███▀▀██   ███    ███ ███    ███ ",
 "███   ███   ███   ███    ███  ▄███▄▄▄       ███            ███   ▀  ▄███▄▄▄▄██▀ ███    ███ ",
 "███   ███   ███ ▀███████████ ▀▀███▀▀▀     ▀███████████     ███     ▀▀███▀▀▀▀▀   ███    ███ ",
 "███   ███   ███   ███    ███   ███    █▄           ███     ███     ▀███████████ ███    ███ ",
 "███   ███   ███   ███    ███   ███    ███    ▄█    ███     ███       ███    ███ ███    ███ ",
  "▀█   ███   █▀    ███    █▀    ██████████  ▄████████▀     ▄████▀     ███    ███  ▀██████▀  ",
      }

      return opts
    end,
  },
}
