return {
  "sindrets/diffview.nvim",
  dependencies = {},
  config = function()
    require("diffview").setup({
      diff_binaries = false,    -- Show diffs for binaries
      enhanced_diff_hl = false, -- See |diffview-config-enhanced_diff_hl|
      git_cmd = { "git" },      -- The git executable followed by default args.
      hg_cmd = { "hg" },        -- The hg executable followed by default args.
      use_icons = true,         -- Requires nvim-web-devicons
      show_help_hints = true,   -- Show hints for how to open the help panel
      watch_index = true,

      icons = { -- Only applies when use_icons is true.
        folder_closed = "",
        folder_open = "",
      },

      signs = {
        fold_closed = "",
        fold_open = "",
        done = "✓",
      },
    })
  end
}
