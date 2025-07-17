return {
  'mrjones2014/smart-splits.nvim',

  config = function()
    require('smart-splits').setup({
      ignored_buftypes = {
        'nofile',
        'quickfix',
        'prompt',
      },

      ignored_filetypes = {
        'NvimTree',
        'neo-tree',
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
      keys = {
        -- Movement: Control + hjkl
        { "<C-h>", function() require("smart-splits").move_cursor_left() end,  desc = "Move to left split" },
        { "<C-j>", function() require("smart-splits").move_cursor_down() end,  desc = "Move to below split" },
        { "<C-k>", function() require("smart-splits").move_cursor_up() end,    desc = "Move to above split" },
        { "<C-l>", function() require("smart-splits").move_cursor_right() end, desc = "Move to right split" },

        -- Resize: Option (Alt) + hjkl
        { "<M-h>", function() require("smart-splits").resize_left() end,       desc = "Resize split left" },
        { "<M-j>", function() require("smart-splits").resize_down() end,       desc = "Resize split down" },
        { "<M-k>", function() require("smart-splits").resize_up() end,         desc = "Resize split up" },
        { "<M-l>", function() require("smart-splits").resize_right() end,      desc = "Resize split right" },
      },
    })
  end,
}
