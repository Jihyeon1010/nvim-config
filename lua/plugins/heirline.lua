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

      --local colors = {
        --bright_bg = utils.get_highlight("Folded").bg,
        --bright_fg = utils.get_highlight("Folded").fg,
        --red = utils.get_highlight("DiagnosticError").fg,
        --dark_red = utils.get_highlight("DiffDelete").bg,
        --green = utils.get_highlight("String").fg,
        --blue = utils.get_highlight("Function").fg,
        --gray = utils.get_highlight("NonText").fg,
        --orange = utils.get_highlight("Constant").fg,
        --purple = utils.get_highlight("Statement").fg,
        --cyan = utils.get_highlight("Special").fg,
        --diag_warn = utils.get_highlight("DiagnosticWarn").fg,
        --diag_error = utils.get_highlight("DiagnosticError").fg,
        --diag_hint = utils.get_highlight("DiagnosticHint").fg,
        --diag_info = utils.get_highlight("DiagnosticInfo").fg,
        --git_del = utils.get_highlight("diffDeleted").fg,
        --git_add = utils.get_highlight("diffAdded").fg,
        --git_change = utils.get_highlight("diffChanged").fg,
      --}
      
      local ViMode = {
        init = function(self)
          self.mode = vim.fn.mode(1)
        end,
        static = {
          mode_names = {
            n = "NORMAL",
            no = "NORMAL",
            nov = "NORMAL",
            noV = "NORMAL",
            ["no\22"] = "NORMAL",
            niI = "NORMAL",
            niR = "NORMAL",
            niV = "NORMAL",
            nt = "NORMAL",
            v = "VISUAL",
            vs = "VISUAL",
            V = "V-LINE",
            Vs = "V-LINE",
            ["\22"] = "V-BLOCK",
            ["\22s"] = "V-BLOCK",
            s = "SELECT",
            S = "S-LINE",
            ["\19"] = "S-BLOCK",
            i = "INSERT",
            ic = "INSERT",
            ix = "INSERT",
            R = "REPLACE",
            Rc = "REPLACE",
            Rx = "REPLACE",
            Rv = "REPLACE",
            Rvc = "REPLACE",
            Rvx = "REPLACE",
            c = "COMMAND",
            cv = "Ex",
            r = "...",
            rm = "M",
            ["r?"] = "?",
            ["!"] = "!",
            t = "TERM",
          },
          mode_colors = {
            n = "red",
            i = "green",
            v = "cyan",
            V = "cyan",
            ["\22"] = "cyan",
            c = "orange",
            s = "purple",
            S = "purple",
            ["\19"] = "purple",
            R = "orange",
            r = "orange",
            ["!"] = "red",
            t = "red",
          }
        },
        provider = function(self)
          return " %2(" .. self.mode_names[self.mode] .. "%) "
        end,
        hl = function(self)
          local mode = self.mode:sub(1, 1)
          return { fg = self.mode_colors[mode], bold = true }
        end,
        update = {
          "ModeChanged",
          pattern = "*:*",
          callback = vim.schedule_wrap(function()
            vim.cmd("redrawstatus")
          end),
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
          return filename
        end,
        hl = { fg = utils.get_highlight("Directory").fg },
      }
      
      local FileFlags = {
        {
          condition = function()
            return vim.bo.modified
          end,
          provider = " [+]",
          hl = { fg = "green" },
        },
        {
          condition = function()
            return not vim.bo.modifiable or vim.bo.readonly
          end,
          provider = " ",
          hl = { fg = "orange" },
        },
      }
      
      FileNameBlock = utils.insert(FileNameBlock,
        FileName,
        FileFlags,
        { provider = "%< " }
      )
      
      local Ruler = {
        provider = "%7(%l/%3L%):%2c %P",
        hl = { fg = "blue", bold = true },
      }
      
      local LSPActive = {
        condition = conditions.lsp_attached,
        update = { "LspAttach", "LspDetach" },
        provider = function()
          local names = {}
          for i, server in pairs(vim.lsp.get_active_clients({ bufnr = 0 })) do
            table.insert(names, server.name)
          end
          return " [" .. table.concat(names, " ") .. "]"
        end,
        hl = { fg = "green", bold = true },
      }
      
      local DefaultStatusline = {
        ViMode, FileNameBlock, { provider = "%=" }, LSPActive, Ruler
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