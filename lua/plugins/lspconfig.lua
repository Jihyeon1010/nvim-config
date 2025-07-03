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
    local capabilities = require("cmp_nvim_lsp").default_capabilities()
    local navic = require("nvim-navic")

    local function lsp_attach(client, bufnr)
      -- Your existing LSP keymaps and setup here...
      -- Add your keymaps, formatting, etc.
      -- Attach navic if server supports document symbols
      if client.server_capabilities.documentSymbolProvider then
        navic.attach(client, bufnr)
      end
    end

    local servers = {
      lua_ls = {
        on_attach = lsp_attach,
        capabilities = capabilities,
        settings = {
          Lua = {
            diagnostics = { globals = { "vim" } },
          },
        },
      },
      pyright = {},
      tsserver = {},
      html = {},
      cssls = {},
      clangd = {},
      bashls = {},
      jsonls = {},
      yamlls = {},
    }

    for server, config in pairs(servers) do
      lspconfig[server].setup(config)
    end
  end,
}
