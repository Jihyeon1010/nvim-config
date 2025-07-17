-- init.lua
if vim.g.vscode then
  -- VSCode Neovim-specific config
  vim.keymap.set("n", "<C-j>", "5j")
  vim.keymap.set("n", "<C-k>", "5k")
  -- Avoid conflicting with VSCode'set

  vim.opt.cmdheight = 0
  vim.opt.shortmess:append("c")
  vim.opt.showmode = false
  vim.opt.showcmd = false
  vim.opt.ruler = false
  vim.opt.laststatus = 0
else
  -- Normal Neovim config
end

require("config.lazy")
require("config.options")
require("config.keymaps")
require("config.autocmds")
