return {
  -- Obsidian.nvim - Obsidian vault integration
  {
    "obsidian-nvim/obsidian.nvim",
    version = "*",
    ft = "markdown",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    opts = {
      legacy_commands = false,
      workspaces = {
        {
          name = "The-Second-Brain",
          path = "~/Documents/Vaults/The-Second-Brain",
        },
        {
          name = "Personal",
          path = "~/Documents/Vaults/Personal",
          overrides = {
            daily_notes = {
              folder = "01 Timebox",
              date_format = "%Y/%m/%d",
              template = "00 ZK/9 Templates/Time boxing template.md",
            },
          },
        },
      },
      notes_subdir = "00 ZK/3 Notes",
      daily_notes = {
        folder = "00 ZK/1 Daily",
        date_format = "%Y/Week %U/%Y-%m-%d",
        template = "00 ZK/9 Templates/Daily template.md",
      },
      new_notes_location = "notes_subdir",
      note_path_func = function(spec)
        local path = spec.dir / tostring(spec.id)
        return path:with_suffix(".md")
      end,
      wiki_link_func = function(opts)
        return require("obsidian.util").wiki_link_id_prefix(opts)
      end,
      markdown_link_func = function(opts)
        return require("obsidian.util").markdown_link(opts)
      end,
      preferred_link_style = "wiki",
      image_name_func = function()
        return string.format("%s-", os.time())
      end,
      frontmatter = {
        enabled = false,
      },
      templates = {
        subdir = "00 ZK/9 Templates",
        date_format = "%Y-%m-%d",
        time_format = "%H:%M",
      },
      open = {
        func = function(uri)
          vim.ui.open(uri, { cmd = { "xdg-open" } })
        end,
      },
      picker = {
        name = "snacks.pick",
        note_mappings = {
          new = "<C-x>",
          insert_link = "<C-l>",
        },
        tag_mappings = {
          tag_note = "<C-x>",
          insert_tag = "<C-l>",
        },
      },
      search = {
        sort_by = "modified",
        sort_reversed = true,
      },
      ui = {
        enable = false,
      },
      attachments = {
        folder = "99 Assets",
      },
    },
    keys = {
      -- Mnemonic keybindings for Obsidian
      {
        "<Leader>on",
        function()
          local input = vim.fn.input("Note title (optional): ", "")

          local obsidian = require("obsidian")
          local Note = obsidian.Note
          local daily = require("obsidian.daily")

          local daily_path, daily_id = daily.daily_note_path(os.time())
          local dir = daily_path:parent()

          local note_id
          if input and input ~= "" then
            note_id = daily_id .. "-" .. input
          end

          local note = Note.create {
            id = note_id,
            verbatim = true,
            dir = dir,
            template = Obsidian.opts.daily_notes.template,
            should_write = true,
          }

          note:open { sync = true }
        end,
        desc = "Obsidian [n]ew note (daily folder with date prefix)",
      },
      { "<Leader>ot", ":Obsidian today<CR>", desc = "Obsidian [t]oday" },
      { "<Leader>oy", ":Obsidian yesterday<CR>", desc = "Obsidian [y]esterday" },
      { "<Leader>om", ":Obsidian tomorrow<CR>", desc = "Obsidian to[m]orrow" },
      { "<Leader>od", ":Obsidian dailies<CR>", desc = "Obsidian [d]ailies" },
      { "<Leader>oq", ":Obsidian quick_switch<CR>", desc = "Obsidian [q]uick switch" },
      { "<Leader>of", ":Obsidian follow_link<CR>", desc = "Obsidian [f]ollow link" },
      { "<Leader>ob", ":Obsidian backlinks<CR>", desc = "Obsidian [b]acklinks" },
      { "<Leader>oc", ":Obsidian toc<CR>", desc = "Obsidian table of [c]ontents" },
      { "<Leader>oa", ":Obsidian tags<CR>", desc = "Obsidian t[a]gs" },
      { "<Leader>op", ":Obsidian paste_img<CR>", desc = "Obsidian [p]aste image" },
      { "<Leader>or", ":Obsidian rename<CR>", desc = "Obsidian [r]ename" },
      { "<Leader>oo", ":Obsidian open<CR>", desc = "Obsidian [o]pen app" },
      -- Visual mode mappings
      { "<Leader>ox", ":Obsidian extract_note<CR>", mode = "v", desc = "Obsidian e[x]tract note" },
      { "<Leader>ol", ":Obsidian link<CR>", mode = "v", desc = "Obsidian [l]ink selection" },
    },
  },
}
