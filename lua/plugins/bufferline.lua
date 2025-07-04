return {
  "akinsho/bufferline.nvim",
  event = "VeryLazy",
  version = "*",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  opts = {
    options = {
      mode = "buffers",    -- or "tabs"
      numbers = "ordinal", -- or "buffer_id", or function
      close_command = "bdelete! %d",
      right_mouse_command = "bdelete! %d",
      left_mouse_command = "buffer %d",
      middle_mouse_command = nil,

      indicator = {
        icon = "▎", -- could be any UTF character
        style = "icon",
      },

      buffer_close_icon = "",
      modified_icon = "●",
      close_icon = "",
      left_trunc_marker = "",
      right_trunc_marker = "",

      max_name_length = 18,
      max_prefix_length = 15,
      tab_size = 20,
      diagnostics = "nvim_lsp", -- show LSP diagnostics
      diagnostics_update_in_insert = false,
      offsets = {
        {
          filetype = "NvimTree",
          text = "File Explorer",
          highlight = "Directory",
          text_align = "left",
        },
      },
      color_icons = true, -- uses `nvim-web-devicons`
      show_buffer_icons = true,
      show_buffer_close_icons = true,
      show_close_icon = true,
      show_tab_indicators = true,
      persist_buffer_sort = true,
      separator_style = "thin", -- "slant", "thick", "thin", "padded_slant"
      enforce_regular_tabs = false,
      always_show_bufferline = true,
      sort_by = "id",
    },
  },
}
