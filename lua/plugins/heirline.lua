-- ~/.config/nvim/lua/plugins/statusline.lua
return {
  {
    "rebelot/heirline.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      local heirline = require("heirline")
      local conditions = require("heirline.conditions")
      local utils = require("heirline.utils")

      local colors = require("tokyonight.colors").setup()

      -- Define separator styles
      local separators = {
        left = " ",
        right = " ",
        vertical = "│",
        slash = "/",
        arrow_right = "➜",
        arrow_left = "➜",
        circle = "●",
        diamond = "◆",
        triangle_right = "▶",
        triangle_left = "◀",
      }

      local function get_mode_color()
        local mode_colors = {
          n = colors.blue or "#7aa2f7",
          i = colors.green or "#9ece6a",
          v = colors.purple or "#bb9af7",
          V = colors.purple or "#bb9af7",
          ["\22"] = colors.purple or "#bb9af7",
          c = colors.yellow or "#e0af68",
          s = colors.orange or "#ff9e64",
          S = colors.orange or "#ff9e64",
          ["\19"] = colors.orange or "#ff9e64",
          R = colors.red or "#f7768e",
          r = colors.red or "#f7768e",
          ["!"] = colors.red or "#f7768e",
          t = colors.green or "#9ece6a",
        }
        return mode_colors[vim.fn.mode()] or colors.fg or "#c0caf5"
      end

      local ViMode = {
        init = function(self)
          self.mode = vim.fn.mode(1)
        end,
        static = {
          mode_names = {
            n = " NORMAL",
            no = " NORMAL",
            nov = " NORMAL",
            noV = " NORMAL",
            ["no\22"] = " NORMAL",
            niI = " NORMAL",
            niR = " NORMAL",
            niV = " NORMAL",
            nt = " NORMAL",
            v = "󰨞 VISUAL",
            vs = "󰨞 VISUAL",
            V = "󰨞 V-LINE",
            Vs = "󰨞 V-LINE",
            ["\22"] = "󰨞 V-BLOCK",
            ["\22s"] = "󰨞 V-BLOCK",
            s = " SELECT",
            S = " S-LINE",
            ["\19"] = " S-BLOCK",
            i = " INSERT",
            ic = " INSERT",
            ix = " INSERT",
            R = " REPLACE",
            Rc = " REPLACE",
            Rx = " REPLACE",
            Rv = " REPLACE",
            Rvc = " REPLACE",
            Rvx = " REPLACE",
            c = "󰘳 COMMAND",
            cv = "󰘳 Ex",
            r = " ...",
            rm = " M",
            ["r?"] = " ?",
            ["!"] = " !",
            t = "  TERMINAL",
          },
        },
        provider = function(self)
          return " %2(" .. self.mode_names[self.mode] .. "%) "
        end,
        hl = function()
          return { fg = colors.bg, bg = get_mode_color(), bold = true }
        end,
        update = {
          "ModeChanged",
          pattern = "*:*",
          callback = vim.schedule_wrap(function()
            vim.cmd("redrawstatus")
          end),
        },
      }

      local ModeSeparator = {
        provider = separators.right, 
        hl = function()
          return { fg = get_mode_color(), bg = colors.bg_statusline }
        end,
        update = {
          "ModeChanged",
          pattern = "*:*",
        },
      }

      local FileNameBlock = {
        init = function(self)
          self.filename = vim.api.nvim_buf_get_name(0)
        end,
      }

      local FileIcon = {
        init = function(self)
          local filename = self.filename
          local extension = vim.fn.fnamemodify(filename, ":e")
          self.icon, self.icon_color = require("nvim-web-devicons").get_icon_color(filename, extension,
            { default = true })
        end,
        provider = function(self)
          return self.icon and (" UNIX  " .. self.icon .. " ")
        end,
        hl = function(self)
          return { fg = self.icon_color, bold = true }
        end
      }

      local FileName = {
        provider = function(self)
          local filename = vim.fn.fnamemodify(self.filename, ":.")
          if filename == "" then return "[No Name]" end
          if not conditions.width_percent_below(#filename, 0.25) then
            filename = vim.fn.pathshorten(filename)
          end
          return filename
        end,
        hl = { fg = utils.get_highlight("Directory").fg, bold = true },
      }

      local FileFlags = {
        {
          condition = function()
            return vim.bo.modified
          end,
          provider = "[+]",
          hl = { fg = colors.green, bg = colors.bg_statusline },
        },
        {
          condition = function()
            return not vim.bo.modifiable or vim.bo.readonly
          end,
          provider = "  ",
          hl = { fg = colors.orange, bg = colors.bg_statusline },
        },
      }

      local FileNameModifer = {
        hl = function()
          if vim.bo.modified then
            -- use `force` because we need to override the child's hl foreground
            return { fg = "cyan", bold = true, force = true }
          end
        end,
      }

      FileNameBlock = utils.insert(FileNameBlock,
        FileIcon,
        utils.insert(FileNameModifer, FileName),
        FileFlags,
        { provider = "%< " }
      )

      -- File section separator
      local FileSeparator = {
        provider = separators.right,
        hl = { fg = colors.bg_statusline, bg = colors.bg_statusline },
      }

      local GitBranch = {
        condition = conditions.is_git_repo,
        init = function(self)
          self.status_dict = vim.b.gitsigns_status_dict
          self.has_changes = self.status_dict and
              (self.status_dict.added ~= 0 or self.status_dict.removed ~= 0 or self.status_dict.changed ~= 0)
        end,
        provider = function(self)
          return " " .. ((self.status_dict and self.status_dict.head) or "main") .. " "
        end,
        hl = { fg = colors.purple, bg = colors.bg_statusline, bold = true },
      }

      -- Git separator
      local GitSeparator = {
        provider = separators.right,
        hl = { fg = colors.purple, bg = colors.bg_statusline },
      }

      local LSPActive = {
        condition = conditions.lsp_attached,
        update = { "LspAttach", "LspDetach" },
        provider = function()
          local names = {}
          for i, server in pairs(vim.lsp.get_active_clients({ bufnr = 0 })) do
            table.insert(names, server.name)
          end
          return " LSP:[" .. table.concat(names, ",") .. "] "
        end,
        hl = { fg = colors.green or "#9ece6a", bg = colors.bg_statusline or colors.bg or "#1a1b26", bold = true },
      }

      -- LSP separator
      local LSPSeparator = {
        provider = separators.circle .. " ",
        hl = { fg = colors.green or "#9ece6a", bg = colors.bg_statusline or colors.bg or "#1a1b26" },
      }

      local Diagnostics = {
        static = {
          error_icon = " ",
          warn_icon = " ",
          info_icon = " ",
          hint_icon = "󰌵 ",
        },
        init = function(self)
          self.errors = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
          self.warnings = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
          self.hints = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.HINT })
          self.info = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.INFO })
        end,
        update = { "DiagnosticChanged", "BufEnter" },
        {
          provider = function(self)
            return (self.error_icon .. self.errors .. " ")
          end,
          hl = { fg = colors.red },
        },
        {
          provider = function(self)
            return (self.warn_icon .. self.warnings .. " ")
          end,
          hl = { fg = colors.yellow },
        },
        {
          provider = function(self)
            return (self.info_icon .. self.info .. " ")
          end,
          hl = { fg = colors.cyan },
        },
        {
          provider = function(self)
            return (self.hint_icon .. self.hints .. " ")
          end,
          hl = { fg = colors.teal },
        },
      }

      local DiagnosticsSeparator = {
        provider = separators.right,
        hl = { fg = colors.fg_gutter, bg = colors.bg_statusline },
      }

      local Ruler = {
        provider = " %7(%l/%3L%):%2c %P ",
        hl = { fg = colors.blue, bg = colors.bg_statusline },
      }

      local ScrollBar = {
        static = {
          sbar = { '▁', '▂', '▃', '▄', '▅', '▆', '▇', '█' }
        },
        provider = function(self)
          local curr_line = vim.api.nvim_win_get_cursor(0)[1]
          local lines = vim.api.nvim_buf_line_count(0)
          local i = math.floor((curr_line - 1) / lines * #self.sbar) + 1
          return string.rep(self.sbar[i], 2)
        end,
        hl = { fg = colors.blue, bg = colors.bg_statusline },
      }

      local RulerSeparator = {
        provider = separators.left .. " ",
        hl = { fg = colors.bg_statusline, bg = colors.bg },
      }

      local DefaultStatusline = {
        ViMode,
        ModeSeparator,
        FileNameBlock,
        FileSeparator,
        Diagnostics,
        DiagnosticsSeparator,
        GitBranch,
        GitSeparator,

        { provider = "%=" }, -- Right align

        LSPActive,
        RulerSeparator,
        Ruler,
        ScrollBar,
      }

      heirline.setup({
        statusline = DefaultStatusline,
        opts = {
          colors = colors,
        },
      })
    end,
  },
}
