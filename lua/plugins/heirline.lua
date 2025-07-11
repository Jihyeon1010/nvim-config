-- ~/.config/nvim/lua/plugins/statusline.lua
return {
  {
    "rebelot/heirline.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons", "SmiteshP/nvim-navic", },
    config = function()
      local heirline = require("heirline")
      local conditions = require("heirline.conditions")
      local utils = require("heirline.utils")
      local bit = require("bit")

      local colors = require("tokyonight.colors").setup()

      -- Define separator styles
      local separators = {
        left = " ",
        right = " ",
        vertical = "│",
        slash = "/",
        soft_right = "",
        soft_left = "",
        circle = "●",
        diamond = "◆",
        triangle_right = "▶",
        triangle_left = "◀",
      }

      -- Define mode colours
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
        return mode_colors[vim.fn.mode()]
      end

      -- NAVIC COMPONENT
      local Navic = {
        condition = function()
          return require("nvim-navic").is_available()
        end,
        static = {
          type_hl = {
            File = "Directory",
            Module = "@namespace",
            Namespace = "@namespace",
            Package = "@namespace",
            Class = "@type",
            Method = "@method",
            Property = "@method",
            Field = "@field",
            Constructor = "@constructor",
            Enum = "@type",
            Interface = "@type",
            Function = "@function",
            Variable = "@constant",
            Constant = "@constant",
            String = "@string",
            Number = "@number",
            Boolean = "@boolean",
            Array = "@constant",
            Object = "@type",
            Key = "@type",
            Null = "@type",
            EnumMember = "@constant",
            Struct = "@structure",
            Event = "@type",
            Operator = "@operator",
            TypeParameter = "@parameter",
          },
          -- encode and decode line/col/win into a single number
          enc = function(line, col, winnr)
            return bit.bor(bit.lshift(line, 16), bit.lshift(col, 6), winnr)
          end,
          dec = function(minwid)
            local line = bit.rshift(minwid, 16)
            local col = bit.band(bit.rshift(minwid, 6), 0x3FF)
            local winnr = bit.band(minwid, 0x3F)
            return line, col, winnr
          end,
        },

        init = function(self)
          local data = require("nvim-navic").get_data() or {}
          local children = {}

          -- Create navic component
          for i, d in ipairs(data) do
            local pos = self.enc(d.scope.start.line, d.scope.start.character, self.winnr)
            local child = {
              {
                provider = d.icon,
                hl = self.type_hl[d.type],
              },
              {
                provider = d.name:gsub("%%", "%%%%"):gsub("%s*->%s*", ""),
                hl = self.type_hl[d.type],

                on_click = {
                  -- Enable click to jump to symbol
                  minwid = pos,
                  callback = function(_, minwid)
                    local line, col, winnr = self.dec(minwid)
                    vim.api.nvim_win_set_cursor(vim.fn.win_getid(winnr), { line, col })
                  end,
                  name = "navic_click",
                },
              },
            }
            -- Add a separator if not the last item
            if #data > 1 and i < #data then
              table.insert(child, {
                provider = "  ",
                hl = { fg = colors.gray },
              })
            end
            table.insert(children, child)
          end

          -- Store the table in self so that can be accessed by the children
          self.child = self:new(children, 1)
        end,
        -- Evaluate the children containing navic components
        provider = function(self)
          return self.child:eval()
        end,
        hl = { fg = colors.gray },
      }

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
        hl = { fg = utils.get_highlight("Directory").fg, bg = colors.bg_statusline, bold = true },
      }

      local FileFlags = {
        {
          condition = function()
            return vim.bo.modified
          end,
          provider = " [+]",
          hl = { fg = colors.green, bg = colors.bg_statusline },
        },
        {
          condition = function()
            return not vim.bo.modifiable or vim.bo.readonly
          end,
          provider = "  ",
          hl = { fg = colors.red, bg = colors.bg_statusline },
        },
      }

      local FileNameModifer = {
        hl = function()
          if vim.bo.modified then
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

      local FileSeparator = {
        provider = separators.soft_right,
        hl = { fg = colors.blue, bg = colors.bg_statusline, bold = true },
      }

      local Git = {
        condition = conditions.is_git_repo,

        init = function(self)
          self.status_dict = vim.b.gitsigns_status_dict
          self.has_changes = self.status_dict.added ~= 0 or self.status_dict.removed ~= 0 or
              self.status_dict.changed ~= 0
        end,

        hl = { fg = "green" },


        { -- git branch name
          provider = function(self)
            return "  " .. self.status_dict.head
          end,
          hl = { bold = true }
        },
        {
          condition = function(self)
            return self.has_changes
          end,
          provider = "("
        },
        {
          provider = function(self)
            local count = self.status_dict.added or 0
            return count > 0 and (" +" .. count)
          end,
          hl = { fg = "#b8db87" },
        },
        {
          provider = function(self)
            local count = self.status_dict.removed or 0
            return count > 0 and (" -" .. count)
          end,
          hl = { fg = "#e26a75" },
        },
        {
          provider = function(self)
            local count = self.status_dict.changed or 0
            return count > 0 and (" ~" .. count)
          end,
          hl = { fg = "#7ca1f2" },
        },
        {
          condition = function(self)
            return self.has_changes
          end,
          provider = " )",
        },
      }

      local LSPActive = {
        condition = conditions.lsp_attached,
        update = { "LspAttach", "LspDetach" },
        provider = function()
          local names = {}
          for i, server in pairs(vim.lsp.get_active_clients({ bufnr = 0 })) do
            table.insert(names, server.name)
          end
          return " LSP:[" .. table.concat(names, ",") .. "] "
        end,
        hl = { fg = colors.green or "#9ece6a", bg = colors.bg_statusline or colors.bg or "#1a1b26", bold = true },
      }

      local Diagnostics = {
        static = {
          error_icon = "  ",
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
        provider = separators.soft_left,
        hl = { fg = colors.blue, bg = colors.bg_statusline },
      }
      -- WINBAR COMPONENTS
      local WinBarFileName = {
        provider = function()
          local filename = vim.api.nvim_buf_get_name(0)
          local fname = vim.fn.fnamemodify(filename, ":t")
          if fname == "" then return "" end
          return fname
        end,
        hl = { fg = colors.blue, bold = true },
      }

      local DefaultStatusline = {
        ViMode,
        ModeSeparator,
        FileNameBlock,
        FileSeparator,
        Git,

        { provider = "%=" },

        LSPActive,
        RulerSeparator,
        Diagnostics,
        RulerSeparator,
        Ruler,
        ScrollBar,
      }

      local WinBar = {
        WinBarFileName,
        { provider = " " },
        Navic,
      }

      heirline.setup({
        statusline = DefaultStatusline,
        winbar = WinBar,
        opts = {
          colors = colors,
        },
      })
    end,
  },
}
