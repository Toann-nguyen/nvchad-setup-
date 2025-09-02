-- ~/.config/nvim/lua/configs/mappings.lua
-- Custom keymaps cho competitive programming

require "nvchad.mappings"

local map = vim.keymap.set

-- Enhanced clipboard operations
map({ "n", "v" }, "<C-c>", '"+y', { desc = "Copy to system clipboard" })
map("n", "<C-c>", '"+yy', { desc = "Copy line to system clipboard" })
map({ "n", "v" }, "<C-v>", '"+p', { desc = "Paste from system clipboard" })
map("i", "<C-v>", "<C-r>+", { desc = "Paste from system clipboard (insert)" })
map("n", "<leader>ca", "ggVG\"+y", { desc = "Copy entire buffer to clipboard" })

-- Competitive programming shortcuts
map("n", "<leader>cc", function()
  SetCPTemplate()
end, { desc = "Insert CP template" })

-- Quick compile and run
map("n", "<F5>", function()
  vim.cmd("w")
  require("competitest").run()
end, { desc = "Run tests with competitest" })

map("n", "<F9>", function()
  vim.cmd("w")
  local filename = vim.fn.expand("%:r")
  local ext = vim.fn.expand("%:e")
  
  if ext == "cpp" then
    vim.cmd("!clear")
    local compile_cmd = string.format("g++ -std=c++17 -O2 -Wall -Wextra -o %s %s", filename, vim.fn.expand("%"))
    vim.cmd("!" .. compile_cmd)
    
    if vim.v.shell_error == 0 then
      vim.cmd("split | terminal ./" .. filename)
    else
      vim.notify("Compilation failed!", vim.log.levels.ERROR)
    end
  else
    vim.notify("Not a C++ file!", vim.log.levels.WARN)
  end
end, { desc = "Compile and run C++" })

-- Competitive testing shortcuts
map("n", "<leader>rr", function()
  require("competitest").run()
end, { desc = "Run all tests" })

map("n", "<leader>rt", function()
  require("competitest").add_testcase()
end, { desc = "Add test case" })

map("n", "<leader>re", function()
  require("competitest").edit_testcase()
end, { desc = "Edit test case" })

map("n", "<leader>rd", function()
  require("competitest").delete_testcase()
end, { desc = "Delete test case" })

map("n", "<leader>rc", function()
  require("competitest").show_ui()
end, { desc = "Show competitest UI" })

-- Buffer navigation for competitive programming
map("n", "<leader>bn", "<cmd>enew<cr>", { desc = "New buffer" })
map("n", "<leader>bd", function()
  require("nvchad.tabufline").close_buffer()
end, { desc = "Delete buffer" })

-- Quick terminal
map({ "n", "t" }, "<A-i>", function()
  require("nvchad.term").toggle { pos = "float", id = "floatTerm" }
end, { desc = "Toggle floating terminal" })

map({ "n", "t" }, "<A-h>", function()
  require("nvchad.term").toggle { pos = "sp", id = "htoggleTerm" }
end, { desc = "Toggle horizontal terminal" })

map({ "n", "t" }, "<A-v>", function()
  require("nvchad.term").toggle { pos = "vsp", id = "vtoggleTerm" }
end, { desc = "Toggle vertical terminal" })

-- Enhanced navigation
map("n", "<C-h>", "<C-w>h", { desc = "Switch window left" })
map("n", "<C-l>", "<C-w>l", { desc = "Switch window right" })
map("n", "<C-j>", "<C-w>j", { desc = "Switch window down" })
map("n", "<C-k>", "<C-w>k", { desc = "Switch window up" })

-- Buffer management
for i = 1, 9, 1 do
  map("n", string.format("<A-%s>", i), function()
    vim.api.nvim_set_current_buf(vim.t.bufs[i])
  end, { desc = "Switch to buffer " .. i })
end

-- Quick save and quit
map("n", "<C-s>", "<cmd>w<cr>", { desc = "Save file" })
map("n", "<leader>q", "<cmd>q<cr>", { desc = "Quit" })
map("n", "<leader>Q", "<cmd>qa!<cr>", { desc = "Force quit all" })

-- Competitive programming utilities
map("n", "<leader>cp", function()
  -- Create new problem file
  local problem_name = vim.fn.input("Problem name: ")
  if problem_name ~= "" then
    local filename = problem_name .. ".cpp"
    vim.cmd("edit " .. filename)
    SetCPTemplate()
  end
end, { desc = "Create new CP problem" })

-- Format shortcuts
map("n", "<leader>fm", function()
  require("conform").format({ lsp_fallback = true })
end, { desc = "Format file" })

-- LSP shortcuts (additional to default NvChad)
map("n", "<leader>lf", vim.lsp.buf.format, { desc = "LSP Format" })
map("n", "<leader>lr", function()
  require("nvchad.lsp.renamer")()
end, { desc = "LSP Rename" })

-- Git shortcuts
map("n", "<leader>gs", "<cmd>Telescope git_status<cr>", { desc = "Git status" })
map("n", "<leader>gc", "<cmd>Telescope git_commits<cr>", { desc = "Git commits" })

-- Telescope shortcuts for competitive programming
map("n", "<leader>fc", "<cmd>Telescope find_files cwd=~/.config/nvim<cr>", { desc = "Find config files" })
map("n", "<leader>fp", function()
  require("telescope.builtin").find_files({
    prompt_title = "Find Problems",
    cwd = "~/competitive-programming/",
  })
end, { desc = "Find problem files" })

-- Theme switching
map("n", "<leader>th", function()
  require("nvchad.themes").open()
end, { desc = "Theme picker" })

-- Diagnostics
map("n", "<leader>d", vim.diagnostic.open_float, { desc = "Floating diagnostic" })
map("n", "[d", vim.diagnostic.goto_prev, { desc = "Prev diagnostic" })
map("n", "]d", vim.diagnostic.goto_next, { desc = "Next diagnostic" })

-- Comment toggle (if you have Comment plugin)
map("n", "<leader>/", function()
  require("Comment.api").toggle.linewise.current()
end, { desc = "Toggle comment" })

map("v", "<leader>/", "<ESC><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<CR>", { desc = "Toggle comment" })
