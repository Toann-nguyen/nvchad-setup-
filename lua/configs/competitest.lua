-- ~/.config/nvim/lua/configs/competitest.lua
-- Cấu hình competitive testing plugin

require("competitest").setup({
  -- Template configuration
  template_file = {
    cpp = "~/competitive-programming/template.cpp",
  },
  
  -- Test cases directory
  testcases_directory = "./testcases",
  testcases_use_single_file = false,
  
  -- Compiler settings cho C++
  compile_command = {
    cpp = { exec = "g++", args = {"-Wall", "-Wextra", "-Wpedantic", "-std=c++17", "-O2", "-o", "$(FNOEXT)", "$(FNAME)"} },
  },
  
  running_directory = "./",
  run_command = {
    cpp = { exec = "./$(FNOEXT)" },
  },
  
  -- Multiple test cases support
  multiple_testing = -1,
  maximum_time = 5000,
  
  -- Output settings
  output_compare_method = "squish",
  view_output = true,
  
  -- UI configuration
  popup_width = 0.8,
  popup_height = 0.8,
  popup_ui = {
    total_width = 0.8,
    total_height = 0.8,
    layout = {
      { 4, "tc" },
      { 4, {
          { 2, "so" }, 
          { 2, "eo" },
        },
      },
      { 4, {
          { 2, "si" }, 
          { 2, "se" },
        },
      },
    },
  },
  
  -- Split configuration
  split_ui = {
    position = "right",
    relative_to_editor = true,
    total_width = 0.4,
    vertical_layout = {
      { 1, "tc" },
      { 1, { { 1, "so" }, { 1, "eo" } } },
      { 1, { { 1, "si" }, { 1, "se" } } },
    },
    total_height = 0.4,
    horizontal_layout = {
      { 2, "tc" },
      { 3, { { 1, "so" }, { 1, "si" } } },
      { 3, { { 1, "eo" }, { 1, "se" } } },
    },
  },

  -- Auto save before running
  save_current_file = true,
  save_all_files = false,
  
  -- Custom commands
  companion_port = 27121,
  receive_print_message = true,
  
  -- Key mappings inside the test UI
  testcases_input_name = "input",
  testcases_output_name = "output",
  
  -- Evaluate configuration
  evaluate = {
    eval_command = {
      cpp = { exec = "./$(FNOEXT)" },
    },
  },
})

-- Custom function to create C++ template
function SetCPTemplate()
  local template = {
    "#include <bits/stdc++.h>",
    "using namespace std;",
    "",
    "#define int long long",
    "#define MOD 1000000007",
    "#define MAX 1e6",
    "#define pb push_back",
    "#define mp make_pair", 
    "#define fi first",
    "#define se second",
    "#define all(x) (x).begin(), (x).end()",
    "#define rall(x) (x).rbegin(), (x).rend()",
    "",
    "void solve() {",
    "    // Your solution here",
    "}",
    "",
    "int32_t main() {",
    "    ios_base::sync_with_stdio(false);",
    "    cin.tie(NULL);",
    "    ",
    "    int t = 1;",
    "    cin >> t;",
    "    ",
    "    while (t--) {",
    "        solve();",
    "    }",
    "    ",
    "    return 0;",
    "}",
  }
  
  -- Clear current buffer and insert template
  vim.api.nvim_buf_set_lines(0, 0, -1, false, template)
  -- Move cursor to solve function
  vim.api.nvim_win_set_cursor(0, {14, 4})
end

-- Auto-insert template for new .cpp files
vim.api.nvim_create_autocmd("BufNewFile", {
  pattern = "*.cpp",
  callback = function()
    SetCPTemplate()
  end,
})

-- Additional keymaps for competitive programming
local function map(mode, lhs, rhs, desc)
  vim.keymap.set(mode, lhs, rhs, { desc = desc, silent = true })
end

-- Competition specific keymaps
map("n", "<F5>", function()
  vim.cmd("w")
  require("competitest").run()
end, "Run tests")

map("n", "<F9>", function()
  vim.cmd("w")
  vim.cmd("!clear")
  local filename = vim.fn.expand("%:r")
  vim.cmd("!g++ -std=c++17 -O2 -Wall -o " .. filename .. " " .. vim.fn.expand("%"))
  if vim.v.shell_error == 0 then
    vim.cmd("split | terminal ./" .. filename)
  end
end, "Compile and run")

map("n", "<leader>cc", function()
  SetCPTemplate()
end, "Insert CP template")

map("n", "<leader>rr", function()
  require("competitest").run()
end, "Run all tests")

map("n", "<leader>rt", function()
  require("competitest").add_testcase()
end, "Add test case")

map("n", "<leader>re", function()
  require("competitest").edit_testcase()
end, "Edit test case")

map("n", "<leader>rd", function()
  require("competitest").delete_testcase()
end, "Delete test case")
