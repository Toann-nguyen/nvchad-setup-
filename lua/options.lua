-- Try to load nvchad default options if available; don't error if it's missing
pcall(function()
	require("nvchad.options")
end)

-- Enhanced options inspired by craftzdog's setup
local opt = vim.opt

-- Line numbers
opt.relativenumber = true
opt.number = true

-- Tabs & indentation
opt.tabstop = 2
opt.shiftwidth = 2
opt.expandtab = true
opt.autoindent = true
opt.smartindent = true

-- Line wrapping
opt.wrap = false

-- Search settings
opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = false
opt.incsearch = true

-- Cursor line
opt.cursorline = true

-- Appearance
opt.termguicolors = true
opt.background = "dark"
opt.signcolumn = "yes"
opt.scrolloff = 8
opt.sidescrolloff = 8
opt.colorcolumn = "100"

-- Backspace
opt.backspace = "indent,eol,start"

-- Clipboard
opt.clipboard:append("unnamedplus")

-- Split windows
opt.splitright = true
opt.splitbelow = true

-- Performance
opt.updatetime = 250
opt.timeoutlen = 300
opt.lazyredraw = true
opt.synmaxcol = 300

-- Undo & backup
opt.swapfile = false
opt.backup = false
opt.undofile = true
opt.undodir = os.getenv("HOME") .. "/.vim/undodir"

-- Better completion
opt.completeopt = "menu,menuone,noselect"

-- Mouse support
opt.mouse = "a"

-- File encoding
opt.encoding = "utf-8"
opt.fileencoding = "utf-8"

-- Show matching brackets
opt.showmatch = true

-- Hide mode in command line (shown in statusline)
opt.showmode = false

-- Always show tabline
opt.showtabline = 2

-- Competitive programming specific settings
opt.autoread = true
opt.hidden = true
