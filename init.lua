vim.g.base46_cache = vim.fn.stdpath "data" .. "/base46/"
vim.g.mapleader = " "

-- bootstrap lazy and all plugins
local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"

if not vim.uv.fs_stat(lazypath) then
  local repo = "https://github.com/folke/lazy.nvim.git"
  vim.fn.system { "git", "clone", "--filter=blob:none", repo, "--branch=stable", lazypath }
end

vim.opt.rtp:prepend(lazypath)

local lazy_config = require "configs.lazy"

-- load plugins
require("lazy").setup({
  {
    "NvChad/NvChad",
    lazy = false,
    branch = "v2.5",
    import = "nvchad.plugins",
    config = function()
      require "options"
    end,
  },


  { import = "plugins" },
}, lazy_config)

-- load theme
dofile(vim.g.base46_cache .. "defaults")
dofile(vim.g.base46_cache .. "statusline")

require "options"
require "autocmds"
require "nvchad.autocmds"

vim.schedule(function()
  require "mappings"
end)
-- Custom options cho competitive programming
vim.opt.clipboard = "unnamedplus"
vim.opt.cursorline = true
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.wrap = false
vim.opt.scrolloff = 8
vim.opt.sidescrolloff = 8
vim.opt.termguicolors = true

-- Enhanced clipboard cho competitive programming
if vim.fn.has('unnamedplus') == 1 then
  vim.opt.clipboard:append('unnamed')
end

-- Competitive programming specific settings
vim.opt.timeoutlen = 300
vim.opt.updatetime = 250
vim.opt.signcolumn = "yes"

-- Disable swap files cho competitive programming
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undofile = true
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"

-- Search settings
vim.opt.hlsearch = false
vim.opt.incsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Performance optimizations
vim.opt.lazyredraw = true
vim.opt.synmaxcol = 300

-- Load custom mappings
require "configs.mappings"

-- Auto commands cho competitive programming
local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- C++ specific settings
local cpp_group = augroup("CPPSettings", {})

autocmd("FileType", {
  group = cpp_group,
  pattern = "cpp",
  callback = function()
    vim.opt_local.commentstring = "// %s"
    vim.opt_local.shiftwidth = 2
    vim.opt_local.tabstop = 2
    vim.opt_local.softtabstop = 2
  end,
})

-- Auto-compilation trước khi run
autocmd("BufWritePre", {
  group = augroup("AutoCompile", {}),
  pattern = "*.cpp",
  callback = function()
    local filename = vim.fn.expand("%:r")
    vim.fn.system(string.format("g++ -std=c++17 -O2 -Wall -o %s %s", filename, vim.fn.expand("%")))
  end,
})

-- Highlight khi copy
autocmd("TextYankPost", {
  group = augroup("HighlightYank", {}),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- Save folds
autocmd({"BufWinLeave"}, {
  pattern = {"*.*"},
  desc = "save view (folds), when closing file",
  command = "mkview",
})

autocmd({"BufWinEnter"}, {
  pattern = {"*.*"},
  desc = "load view (folds), when opening file",
  command = "silent! loadview"
})
