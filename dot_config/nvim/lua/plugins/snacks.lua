return {
  "folke/snacks.nvim",
  opts = {
    picker = {
      sources = {
        explorer = {
          actions = {
            explorer_toggle_all = function(picker, item)
              local Tree = require("snacks.explorer.tree")
              local Actions = require("snacks.explorer.actions")
              
              local target_dir = (item and item.dir and item.file) or picker:cwd()
              local root = Tree:find(target_dir)
              
              if not root then
                return
              end
              
              local all_open = true
              local file_count = 0
              
              Tree:walk(root, function(node)
                if node.dir then
                  if not node.open then
                    all_open = false
                  end
                else
                  file_count = file_count + 1
                end
              end, { all = true })
              
              local function expand_with_depth(node, depth)
                if depth >= 5 then
                  return
                end
                
                for _, child in pairs(node.children) do
                  if child.dir then
                    child.open = true
                    child.expanded = true
                    expand_with_depth(child, depth + 1)
                  end
                end
              end
              
              if not all_open and file_count > 1000 then
                Snacks.picker.util.confirm(
                  "Expand all recursively? This will show " .. file_count .. " files.",
                  function()
                    expand_with_depth(root, 0)
                    Actions.update(picker, { refresh = true })
                  end
                )
                return
              end
              
              if all_open then
                Tree:close_all(target_dir)
              else
                expand_with_depth(root, 0)
              end
              
              Actions.update(picker, { refresh = true })
            end,
            
            copy_path_picker = function(picker)
              local item = picker:current()
              if not item or not item.file then return end
              
              local path = item.file
              local is_dir = item.dir or vim.fn.isdirectory(path) == 1
              
              local relative = vim.fn.fnamemodify(path, ":~:.")
              local filename = vim.fn.fnamemodify(path, ":t")
              local filename_no_ext = vim.fn.fnamemodify(path, ":t:r")
              local full_path = vim.fn.fnamemodify(path, ":p")
              local ext = vim.fn.fnamemodify(path, ":e")
              
              local items = {
                { text = string.format("Relative: %s", relative), path = relative },
                { text = string.format("Full path: %s", full_path), path = full_path },
              }
              
              if not is_dir then
                table.insert(items, 2, { text = string.format("Filename: %s", filename), path = filename })
                table.insert(items, 3, { text = string.format("Name only: %s", filename_no_ext), path = filename_no_ext })
                table.insert(items, { text = string.format("Extension: %s", ext), path = ext })
              end
              
              Snacks.picker({
                title = "Copy Path",
                format = "text",
                layout = { preset = "default", preview = false },
                items = items,
                confirm = function(picker, item)
                  picker:close()
                  vim.fn.setreg("+", item.path)
                  vim.notify(string.format("Copied: %s", item.path), vim.log.levels.INFO)
                end,
              })
            end,
          },
          win = {
            list = {
              keys = {
                ["e"] = "explorer_toggle_all",
                ["Y"] = "copy_path_picker",
              },
            },
          },
        },
      },
    },
  },
}
