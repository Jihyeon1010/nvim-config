-- Set leader key
vim.g.mapleader = " "

local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }

-- Telescope
keymap("n", "<leader>ff", ":Telescope find_files<CR>", opts)