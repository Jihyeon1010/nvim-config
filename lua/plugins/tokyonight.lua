return {
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      style = "moon", -- "storm", "day", "night", "moon"
      transparent = false,
      terminal_colors = false,
    },
    -- Neotree highlights configuration
    on_highlights = function(hl, colors)
      -- NeoTree highlights configuration
      hl.NeoTreeDimText = { fg = colors.fg_gutter }
      hl.NeoTreeNormal = { fg = colors.fg_sidebar, bg = colors.bg_sidebar }
      hl.NeoTreeNormalNC = { fg = colors.fg_sidebar, bg = colors.bg_sidebar }  
      hl.NeoTreeFileName = { fg = colors.fg_sidebar }
      hl.NeoTreeGitModified = { fg = colors.orange }
      hl.NeoTreeGitUntracked = { fg = colors.magenta }
      hl.NeoTreeGitStaged = { fg = colors.green1 }
      hl.NeoTreeTabActive = { fg = colors.blue, bg = colors.bg_dark, bold = true }
      hl.NeoTreeTabInactive = { fg = colors.blue, bg = colors.bg_dark }
      hl.NeoTreeTabSeparatorActive  = { fg = colors.blue, bg = colors.bg_dark }
      hl.NeoTreeTabSeparatorInactive= { fg = colors.bg, bg = colors.dark }
      -- Telescope highlights configuration
      hl.TelescopeBorder = { fg = colors.border_highlight, bg = colors.bg_float }
      hl.TelescopeNormal = { fg = colors.fg, bg = colors.bg_float }
      hl.TelescopePromptBorder = { fg = colors.orange, bg = colors.bg_float }
      hl.TelescopePromptTitle = { fg = colors.orange, bg = colors.bg_float }
      hl.TelescopeResultsComment = { fg = colors.dark3 }
    end,
    -- Load the colorscheme
    config = function(_, opts)
      require("tokyonight").setup(opts)
      vim.cmd("colorscheme tokyonight")
    end,
  },
}