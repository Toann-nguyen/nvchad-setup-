-- ~/.config/nvim/lua/mappings.lua
require "nvchad.mappings"

local map = vim.keymap.set

-- Basic mappings
map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")

-- ========== CLIPBOARD OPERATIONS ==========
map({ "n", "v" }, "<C-c>", '"+y', { desc = "Copy to system clipboard" })
map("n", "<C-c>", '"+yy', { desc = "Copy line to system clipboard" })
map({ "n", "v" }, "<C-v>", '"+p', { desc = "Paste from system clipboard" })
map("i", "<C-v>", "<C-r>+", { desc = "Paste from system clipboard (insert)" })
map("n", "<leader>ca", "ggVG\"+y", { desc = "Copy entire buffer to clipboard" })

-- ========== REACT/TYPESCRIPT SHORTCUTS ==========

-- Quick file navigation
map("n", "<leader>fc", ":Telescope find_files cwd=src/components<CR>", { desc = "Find React Components" })
map("n", "<leader>fp", ":Telescope find_files cwd=src/pages<CR>", { desc = "Find Pages" })
map("n", "<leader>fh", ":Telescope find_files cwd=src/hooks<CR>", { desc = "Find Hooks" })
map("n", "<leader>fu", ":Telescope find_files cwd=src/utils<CR>", { desc = "Find Utils" })
map("n", "<leader>fs", ":Telescope find_files cwd=src/styles<CR>", { desc = "Find Styles" })

-- TypeScript specific
map("n", "<leader>ti", "<cmd>lua vim.lsp.buf.organize_imports()<CR>", { desc = "Organize Imports" })
map("n", "<leader>tr", "<cmd>lua vim.lsp.buf.rename()<CR>", { desc = "Rename Symbol" })
map("n", "<leader>ta", "<cmd>lua vim.lsp.buf.code_action()<CR>", { desc = "Code Actions" })

-- Console.log debugging
map("n", "<leader>cl", "oconsole.log('');<Esc>hi", { desc = "Insert console.log" })
map("n", "<leader>cv", "oconsole.log('', );<Esc>hhi", { desc = "Insert console.log with variable" })

-- React snippets
map("n", "<leader>rfc", "i// @ts-nocheck<CR>import React from 'react';<CR><CR>const ComponentName = () => {<CR>return (<CR><div><CR></div><CR>)<CR>}<CR><CR>export default ComponentName<Esc>", { desc = "React Functional Component" })

-- ========== LARAVEL SHORTCUTS ==========
map("n", "<leader>lc", ":Telescope find_files cwd=app/Http/Controllers<CR>", { desc = "Laravel: Controllers" })
map("n", "<leader>ls", ":Telescope find_files cwd=app/Services<CR>", { desc = "Laravel: Services" })
map("n", "<leader>lr", ":Telescope find_files cwd=app/Repositories<CR>", { desc = "Laravel: Repositories" })
map("n", "<leader>lR", ":Telescope find_files cwd=app/Http/Resources<CR>", { desc = "Laravel: Resources" })
map("n", "<leader>lq", ":Telescope find_files cwd=app/Http/Requests<CR>", { desc = "Laravel: Requests" })
map("n", "<leader>lm", ":Telescope find_files cwd=app/Http/Middleware<CR>", { desc = "Laravel: Middleware" })
map("n", "<leader>lo", ":Telescope find_files cwd=app/Http/Responses<CR>", { desc = "Laravel: Responses" })
map("n", "<leader>lp", ":Telescope find_files cwd=app/Policies<CR>", { desc = "Laravel: Policies" })
map("n", "<leader>Ld", "<cmd>LaravelDumps<cr>", { desc = "Laravel: Dump viewer" })

-- ========== COMPETITIVE PROGRAMMING ==========

-- C++ template
map("n", "<leader>cc", function()
  if SetCPTemplate then
    SetCPTemplate()
  else
    vim.notify("SetCPTemplate function not available", vim.log.levels.WARN)
  end
end, { desc = "Insert CP template" })

-- Compile and run shortcuts
map("n", "<F5>", function()
  vim.cmd("w")
  local ext = vim.fn.expand("%:e")
  
  if ext == "cpp" then
    local filename = vim.fn.expand("%:r")
    local compile_result = vim.fn.system(string.format("g++ -std=c++17 -O2 -Wall -o %s %s 2>&1", filename, vim.fn.expand("%")))
    
    if vim.v.shell_error == 0 then
      vim.cmd("CompetiTest run")
    else
      vim.notify("Compilation failed:\n" .. compile_result, vim.log.levels.ERROR)
    end
  else
    vim.notify("Not a C++ file!", vim.log.levels.WARN)
  end
end, { desc = "Compile and run tests" })

map("n", "<F9>", function()
  vim.cmd("w")
  local filename = vim.fn.expand("%:r")
  local ext = vim.fn.expand("%:e")
  
  if ext == "cpp" then
    vim.cmd("!clear")
    local compile_cmd = string.format("g++ -std=c++17 -O2 -Wall -o %s %s", filename, vim.fn.expand("%"))
    vim.cmd("!" .. compile_cmd)
    
    if vim.v.shell_error == 0 then
      vim.cmd("split | terminal ./" .. filename)
      vim.cmd("resize 15")
      vim.cmd("startinsert")
    else
      vim.notify("Compilation failed!", vim.log.levels.ERROR)
    end
  else
    vim.notify("Not a C++ file!", vim.log.levels.WARN)
  end
end, { desc = "Compile and run C++ directly" })

-- Test case management
map("n", "<leader>rr", function()
  vim.cmd("w")
  vim.cmd("CompetiTest run")
end, { desc = "Save and run tests" })

map("n", "<leader>rt", "<cmd>CompetiTest add_testcase<cr>", { desc = "Add test case" })
map("n", "<leader>re", "<cmd>CompetiTest edit_testcase<cr>", { desc = "Edit test case" })
map("n", "<leader>rd", "<cmd>CompetiTest delete_testcase<cr>", { desc = "Delete test case" })
map("n", "<leader>ro", "<cmd>CompetiTest show_ui<cr>", { desc = "Show/Open test UI" })

-- ========== GENERAL SHORTCUTS ==========

-- Quick save
map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>", { desc = "Save file" })

-- Quit shortcuts
map("n", "<leader>q", "<cmd>q<cr>", { desc = "Quit" })
map("n", "<leader>Q", "<cmd>qa!<cr>", { desc = "Force quit all" })

-- Buffer navigation
map("n", "<leader>bn", "<cmd>enew<cr>", { desc = "New buffer" })
map("n", "<Tab>", "<cmd>bnext<cr>", { desc = "Next buffer" })
map("n", "<S-Tab>", "<cmd>bprev<cr>", { desc = "Previous buffer" })

-- Enhanced navigation
map("n", "<C-h>", "<C-w>h", { desc = "Switch window left" })
map("n", "<C-l>", "<C-w>l", { desc = "Switch window right" })
map("n", "<C-j>", "<C-w>j", { desc = "Switch window down" })
map("n", "<C-k>", "<C-w>k", { desc = "Switch window up" })

-- Split navigation
map("n", "<leader>sv", "<cmd>vsplit<cr>", { desc = "Vertical split" })
map("n", "<leader>sh", "<cmd>split<cr>", { desc = "Horizontal split" })

-- Format shortcuts
map("n", "<leader>fm", function()
  local conform = require("conform")
  if conform then
    conform.format({ lsp_fallback = true })
  else
    vim.lsp.buf.format()
  end
end, { desc = "Format file" })

-- Format on save toggle
local format_on_save = true
map("n", "<leader>ft", function()
  format_on_save = not format_on_save
  if format_on_save then
    vim.notify("Format on save: ENABLED", vim.log.levels.INFO)
  else
    vim.notify("Format on save: DISABLED", vim.log.levels.INFO)
  end
end, { desc = "Toggle format on save" })

-- Diagnostics
map("n", "<leader>d", vim.diagnostic.open_float, { desc = "Floating diagnostic" })
map("n", "[d", vim.diagnostic.goto_prev, { desc = "Prev diagnostic" })
map("n", "]d", vim.diagnostic.goto_next, { desc = "Next diagnostic" })
map("n", "<leader>dl", "<cmd>Telescope diagnostics<cr>", { desc = "List diagnostics" })

-- LSP shortcuts (general)
map("n", "gd", vim.lsp.buf.definition, { desc = "Go to definition" })
map("n", "gD", vim.lsp.buf.declaration, { desc = "Go to declaration" })
map("n", "gi", vim.lsp.buf.implementation, { desc = "Go to implementation" })
map("n", "gr", vim.lsp.buf.references, { desc = "Show references" })
map("n", "K", vim.lsp.buf.hover, { desc = "Hover documentation" })

-- Telescope shortcuts
map("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "Find files" })
map("n", "<leader>fa", "<cmd>Telescope find_files follow=true no_ignore=true hidden=true<cr>", { desc = "Find all files" })
map("n", "<leader>fw", "<cmd>Telescope live_grep<cr>", { desc = "Live grep" })
map("n", "<leader>fb", "<cmd>Telescope buffers<cr>", { desc = "Find buffers" })
map("n", "<leader>fh", "<cmd>Telescope help_tags<cr>", { desc = "Help tags" })
map("n", "<leader>fo", "<cmd>Telescope oldfiles<cr>", { desc = "Recent files" })
map("n", "<leader>fz", "<cmd>Telescope current_buffer_fuzzy_find<cr>", { desc = "Find in current buffer" })
map("n", "<leader>fg", "<cmd>Telescope git_status<cr>", { desc = "Git status" })

-- Terminal
map("n", "<leader>tt", "<cmd>ToggleTerm<cr>", { desc = "Toggle terminal" })
map("t", "<C-x>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- DAP (Debugger)
map("n", "<Leader>db", "<cmd>lua require'dap'.toggle_breakpoint()<CR>", { desc = "Toggle breakpoint" })
map("n", "<Leader>dc", "<cmd>lua require'dap'.continue()<CR>", { desc = "Continue" })
map("n", "<Leader>di", "<cmd>lua require'dap'.step_into()<CR>", { desc = "Step into" })
map("n", "<Leader>do", "<cmd>lua require'dap'.step_over()<CR>", { desc = "Step over" })
map("n", "<Leader>dO", "<cmd>lua require'dap'.step_out()<CR>", { desc = "Step out" })
map("n", "<Leader>dr", "<cmd>lua require'dap'.repl.toggle()<CR>", { desc = "Toggle REPL" })
map("n", "<Leader>dl", "<cmd>lua require'dap'.run_last()<CR>", { desc = "Run last" })
map("n", "<Leader>du", "<cmd>lua require'dapui'.toggle()<CR>", { desc = "Toggle DAP UI" })
map("n", "<Leader>dt", "<cmd>lua require'dap'.terminate()<CR>", { desc = "Terminate" })

-- ========== VISUAL MODE SHORTCUTS ==========

-- Move lines up/down
map("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move line down" })
map("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move line up" })

-- Indent
map("v", "<", "<gv", { desc = "Indent left" })
map("v", ">", ">gv", { desc = "Indent right" })

-- Better paste (don't yank replaced text)
map("v", "p", '"_dP', { desc = "Paste without yank" })
