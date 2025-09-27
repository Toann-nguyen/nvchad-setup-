require "nvchad.mappings"

local map = vim.keymap.set

-- Basic mappings
map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")

-- Enhanced clipboard operations
map({ "n", "v" }, "<C-c>", '"+y', { desc = "Copy to system clipboard" })
map("n", "<C-c>", '"+yy', { desc = "Copy line to system clipboard" })
map({ "n", "v" }, "<C-v>", '"+p', { desc = "Paste from system clipboard" })
map("i", "<C-v>", "<C-r>+", { desc = "Paste from system clipboard (insert)" })
map("n", "<leader>ca", "ggVG\"+y", { desc = "Copy entire buffer to clipboard" })

-- In ~/.config/nvim/lua/mappings.lua
map("n", "<C-v>", '"+p', { desc = "Paste from system clipboard in Normal mode" })
map("v", "<C-v>", '"+p', { desc = "Paste from system clipboard in Visual mode" })

-- Laravel shortcuts under <leader>l
map("n", "<leader>lc", ":Telescope find_files cwd=app/Http/Controllers<CR>", opts)  -- Controller
map("n", "<leader>ls", ":Telescope find_files cwd=app/Services<CR>", opts)          -- Service
map("n", "<leader>lr", ":Telescope find_files cwd=app/Repositories<CR>", opts)      -- Repository
map("n", "<leader>lR", ":Telescope find_files cwd=app/Http/Resources<CR>", opts)    -- Resource
map("n", "<leader>lq", ":Telescope find_files cwd=app/Http/Requests<CR>", opts)     -- Request
map("n", "<leader>lm", ":Telescope find_files cwd=app/Http/Middleware<CR>", opts)   -- Middleware
map("n", "<leader>lo", ":Telescope find_files cwd=app/Http/Responses<CR>", opts)    -- Response
map("n", "<leader>lp", ":Telescope find_files cwd=app/Policies<CR>", opts)          -- Policy

-- LSP vẫn giữ nguyên (tránh conflict)
map("n", "gd", vim.lsp.buf.definition, opts)
map("n", "gD", vim.lsp.buf.declaration, opts)
map("n", "gi", vim.lsp.buf.implementation, opts)
map("n", "gr", vim.lsp.buf.references, opts)
-- Remove the { "n", "v" } combined mapping
-- Competitive programming shortcuts
map("n", "<leader>cc", function()
  if SetCPTemplate then
    SetCPTemplate()
  else
    vim.notify("SetCPTemplate function not loaded yet", vim.log.levels.WARN)
  end
end, { desc = "Insert CP template" })

-- Quick compile and run
map("n", "<F5>", function()
  vim.cmd("w")
  vim.cmd("CompetiTest run")
end, { desc = "Run tests with competitest" })

map("n", "<F9>", function()
  vim.cmd("w")
  local filename = vim.fn.expand("%:r")
  local ext = vim.fn.expand("%:e")
  
  if ext == "cpp" then
    vim.cmd("!clear")
    local compile_cmd = string.format("g++ -std=c++17 -O2 -Wall -o %s %s", filename, vim.fn.expand("%"))
    vim.cmd("!" .. compile_cmd)
    
    if vim.v.shell_error == 0 then
      vim.cmd("split | terminal ./" .. filename)  -- Giữ nguyên
      vim.cmd("resize 15")  -- Thêm: Làm split cao 15 dòng cho dễ nhập
      vim.cmd("startinsert")  -- Thêm: Auto vào insert mode để nhập ngay
    else
      vim.notify("Compilation failed!", vim.log.levels.ERROR)
    end
  else
    vim.notify("Not a C++ file!", vim.log.levels.WARN)
  end
end, { desc = "Compile and run C++ directly" })

-- Quick save and basic shortcuts
map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>", { desc = "Save file" })
map("n", "<leader>q", "<cmd>q<cr>", { desc = "Quit" })
map("n", "<leader>Q", "<cmd>qa!<cr>", { desc = "Force quit all" })

-- Buffer navigation
map("n", "<leader>bn", "<cmd>enew<cr>", { desc = "New buffer" })

-- Enhanced navigation
map("n", "<C-h>", "<C-w>h", { desc = "Switch window left" })
map("n", "<C-l>", "<C-w>l", { desc = "Switch window right" })
map("n", "<C-j>", "<C-w>j", { desc = "Switch window down" })
map("n", "<C-k>", "<C-w>k", { desc = "Switch window up" })

-- fix visual mode in vscode
map({ "n", "v" }, "<C-v>", '"+p', { desc = "Paste from system clipboard" })
-- larravel
map("n", "<leader>Ld", "<cmd>LaravelDumps<cr>", { desc = "Open Laravel dump viewer" })
-- Format shortcuts
map("n", "<leader>fm", function()
  local conform = require("conform")
  if conform then
    conform.format({ lsp_fallback = true })
  else
    vim.lsp.buf.format()
  end
end, { desc = "Format file" })

-- Diagnostics
map("n", "<leader>d", vim.diagnostic.open_float, { desc = "Floating diagnostic" })
map("n", "[d", vim.diagnostic.goto_prev, { desc = "Prev diagnostic" })
map("n", "]d", vim.diagnostic.goto_next, { desc = "Next diagnostic" })
