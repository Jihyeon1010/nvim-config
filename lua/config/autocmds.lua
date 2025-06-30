-- lua/config/autocmds.lua

-- Create a group for clean organization
local augroup = vim.api.nvim_create_augroup

local general = augroup("GeneralAutocmds", { clear = true })

-- Remove trailing whitespace on save
vim.api.nvim_create_autocmd("BufWritePre", {
  group = general,
  pattern = "*",
  command = [[%s/\s\+$//e]],
})

-- Highlight text on yank
vim.api.nvim_create_autocmd("TextYankPost", {
  group = general,
  pattern = "*",
  callback = function()
    vim.highlight.on_yank({ timeout = 200 })
  end,
})

-- Reload file if changed outside
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter" }, {
  group = general,
  pattern = "*",
  command = "checktime",
})

-- Resize splits when window size changes
vim.api.nvim_create_autocmd("VimResized", {
  group = general,
  pattern = "*",
  command = "tabdo wincmd =",
})

-- Open help files in vertical splits
vim.api.nvim_create_autocmd("FileType", {
  group = general,
  pattern = "help",
  command = "wincmd L",
})

-- Spell check and line wrap in markdown and gitcommit
vim.api.nvim_create_autocmd("FileType", {
  group = general,
  pattern = { "markdown", "gitcommit" },
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.spell = true
  end,
})

-- Use relative numbers in normal mode, absolute in insert mode
vim.api.nvim_create_autocmd("InsertEnter", {
  group = general,
  callback = function()
    vim.opt.relativenumber = false
  end,
})

vim.api.nvim_create_autocmd("InsertLeave", {
  group = general,
  callback = function()
    vim.opt.relativenumber = true
  end,
})

-- Auto create missing directories before saving
vim.api.nvim_create_autocmd("BufWritePre", {
  group = general,
  callback = function(event)
    local dir = vim.fn.fnamemodify(event.match, ":p:h")
    if vim.fn.isdirectory(dir) == 0 then
      vim.fn.mkdir(dir, "p")
    end
  end,
})

-- Auto disable paste mode when leaving insert
vim.api.nvim_create_autocmd("InsertLeave", {
  group = general,
  command = "set nopaste",
})

-- Remember last position when reopening file
vim.api.nvim_create_autocmd("BufReadPost", {
  group = general,
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    local lcount = vim.api.nvim_buf_line_count(0)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})
