return {
  "smoka7/multicursors.nvim",
  event = "VeryLazy",
  dependencies = {
    'nvimtools/hydra.nvim',
  },
  opts = {
    DEBUG_MODE = false,
    create_commands = true,
    updatetime = 50,
    nowait = true,
    mode_keys = {
      append = 'a',
      change = 'c',
      extend = 'e',
      insert = 'i',
    },
    hint_config = {
      float_opts = {
        border = 'rounded',
      },
      position = 'bottom-right',
    },
    generate_hints = {
      normal = true,
      insert = true,
      extend = true,
      config = {
        column_count = nil,
        max_hint_length = 25,
      },
    },
  },
  keys = {
    {
      mode = { 'v', 'n' },
      '<C-n>',
      '<cmd>MCstart<cr>',
      desc = 'Create a selection for selected text or word under cursor',
    },
  },
}
