-- init.lua
if vim.g.vscode then
  -- VSCode Neovim-specific config
  vim.keymap.set("n", "<C-j>", "5j")
  vim.keymap.set("n", "<C-k>", "5k")
  -- Avoid conflicting with VSCode's UI
else
  -- Normal Neovim config
end

require("config.lazy")
require("config.options")
require("config.keymaps")
require("config.autocmds")
