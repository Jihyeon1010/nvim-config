# nvim-config 

## Installation 
* Windows Installation 
```powershell
# Chocolatey installation
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

# Neovim installation
choco install neovim

# additional software required
choco install fzf
choco install luarocks
choco install git
```
* Macos Installation
```bash
# Homebrew installation 
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Neovim installation
brew install neovim

# additional software required
brew install git
brew install luarocks
brew install fzf
```
* Linux Installation
```bash
# Linux Neovim installation via apt
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
sudo rm -rf /opt/nvim
sudo tar -C /opt -xzf nvim-linux-x86_64.tar.gz
export PATH="$PATH:/opt/nvim-linux-x86_64/bin"

# additional software required
sudo apt install fzf
sudo apt install git
sudo apt install luarocks
```
## Plugins utilised 
* [Lazy.nvim](https://github.com/folke/lazy.nvim)
* [Tokoynight.nvim](https://github.com/folke/tokyonight.nvim)
* [nvim-web-devicon](https://github.com/nvim-tree/nvim-web-devicons)
* [Neotree.nvim](https://github.com/nvim-neo-tree/neo-tree.nvim)
* [Bufferline.nvim](https://github.com/akinsho/bufferline.nvim?tab=readme-ov-file)
* [Heirline.nvim](https://github.com/rebelot/heirline.nvim?tab=readme-ov-file)
* [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig)
* [tmux.nvim](https://github.com/aserowy/tmux.nvim)
## Option configuration
```lua
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
```
