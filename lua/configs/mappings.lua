require "nvchad.mappings"

local map = vim.keymap.set

-- Basic mappings
map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")
map("i", "jj", "<ESC>")

-- Enhanced clipboard operations
map({ "n", "v" }, "<C-c>", '"+y', { desc = "Copy to system clipboard" })
map("n", "<C-c>", '"+yy', { desc = "Copy line to system clipboard" })
map({ "n", "v" }, "<C-v>", '"+p', { desc = "Paste from system clipboard" })
map("i", "<C-v>", "<C-r>+", { desc = "Paste from system clipboard (insert)" })
map("n", "<leader>ca", "ggVG\"+y", { desc = "Copy entire buffer to clipboard" })

-- ================== COMPETITIVE PROGRAMMING ==================
-- C++ Template
map("n", "<leader>cc", function()
  if SetCPTemplate then
    SetCPTemplate()
  else
    vim.notify("SetCPTemplate function not loaded yet", vim.log.levels.WARN)
  end
end, { desc = "Insert CP template" })

-- F5: Run tests with competitest
map("n", "<F5>", function()
  vim.cmd("w")
  vim.cmd("CompetiTest run")
end, { desc = "Run tests with competitest" })

-- F6: Quick compile and run in split terminal
map("n", "<F6>", function()
  vim.cmd("w")
  local filename = vim.fn.expand("%:r")
  local ext = vim.fn.expand("%:e")
  
  if ext == "cpp" then
    -- Close existing terminal buffers
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
      if vim.bo[buf].buftype == "terminal" then
        vim.api.nvim_buf_delete(buf, { force = true })
      end
    end
    
    -- Compile
    local compile_cmd = string.format("g++ -std=c++17 -O2 -Wall -Wextra -o %s %s", filename, vim.fn.expand("%"))
    vim.notify("Compiling...", vim.log.levels.INFO)
    local compile_output = vim.fn.system(compile_cmd)
    
    if vim.v.shell_error == 0 then
      vim.notify("Compilation successful! Running...", vim.log.levels.INFO)
      vim.cmd("split | terminal ./" .. filename)
      vim.cmd("resize 15")
      vim.cmd("startinsert")
    else
      vim.notify("Compilation failed!\n" .. compile_output, vim.log.levels.ERROR)
    end
  else
    vim.notify("Not a C++ file!", vim.log.levels.WARN)
  end
end, { desc = "Compile and run C++ (F6)" })

-- ================== WEB DEVELOPMENT ==================
-- TypeScript/React shortcuts
map("n", "<leader>ti", function()
  vim.cmd("TSToolsOrganizeImports")
end, { desc = "Organize imports" })

map("n", "<leader>ts", function()
  vim.cmd("TSToolsSortImports")
end, { desc = "Sort imports" })

map("n", "<leader>tu", function()
  vim.cmd("TSToolsRemoveUnused")
end, { desc = "Remove unused imports" })

map("n", "<leader>tf", function()
  vim.cmd("TSToolsFixAll")
end, { desc = "Fix all" })

map("n", "<leader>ta", function()
  vim.cmd("TSToolsAddMissingImports")
end, { desc = "Add missing imports" })

-- Trouble (diagnostics)
map("n", "<leader>xx", "<cmd>TroubleToggle<cr>", { desc = "Toggle Trouble" })
map("n", "<leader>xw", "<cmd>TroubleToggle workspace_diagnostics<cr>", { desc = "Workspace diagnostics" })
map("n", "<leader>xd", "<cmd>TroubleToggle document_diagnostics<cr>", { desc = "Document diagnostics" })
map("n", "<leader>xl", "<cmd>TroubleToggle loclist<cr>", { desc = "Location list" })
map("n", "<leader>xq", "<cmd>TroubleToggle quickfix<cr>", { desc = "Quickfix" })

-- Todo comments
map("n", "]t", function()
  require("todo-comments").jump_next()
end, { desc = "Next todo comment" })

map("n", "[t", function()
  require("todo-comments").jump_prev()
end, { desc = "Previous todo comment" })

map("n", "<leader>xt", "<cmd>TodoTrouble<cr>", { desc = "Todo Trouble" })
map("n", "<leader>xT", "<cmd>TodoTelescope<cr>", { desc = "Todo Telescope" })

-- Package info (package.json)
map("n", "<leader>ns", "<cmd>lua require('package-info').show()<cr>", { desc = "Show package info" })
map("n", "<leader>nc", "<cmd>lua require('package-info').hide()<cr>", { desc = "Hide package info" })
map("n", "<leader>nt", "<cmd>lua require('package-info').toggle()<cr>", { desc = "Toggle package info" })
map("n", "<leader>nu", "<cmd>lua require('package-info').update()<cr>", { desc = "Update package" })
map("n", "<leader>nd", "<cmd>lua require('package-info').delete()<cr>", { desc = "Delete package" })
map("n", "<leader>ni", "<cmd>lua require('package-info').install()<cr>", { desc = "Install package" })
map("n", "<leader>np", "<cmd>lua require('package-info').change_version()<cr>", { desc = "Change package version" })

-- ================== TELESCOPE ==================
map("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "Find files" })
map("n", "<leader>fa", "<cmd>Telescope find_files follow=true no_ignore=true hidden=true<cr>", { desc = "Find all files" })
map("n", "<leader>fg", "<cmd>Telescope live_grep<cr>", { desc = "Live grep" })
map("n", "<leader>fb", "<cmd>Telescope buffers<cr>", { desc = "Find buffers" })
map("n", "<leader>fh", "<cmd>Telescope help_tags<cr>", { desc = "Help tags" })
map("n", "<leader>fo", "<cmd>Telescope oldfiles<cr>", { desc = "Old files" })
map("n", "<leader>fz", "<cmd>Telescope current_buffer_fuzzy_find<cr>", { desc = "Find in current buffer" })
map("n", "<leader>cm", "<cmd>Telescope git_commits<cr>", { desc = "Git commits" })
map("n", "<leader>gt", "<cmd>Telescope git_status<cr>", { desc = "Git status" })
map("n", "<leader>pt", "<cmd>Telescope terms<cr>", { desc = "Pick hidden term" })
map("n", "<leader>th", "<cmd>Telescope themes<cr>", { desc = "Themes" })

-- Quick search shortcuts (craftzdog style)
map("n", ";f", "<cmd>Telescope find_files<cr>", { desc = "Find files" })
map("n", ";r", "<cmd>Telescope live_grep<cr>", { desc = "Live grep" })
map("n", "\\\\", "<cmd>Telescope buffers<cr>", { desc = "Buffers" })
map("n", ";t", "<cmd>Telescope help_tags<cr>", { desc = "Help" })
map("n", ";;", "<cmd>Telescope resume<cr>", { desc = "Resume" })
map("n", ";e", "<cmd>Telescope diagnostics<cr>", { desc = "Diagnostics" })

-- ================== FILE NAVIGATION ==================
-- Quick save and quit
map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>", { desc = "Save file" })
map("n", "<leader>w", "<cmd>w<cr>", { desc = "Save file" })
map("n", "<leader>q", "<cmd>q<cr>", { desc = "Quit" })
map("n", "<leader>Q", "<cmd>qa!<cr>", { desc = "Force quit all" })

-- Buffer navigation
map("n", "<leader>bn", "<cmd>enew<cr>", { desc = "New buffer" })
map("n", "<S-h>", "<cmd>bprevious<cr>", { desc = "Previous buffer" })
map("n", "<S-l>", "<cmd>bnext<cr>", { desc = "Next buffer" })
map("n", "<leader>bd", "<cmd>bd<cr>", { desc = "Delete buffer" })
map("n", "<leader>x", "<cmd>bd<cr>", { desc = "Close buffer" })

-- Tab navigation
map("n", "<Tab>", "<cmd>BufferLineCycleNext<cr>", { desc = "Next tab" })
map("n", "<S-Tab>", "<cmd>BufferLineCyclePrev<cr>", { desc = "Previous tab" })

-- ================== WINDOW MANAGEMENT ==================
-- Enhanced navigation
map("n", "<C-h>", "<C-w>h", { desc = "Switch window left" })
map("n", "<C-l>", "<C-w>l", { desc = "Switch window right" })
map("n", "<C-j>", "<C-w>j", { desc = "Switch window down" })
map("n", "<C-k>", "<C-w>k", { desc = "Switch window up" })

-- Window management
map("n", "<leader>sv", "<C-w>v", { desc = "Split window vertically" })
map("n", "<leader>sh", "<C-w>s", { desc = "Split window horizontally" })
map("n", "<leader>se", "<C-w>=", { desc = "Make splits equal size" })
map("n", "<leader>sx", "<cmd>close<CR>", { desc = "Close current split" })

-- Resize windows with arrows
map("n", "<C-Up>", "<cmd>resize +2<cr>", { desc = "Increase window height" })
map("n", "<C-Down>", "<cmd>resize -2<cr>", { desc = "Decrease window height" })
map("n", "<C-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease window width" })
map("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase window width" })

-- ================== EDITING ==================
-- Move lines up/down
map("n", "<A-j>", "<cmd>m .+1<cr>==", { desc = "Move line down" })
map("n", "<A-k>", "<cmd>m .-2<cr>==", { desc = "Move line up" })
map("i", "<A-j>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move line down" })
map("i", "<A-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move line up" })
map("v", "<A-j>", ":m '>+1<cr>gv=gv", { desc = "Move selection down" })
map("v", "<A-k>", ":m '<-2<cr>gv=gv", { desc = "Move selection up" })

-- Better indenting
map("v", "<", "<gv", { desc = "Indent left" })
map("v", ">", ">gv", { desc = "Indent right" })

-- Clear search highlight
map("n", "<leader>nh", "<cmd>nohl<cr>", { desc = "Clear search highlights" })
map("n", "<Esc>", "<cmd>nohl<cr>", { desc = "Clear search highlights" })

-- Increment/decrement numbers
map("n", "<leader>+", "<C-a>", { desc = "Increment number" })
map("n", "<leader>-", "<C-x>", { desc = "Decrement number" })

-- Select all
map("n", "<C-a>", "gg<S-v>G", { desc = "Select all" })

-- Better paste
map("v", "p", '"_dP', { desc = "Paste without yanking" })

-- ================== LSP ==================
-- Format shortcuts
map("n", "<leader>fm", function()
  local conform = require("conform")
  if conform then
    conform.format({ lsp_fallback = true })
  else
    vim.lsp.buf.format()
  end
end, { desc = "Format file" })

map("v", "<leader>fm", function()
  local conform = require("conform")
  if conform then
    conform.format({ lsp_fallback = true })
  else
    vim.lsp.buf.format()
  end
end, { desc = "Format selection" })

-- Diagnostics
map("n", "<leader>d", vim.diagnostic.open_float, { desc = "Floating diagnostic" })
map("n", "[d", vim.diagnostic.goto_prev, { desc = "Prev diagnostic" })
map("n", "]d", vim.diagnostic.goto_next, { desc = "Next diagnostic" })
map("n", "<leader>dl", "<cmd>Telescope diagnostics<cr>", { desc = "List diagnostics" })

-- LSP shortcuts
map("n", "gd", vim.lsp.buf.definition, { desc = "Go to definition" })
map("n", "gD", vim.lsp.buf.declaration, { desc = "Go to declaration" })
map("n", "gi", vim.lsp.buf.implementation, { desc = "Go to implementation" })
map("n", "gr", vim.lsp.buf.references, { desc = "Show references" })
map("n", "K", vim.lsp.buf.hover, { desc = "Hover documentation" })
map("n", "<leader>rn", vim.lsp.buf.rename, { desc = "Rename" })
map("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Code action" })

-- ================== GIT ==================
-- Git signs navigation
map("n", "]c", function()
  if vim.wo.diff then
    return "]c"
  end
  vim.schedule(function()
    require("gitsigns").next_hunk()
  end)
  return "<Ignore>"
end, { expr = true, desc = "Next git hunk" })

map("n", "[c", function()
  if vim.wo.diff then
    return "[c"
  end
  vim.schedule(function()
    require("gitsigns").prev_hunk()
  end)
  return "<Ignore>"
end, { expr = true, desc = "Previous git hunk" })

-- Git actions
map("n", "<leader>hs", "<cmd>Gitsigns stage_hunk<cr>", { desc = "Stage hunk" })
map("n", "<leader>hr", "<cmd>Gitsigns reset_hunk<cr>", { desc = "Reset hunk" })
map("n", "<leader>hS", "<cmd>Gitsigns stage_buffer<cr>", { desc = "Stage buffer" })
map("n", "<leader>hu", "<cmd>Gitsigns undo_stage_hunk<cr>", { desc = "Undo stage hunk" })
map("n", "<leader>hR", "<cmd>Gitsigns reset_buffer<cr>", { desc = "Reset buffer" })
map("n", "<leader>hp", "<cmd>Gitsigns preview_hunk<cr>", { desc = "Preview hunk" })
map("n", "<leader>hb", "<cmd>Gitsigns blame_line<cr>", { desc = "Blame line" })
map("n", "<leader>hd", "<cmd>Gitsigns diffthis<cr>", { desc = "Diff this" })

-- ================== TERMINAL ==================
-- Terminal mode mappings
map("t", "<Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })
map("t", "<C-h>", "<C-\\><C-n><C-w>h", { desc = "Terminal: Switch window left" })
map("t", "<C-j>", "<C-\\><C-n><C-w>j", { desc = "Terminal: Switch window down" })
map("t", "<C-k>", "<C-\\><C-n><C-w>k", { desc = "Terminal: Switch window up" })
map("t", "<C-l>", "<C-\\><C-n><C-w>l", { desc = "Terminal: Switch window right" })

-- Toggle terminal
map({ "n", "t" }, "<A-v>", function()
  require("nvchad.term").toggle({ pos = "vsp", id = "vtoggleTerm" })
end, { desc = "Terminal: Toggle vertical" })

map({ "n", "t" }, "<A-h>", function()
  require("nvchad.term").toggle({ pos = "sp", id = "htoggleTerm" })
end, { desc = "Terminal: Toggle horizontal" })

map({ "n", "t" }, "<A-i>", function()
  require("nvchad.term").toggle({ pos = "float", id = "floatTerm" })
end, { desc = "Terminal: Toggle floating" })

-- ================== NVIMTREE ==================
map("n", "<C-n>", "<cmd>NvimTreeToggle<CR>", { desc = "Toggle nvimtree" })
map("n", "<leader>e", "<cmd>NvimTreeFocus<CR>", { desc = "Focus nvimtree" })

-- ================== COMMENT ==================
-- Handled by Comment.nvim plugin (gcc, gbc)

-- ================== MISCELLANEOUS ==================
-- Disable arrow keys in normal mode (optional - good practice)
-- map("n", "<Up>", "<Nop>")
-- map("n", "<Down>", "<Nop>")
-- map("n", "<Left>", "<Nop>")
-- map("n", "<Right>", "<Nop>")
