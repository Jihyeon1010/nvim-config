-- lua/config/autocommands.lua
local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

local general = augroup("General", { clear = true })

-- 🪟 Resize splits when window resized
autocmd("VimResized", {
  group = general,
  command = "tabdo wincmd =",
})

-- 📌 Highlight on yank
autocmd("TextYankPost", {
  group = general,
  callback = function()
    vim.highlight.on_yank({ timeout = 200 })
  end,
})

-- 🧼 Format on save for supported filetypes
autocmd("BufWritePre", {
  group = general,
  callback = function()
    vim.lsp.buf.format({ async = false })
  end,
})

-- 📝 Set filetype-specific options
autocmd("FileType", {
  group = general,
  pattern = { "markdown", "text", "gitcommit" },
  callback = function()
    vim.opt_local.spell = true
    vim.opt_local.wrap = true
  end,
})

-- 🧹 Trim trailing whitespace on save
autocmd("BufWritePre", {
  group = general,
  callback = function()
    local save = vim.fn.winsaveview()
    vim.cmd([[silent! %s/\s\+$//e]])
    vim.fn.winrestview(save)
  end,
})

-- ⏪ Return to last cursor position
autocmd("BufReadPost", {
  group = general,
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    local lcount = vim.api.nvim_buf_line_count(0)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- 💾 Auto-create missing directories before saving
autocmd("BufWritePre", {
  group = general,
  callback = function()
    local dir = vim.fn.fnamemodify(vim.fn.expand("<afile>"), ":p:h")
    if vim.fn.isdirectory(dir) == 0 then
      vim.fn.mkdir(dir, "p")
    end
  end,
})

