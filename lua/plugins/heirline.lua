return {
  "rebelot/heirline.nvim",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
    "folke/tokyonight.nvim",
  },
  event = "VeryLazy",  -- Lazy load on startup delay
  config = function()
    local heirline = require("heirline")
    local conditions = require("heirline.conditions")
    local utils = require("heirline.utils")
    local icons = require("nvim-web-devicons")

    local colors = require("tokyonight.colors").setup()
    -- set the colours of the mode of the NeoVim
    local mode_colors = {
      n = colors.blue,
      i = colors.green,
      v = colors.magenta,
      V = colors.magenta,
      ["\22"] = colors.magenta,
      c = colors.yellow,
      s = colors.orange,
      S = colors.orange,
      ["\19"] = colors.orange,
      R = colors.red,
      r = colors.red,
      ["!"] = colors.red,
      t = colors.red,
    }
    -- Vimode indicatior
    local ViMode = {
      init = function(self)
        self.mode = vim.fn.mode(1)
      end,
      static = {
        mode_names = {
          n = " NORMAL", i = " INSERT", v = " VISUAL", V = " V-LINE", ["\22"] = "V-BLOCK",
          c = "󰘳  COMMAND", s = "SELECT", S = "S-LINE", ["\19"] = "S-BLOCK",
          R = "REPLACE", r = "REPLACE", ["!"] = " SHELL", t = " TERMINAL",
        },
      },
      provider = function(self)
        return " " .. self.mode_names[self.mode] .. " "
      end,
      hl = function(self)
        return { fg = colors.bg, bg = mode_colors[self.mode:sub(1, 1)], bold = true }
      end,
      update = {
        "ModeChanged",
        pattern = "*:*",
        callback = vim.schedule_wrap(function()
          vim.cmd("redrawstatus")
        end),
      },
    }

    local Git = {
      condition = conditions.is_git_repo,
      init = function(self)
        self.status_dict = vim.b.gitsigns_status_dict
      end,
      provider = function(self)
        return " " .. self.status_dict.head .. " "
      end,
      hl = { fg = colors.purple },
    }

    local Diagnostics = {
      condition = conditions.has_diagnostics,
      static = {
        error_icon = " ", warn_icon = " ", info_icon = " ", hint_icon = " ",
      },
      update = { "DiagnosticChanged", "BufEnter" },
      provider = function()
        local icons = Diagnostics.static
        local d = vim.diagnostic.count(0)
        local output = ""
        if d[vim.diagnostic.severity.ERROR] then
          output = output .. icons.error_icon .. d[vim.diagnostic.severity.ERROR] .. " "
        end
        if d[vim.diagnostic.severity.WARN] then
          output = output .. icons.warn_icon .. d[vim.diagnostic.severity.WARN] .. " "
        end
        if d[vim.diagnostic.severity.INFO] then
          output = output .. icons.info_icon .. d[vim.diagnostic.severity.INFO] .. " "
        end
        if d[vim.diagnostic.severity.HINT] then
          output = output .. icons.hint_icon .. d[vim.diagnostic.severity.HINT]
        end
        return output
      end,
      hl = { fg = colors.fg },
    }

    local FileNameBlock = {
      init = function(self)
        self.filename = vim.api.nvim_buf_get_name(0)
      end,
    }

    local FileIcon = {
      init = function(self)
        local fname = vim.fn.expand("%:t")
        local ext = vim.fn.expand("%:e")
        self.icon, self.icon_color = icons.get_icon_color(fname, ext, { default = true })
      end,
      provider = function(self)
        return self.icon and (self.icon .. " ")
      end,
      hl = function(self)
        return { fg = self.icon_color }
      end,
    }

    local FileName = {
      provider = function(self)
        local name = vim.fn.fnamemodify(self.filename, ":~:.")
        return name == "" and "[No Name]" or name
      end,
      hl = { fg = colors.fg },
    }

    local FileFlags = {
      {
        condition = function() return vim.bo.modified end,
        provider = "[+]",
        hl = { fg = colors.green },
      },
      {
        condition = function() return not vim.bo.modifiable or vim.bo.readonly end,
        provider = " ",
        hl = { fg = colors.red },
      },
    }

    local FileNameModifier = {
      hl = function()
        if vim.bo.modified then
          return { fg = "cyan", bold = true, force = true }
        end
      end,
    }

    FileNameBlock = utils.insert(FileNameBlock,
      FileIcon,
      utils.insert(FileNameModifier, FileName),
      FileFlags,
      { provider = '%<'}
    )

    local LSPActive = {
      condition = conditions.lsp_attached,
      update = { "LspAttach", "LspDetach" },
      provider = function()
        local names = {}
        for _, client in pairs(vim.lsp.get_clients({ bufnr = 0 })) do
          table.insert(names, client.name)
        end
        return "  " .. table.concat(names, ", ")
      end,
      hl = { fg = colors.blue },
    }

    local FileType = {
      provider = function()
        return vim.bo.filetype ~= "" and " " .. vim.bo.filetype or ""
      end,
      hl = { fg = colors.orange },
    }

    local Ruler = {
      provider = " %l:%c ",
      hl = { fg = colors.fg },
    }

    local ScrollBar = {
      static = {
        sbar = { "▁", "▂", "▃", "▄", "▅", "▆", "▇", "█" },
      },
      provider = function(self)
        local curr_line = vim.api.nvim_win_get_cursor(0)[1]
        local total = vim.api.nvim_buf_line_count(0)
        local i = math.floor((curr_line / total) * (#self.sbar))
        return self.sbar[math.min(i + 1, #self.sbar)]
      end,
      hl = { fg = colors.blue },
    }

    heirline.setup({
      statusline = {
        ViMode,
        FileNameBlock,
        Git,
        utils.surround({ "", "" }, colors.blue, {
          provider = " " .. vim.bo.filetype,
          hl = { fg = colors.bg },
        }),
        Diagnostics,
        { provider = "%=" },
        LSPActive,
        FileType,
        Ruler,
        ScrollBar,
      },
    })
  end,
}

