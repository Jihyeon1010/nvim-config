return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "williamboman/mason-lspconfig.nvim",
    "hrsh7th/cmp-nvim-lsp",
    "SmiteshP/nvim-navic",
  },
  config = function()
    local lspconfig = require("lspconfig")
    local navic = require("nvim-navic")

    -- Shared defaults applied to every server
    local defaults = {
      capabilities = require("cmp_nvim_lsp").default_capabilities(),
      on_attach = function(client, bufnr)
        if client.server_capabilities.documentSymbolProvider then
          navic.attach(client, bufnr)
        end
        local map = function(keys, fn)
          vim.keymap.set("n", keys, fn, { buffer = bufnr, silent = true })
        end
        map("gd", vim.lsp.buf.definition)
        map("gr", vim.lsp.buf.references)
        map("K", vim.lsp.buf.hover)
        map("<leader>rn", vim.lsp.buf.rename)
        map("<leader>ca", vim.lsp.buf.code_action)
      end,
    }

    -- Add a language here: server name -> per-server settings ({} for none)
    local servers = {
      lua_ls = { settings = { Lua = { diagnostics = { globals = { "vim" } } } } },
      pyright = {},
      ts_ls = {},      -- renamed from tsserver
      html = {},
      cssls = {},
      clangd = {},
      bashls = {},
      jsonls = {},
      yamlls = {},
      taplo = {},      -- TOML (Cargo.toml, tauri.conf)
      marksman = {},   -- Markdown
      -- rust_analyzer is intentionally absent: see note below
    }

    for server, config in pairs(servers) do
      lspconfig[server].setup(vim.tbl_deep_extend("force", defaults, config))
    end
  end,
}