return {
  'mrjones2014/smart-splits.nvim',
  config = function ()
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
    })
  end,
}
