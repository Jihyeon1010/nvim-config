-- init.lua
if vim.g.vscode then
  -- VSCode Neovim-specific config
  vim.keymap.set("n", "<C-j>", "5j")
  vim.keymap.set("n", "<C-k>", "5k")
  -- Avoid conflicting with VSCode'set

  vim.opt.cmdheight = 0
  vim.opt.laststatus = 0
  vim.opt.showmode = false
  vim.opt.showcmd = false
  vim.opt.ruler = false
  vim.opt.shortmess:append("c")

  vim.opt.number = false
  vim.opt.relativenumber = false
  vim.opt.cursorline = false
  vim.opt.signcolumn = "no"
  vim.opt.foldcolumn = "0"

  vim.lsp.handlers["textDocument/hover"] = function() end
  vim.lsp.handlers["textDocument/signatureHelp"] = function() end
else
  -- Normal Neovim config
end

require("config.lazy")
require("config.options")
require("config.keymaps")
require("config.autocmds")
