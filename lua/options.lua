require "nvchad.options"

vim.opt.clipboard = "unnamedplus"  -- Sử dụng system clipboard mặc định cho yank/paskkte
-- add yours here!
local opt = vim.opt

opt.clipboard = "unnamedplus"
opt.cursorline = true
opt.number = true
opt.relativenumber = true
opt.signcolumn = "yes"

opt.tabstop = 2
opt.shiftwidth = 2
opt.expandtab = true
opt.smartindent = true

opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = false
opt.incsearch = true

opt.termguicolors = true
opt.scrolloff = 8
opt.wrap = false

opt.updatetime = 250
opt.timeoutlen = 300

opt.swapfile = false
opt.backup = false
opt.undofile = true
opt.undodir = vim.fn.stdpath("data") .. "/undo"

vim.fn.mkdir(vim.fn.stdpath("data") .. "/undo", "p")
-- local o = vim.o
-- o.cursorlineopt ='both' -- to enable cursorline!
