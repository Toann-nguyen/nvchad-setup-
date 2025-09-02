-- ~/.config/nvim/lua/configs/luasnip.lua
-- Cấu hình LuaSnip cho competitive programming

local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

-- Competitive programming snippets
ls.add_snippets("cpp", {
  -- Basic template
  s("template", {
    t({
      "#include <bits/stdc++.h>",
      "using namespace std;",
      "",
      "#define int long long",
      "#define MOD 1000000007",
      "#define pb push_back",
      "#define mp make_pair",
      "#define all(x) (x).begin(), (x).end()",
      "",
      "void solve() {",
      "    "
    }),
    i(1, "// Your code here"),
    t({
      "",
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
      "}"
    })
  }),
  
  -- Fast I/O
  s("fastio", {
    t({
      "ios_base::sync_with_stdio(false);",
      "cin.tie(NULL);"
    })
  }),
  
  -- Vector declaration
  s("vi", {
    t("vector<int> "), i(1, "name"), t("("), i(2, "size"), t(");")
  }),
  
  -- For loop
  s("for", {
    t("for (int "), i(1, "i"), t(" = "), i(2, "0"), t("; "), 
    ls.rep(1), t(" < "), i(3, "n"), t("; "), ls.rep(1), t("++) {"),
    t({"", "    "}), i(4),
    t({"", "}"})
  }),
  
  -- Debug macro
  s("debug", {
    t("#define debug(x) cout << #x << \" = \" << x << endl")
  }),
})

-- Enable autotrigger
ls.config.setup({
  enable_autosnippets = true,
})

-----------------------------------------------------------

-- ~/.config/nvim/lua/configs/osc52.lua
-- Enhanced clipboard support cho competitive programming

local function copy(lines, _)
  require('osc52').copy(table.concat(lines, '\n'))
end

local function paste()
  return {vim.fn.split(vim.fn.getreg(''), '\n'), vim.fn.getregtype('')}
end

vim.g.clipboard = {
  name = 'osc52',
  copy = {
    ['+'] = copy,
    ['*'] = copy,
  },
  paste = {
    ['+'] = paste,
    ['*'] = paste,
  },
}

-- Setup OSC52
require('osc52').setup {
  max_length = 0,  -- Maximum length of selection (0 for no limit)
  silent = false,  -- Disable message on successful copy
  trim = false,    -- Trim surrounding whitespaces before copy
}

-- Enhanced copy functions
local function copy_buffer()
  local content = table.concat(vim.api.nvim_buf_get_lines(0, 0, -1, false), '\n')
  require('osc52').copy(content)
  vim.notify("Buffer copied to clipboard!")
end

local function copy_selection()
  local start_pos = vim.fn.getpos("'<")
  local end_pos = vim.fn.getpos("'>")
  
  local start_row = start_pos[2] - 1
  local end_row = end_pos[2] - 1
  
  local lines = vim.api.nvim_buf_get_lines(0, start_row, end_row + 1, false)
  
  if #lines == 1 then
    local start_col = start_pos[3] - 1
    local end_col = end_pos[3]
    lines[1] = string.sub(lines[1], start_col + 1, end_col)
  else
    lines[1] = string.sub(lines[1], start_pos[3])
    lines[#lines] = string.sub(lines[#lines], 1, end_pos[3])
  end
  
  local content = table.concat(lines, '\n')
  require('osc52').copy(content)
  vim.notify("Selection copied to clipboard!")
end

-- Keymaps
vim.keymap.set('n', '<leader>cb', copy_buffer, { desc = "Copy entire buffer" })
vim.keymap.set('v', '<leader>cs', copy_selection, { desc = "Copy selection" })
