require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")

-- FIXED: Enhanced F5 mapping for better testing
map("n", "<F5>", function()
  -- Save file first
  vim.cmd("w")
  
  -- Check if it's a cpp file
  if vim.fn.expand("%:e") == "cpp" then
    -- Compile first
    local filename = vim.fn.expand("%:r")
    local compile_result = vim.fn.system(string.format("g++ -std=c++17 -O2 -Wall -o %s %s 2>&1", filename, vim.fn.expand("%")))
    
    if vim.v.shell_error == 0 then
      -- If compilation successful, run with competitest
      vim.cmd("CompetiTest run")
    else
      -- Show compilation error
      vim.notify("Compilation failed:\n" .. compile_result, vim.log.levels.ERROR)
    end
  else
    vim.notify("Not a C++ file!", vim.log.levels.WARN)
  end
end, { desc = "Compile and run tests" })

-- FIXED: F9 for direct run without test framework
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
      -- Focus on terminal and enter insert mode
      vim.cmd("startinsert")
    else
      vim.notify("Compilation failed!", vim.log.levels.ERROR)
    end
  else
    vim.notify("Not a C++ file!", vim.log.levels.WARN)
  end
end, { desc = "Compile and run C++ directly" })

-- Template insertion
map("n", "<leader>cc", function()
  if SetCPTemplate then
    SetCPTemplate()
  else
    vim.notify("SetCPTemplate function not available", vim.log.levels.WARN)
  end
end, { desc = "Insert CP template" })

-- Quick save
map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>", { desc = "Save file" })

-- Additional competitive programming keymaps  
map("n", "<leader>rr", function()
  vim.cmd("w")
  vim.cmd("CompetiTest run")
end, { desc = "Save and run tests" })

map("n", "<leader>rt", "<cmd>CompetiTest add_testcase<cr>", { desc = "Add test case" })
map("n", "<leader>re", "<cmd>CompetiTest edit_testcase<cr>", { desc = "Edit test case" })
map("n", "<leader>rd", "<cmd>CompetiTest delete_testcase<cr>", { desc = "Delete test case" })
map("n", "<leader>ro", "<cmd>CompetiTest show_ui<cr>", { desc = "Show/Open test UI" })

-- FIXED: Simple F5 mapping for direct input testing
map("n", "<F5>", function()
  -- Save file first
  vim.cmd("w")
  -- Run test with UI where you can input directly
  vim.cmd("CompetiTest run")
end, { desc = "Save and run with direct input" })
