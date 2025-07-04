local g = vim.g               -- Global variables
local opt = vim.opt           -- Set options (global/buffer/windows-scoped)
-- General
opt.mouse = 'a'               -- Enable mouse support
opt.clipboard = 'unnamedplus' -- Copy/paste to system clipboard
opt.wrap = false
opt.undofile = true
opt.ignorecase = true
opt.smartcase = true
opt.laststatus = 3
opt.wrap = false
opt.cursorline = true
opt.number = true          -- Show line number
opt.relativenumber = false -- Show relative line number
opt.signcolumn = 'yes'     -- Always show sign column
opt.splitright = true
opt.splitbelow = true
opt.termguicolors = true
opt.hlsearch = true
opt.incsearch = true
-- Tabs, indent
opt.expandtab = true   -- Use spaces instead of tabs
opt.shiftwidth = 2     -- Shift 2 spaces when tab
opt.tabstop = 2        -- 1 tab == 2 spaces
opt.smartindent = true -- Autoindent new lines
