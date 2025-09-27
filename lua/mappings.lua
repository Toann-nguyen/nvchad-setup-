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

-- NEW: F6 for compile and run with manual input in CompetiTest UI
map("n", "<F6>", function()
  vim.cmd("w")
  local filename = vim.fn.expand("%:r")
  local ext = vim.fn.expand("%:e")
  
  if ext == "cpp" then
    -- Compile the file
    local compile_cmd = string.format("g++ -std=c++17 -O2 -Wall -o %s %s 2>&1", filename, vim.fn.expand("%"))
    local compile_result = vim.fn.system(compile_cmd)
    
    if vim.v.shell_error == 0 then
      -- Prompt user to input manually
      vim.ui.input({ prompt = "Enter input for the program: " }, function(input)
        if input then
          -- Create a temporary input file or pass input directly
          local tmp_input = vim.fn.tempname() .. ".txt"
          vim.fn.writefile(vim.split(input, "\n"), tmp_input)
          
          -- Run CompetiTest with custom input
          vim.cmd("CompetiTest run --input " .. tmp_input)
          
          -- Cleanup temporary file
          vim.defer_fn(function()
            vim.fn.delete(tmp_input)
          end, 1000)
        else
          vim.notify("No input provided, skipping run.", vim.log.levels.WARN)
        end
      end)
    else
      vim.notify("Compilation failed:\n" .. compile_result, vim.log.levels.ERROR)
    end
  else
    vim.notify("Not a C++ file!", vim.log.levels.WARN)
  end
end, { desc = "Compile and run with manual input in UI" })

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

-- THÊM: Extra Laravel keymaps (từ features: Tinker, dump server, dev server)
map("n", "<leader>ln", function() Laravel.extensions.tinker.ui() end, { desc = "Laravel: Open Tinker UI" })
map("n", "<leader>ld", function() Laravel.extensions.dump_server.toggle() end, { desc = "Laravel: Toggle Dump Server" })
map("n", "<leader>ls", function() Laravel.extensions.dev_server.start() end, { desc = "Laravel: Start Dev Server" })
map("n", "<leader>lS", function() Laravel.extensions.dev_server.stop() end, { desc = "Laravel: Stop Dev Server" })

-- Override gf
-- FIXED: Simple F5 mapping for direct input testing
map("n", "<F5>", function()
  -- Save file first
  vim.cmd("w")
  -- Run test with UI where you can input directly
  vim.cmd("CompetiTest run")
end, { desc = "Save and run with direct input" })

-- Nvim DAP
map("n", "<Leader>dl", "<cmd>lua require'dap'.step_into()<CR>", { desc = "Debugger step into" })
map("n", "<Leader>dj", "<cmd>lua require'dap'.step_over()<CR>", { desc = "Debugger step over" })
map("n", "<Leader>dk", "<cmd>lua require'dap'.step_out()<CR>", { desc = "Debugger step out" })
map("n", "<Leader>dc", "<cmd>lua require'dap'.continue()<CR>", { desc = "Debugger continue" })
map("n", "<Leader>db", "<cmd>lua require'dap'.toggle_breakpoint()<CR>", { desc = "Debugger toggle breakpoint" })
map(
	"n",
	"<Leader>dd",
	"<cmd>lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>",
	{ desc = "Debugger set conditional breakpoint" }
)
map("n", "<Leader>de", "<cmd>lua require'dap'.terminate()<CR>", { desc = "Debugger reset" })
map("n", "<Leader>dr", "<cmd>lua require'dap'.run_last()<CR>", { desc = "Debugger run last" })

-- rustaceanvim
map("n", "<Leader>dt", "<cmd>lua vim.cmd('RustLsp testables')<CR>", { desc = "Debugger testables" })
