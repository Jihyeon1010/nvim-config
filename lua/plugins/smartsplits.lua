return {
  'mrjones2014/smart-splits.nvim',
  'mrjones2014/legendary.nvim',
  priority = 10000,
  lazy = false,

  config = function()
    require('smart-splits').setup({
      ignored_buftypes = {
        'nofile',
        'quickfix',
        'prompt',
      },

      ignored_filetypes = {
        'NvimTree',
        'NeoTree',
      },

      default_amount = 3,
      at_edge = 'wrap',
      float_win_behavior = 'previous',
      move_cursor_same_row = false,
      cursor_follows_swapped_bufs = false,

      ignored_events = {
        'BufEnter',
        'WinEnter',
      },

      multiplexer_integration = nil,
      disable_multiplexer_nav_when_zoomed = true,
      kitty_password = nil,
      zellij_move_focus_or_tab = false,
      log_level = 'info',
    })

    require('legendary').setup({
      extensions = {
        smart_splits = {
          directions = { 'h', 'j', 'k', 'l' },
          prev_win = '<C-\\>',
          mods = {
            move = '<C>',
            resize = '<M>',
            swap = false,
          },
        },
      }
    })
  end,
}
