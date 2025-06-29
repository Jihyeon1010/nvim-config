-- Set leader key
vim.g.mapleader = " "

local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }

-- NvimTree toggle
keymap("n", "<leader>e", "<cmd>Neotree reveal<cr>", opts)

-- Telescope
keymap("n", "<leader>ff", "<cmd>Telescope find_files<cr>", opts)      -- Find files
keymap("n", "<leader>fg", "<cmd>Telescope live_grep<cr>", opts)       -- Grep in files
keymap("n", "<leader>fb", "<cmd>Telescope buffers<cr>", opts)         -- Buffers
keymap("n", "<leader>fh", "<cmd>Telescope help_tags<cr>", opts)       -- Help tags
keymap("n", "<leader>fo", "<cmd>Telescope oldfiles<cr>", opts)        -- Recently opened
keymap("n", "<leader>fc", "<cmd>Telescope commands<cr>", opts)        -- Command list
keymap("n", "<leader>fs", "<cmd>Telescope current_buffer_fuzzy_find<cr>", opts) -- Search in current buffer
keymap("n", "<leader>fr", "<cmd>Telescope resume<cr>", opts)          -- Resume last picker
keymap("n", "<leader>km", "<cmd>Telescope keymaps<cr>", opts)         -- Show keymaps
keymap("n", "<leader>ft", "<cmd>Telescope treesitter<cr>", opts)      -- Symbols from Treesitter
