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
        left = "",
        right = "",
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
          return { fg = colors.bg or "#1a1b26", bg = get_mode_color(), bold = true }
        end,
        update = {
          "ModeChanged",
          pattern = "*:*",
          callback = vim.schedule_wrap(function()
            vim.cmd("redrawstatus")
          end),
        },
      }

      -- Method 2: Manual separator components
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

      local FileName = {
        provider = function(self)
          local filename = vim.fn.fnamemodify(self.filename, ":.")
          if filename == "" then return "[No Name]" end
          if #filename > 30 then
            filename = vim.fn.pathshorten(filename)
          end
          return " " .. filename .. " "
        end,
        hl = { fg = colors.fg_statusline , bg = colors.bg_statusline },
      }

      local FileFlags = {
        {
          condition = function()
            return vim.bo.modified
          end,
          provider = "[+]",
          hl = { fg = colors.green , bg = colors.bg_statusline },
        },
        {
          condition = function()
            return not vim.bo.modifiable or vim.bo.readonly
          end,
          provider = "",
          hl = { fg = colors.orange, bg = colors.bg_statusline },
        },
      }

      FileNameBlock = utils.insert(FileNameBlock,
        FileName,
        FileFlags,
        { provider = "%< " }
      )

      -- File section separator
      local FileSeparator = {
        provider =  separators.right,
        hl = { fg = colors.bg_statusline, bg = colors.bg_statusline },
      }

      local GitBranch = {
        condition = conditions.is_git_repo,
        init = function(self)
          self.status_dict = vim.b.gitsigns_status_dict
          self.has_changes = self.status_dict and (self.status_dict.added ~= 0 or self.status_dict.removed ~= 0 or self.status_dict.changed ~= 0)
        end,
        provider = function(self)
          return " " .. ((self.status_dict and self.status_dict.head) or "main") .. " "
        end,
        hl = { fg = colors.purple or "#bb9af7", bg = colors.bg_statusline or colors.bg or "#1a1b26", bold = true },
      }

      -- Git separator
      local GitSeparator = {
        provider = " ",
        hl = { fg = colors.purple or "#bb9af7", bg = colors.bg_statusline or colors.bg or "#1a1b26" },
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

      local Ruler = {
        provider = " %7(%l/%3L%):%2c %P ",
        hl = { fg = colors.blue or "#7aa2f7", bg = colors.bg_statusline or colors.bg or "#1a1b26", bold = true },
      }

      -- Ruler separator
      local RulerSeparator = {
        provider = separators.arrow_left .. " ",
        hl = { fg = colors.blue or "#7aa2f7", bg = colors.bg_statusline or colors.bg or "#1a1b26" },
      }

      local DefaultStatusline = {
        ViMode,
        ModeSeparator,
        FileNameBlock,
        FileSeparator,
        GitBranch,
        GitSeparator,
        
        { provider = "%=" }, -- Right align
        
        LSPActive,
        LSPSeparator,
        RulerSeparator,
        Ruler,
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