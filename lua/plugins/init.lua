-- ~/.config/nvim/lua/plugins/init.lua
-- Cấu hình tất cả plugins cho competitive programming

local overrides = require("configs.overrides")

return {
  -- Core plugins cần override
  {
    "nvim-treesitter/nvim-treesitter",
    opts = overrides.treesitter,
  },

  {
    "williamboman/mason.nvim",
    opts = overrides.mason,
  },

  {
    "neovim/nvim-lspconfig",
    config = function()
      require("nvchad.configs.lspconfig").defaults()
      require("configs.lspconfig")
    end,
  },

  {
    "hrsh7th/nvim-cmp",
    opts = overrides.cmp,
  },

  -- Code formatting - Fixed configuration
  {
    "stevearc/conform.nvim",
    event = "BufWritePre",
    opts = {
      formatters_by_ft = {
        cpp = { "clang-format" },
        c = { "clang-format" },
        lua = { "stylua" },
        python = { "isort", "black" },
        javascript = { "prettier" },
        typescript = { "prettier" },
        json = { "prettier" },
        yaml = { "prettier" },
        markdown = { "prettier" },
      },

      format_on_save = {
        timeout_ms = 500,
        lsp_fallback = true,
      },

      formatters = {
        ["clang-format"] = {
          args = {
            "--style={BasedOnStyle: Google, IndentWidth: 2, TabWidth: 2, UseTab: Never, "
            .. "ColumnLimit: 100, AllowShortFunctionsOnASingleLine: Empty, "
            .. "AllowShortIfStatementsOnASingleLine: true, "
            .. "AllowShortLoopsOnASingleLine: true, "
            .. "BinPackArguments: false, "
            .. "BinPackParameters: false, "
            .. "BreakBeforeBraces: Attach, "
            .. "Cpp11BracedListStyle: true, "
            .. "SpaceBeforeParens: ControlStatements}",
          },
        },
      },
    },
    config = function(_, opts)
      require("conform").setup(opts)
      
      -- Manual format keymap
      vim.keymap.set({ "n", "v" }, "<leader>fm", function()
        require("conform").format({ lsp_fallback = true })
      end, { desc = "Format files" })
    end,
  },

  -- Competitive Programming plugins
  {
    "xeluxee/competitest.nvim",
    dependencies = { "MunifTanjim/nui.nvim" },
    config = function()
      require("competitest").setup({
        template_file = {
          cpp = "~/competitive-programming/template.cpp",
        },
        
        testcases_directory = "./testcases",
        testcases_use_single_file = false,
        
        compile_command = {
          cpp = { exec = "g++", args = {"-Wall", "-Wextra", "-Wpedantic", "-std=c++17", "-O2", "-o", "$(FNOEXT)", "$(FNAME)"} },
        },
        
        running_directory = "./",
        run_command = {
          cpp = { exec = "./$(FNOEXT)" },
        },
        
        multiple_testing = -1,
        maximum_time = 5000,
        
        output_compare_method = "squish",
        view_output = true,
        
        popup_width = 0.8,
        popup_height = 0.8,
        
        save_current_file = true,
        save_all_files = false,
        
        companion_port = 27121,
        receive_print_message = true,
      })
    end,
    cmd = { "CompetiTest", "CompetiTestAdd", "CompetiTestEdit", "CompetiTestDelete" },
    keys = {
      { "<F5>", "<cmd>CompetiTest run<cr>", desc = "Run tests" },
      { "<leader>rr", "<cmd>CompetiTest run<cr>", desc = "Run tests" },
      { "<leader>rt", "<cmd>CompetiTest add_testcase<cr>", desc = "Add test case" },
      { "<leader>re", "<cmd>CompetiTest edit_testcase<cr>", desc = "Edit test case" },
      { "<leader>rd", "<cmd>CompetiTest delete_testcase<cr>", desc = "Delete test case" },
    },
  },

  -- Snippet support
  {
    "L3MON4D3/LuaSnip",
    dependencies = {
      "rafamadriz/friendly-snippets",
    },
    config = function()
      require("luasnip.loaders.from_vscode").lazy_load()
      local ls = require("luasnip")
      local s = ls.snippet
      local t = ls.text_node
      local i = ls.insert_node

      -- Competitive programming snippets
      ls.add_snippets("cpp", {
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
        
        s("fastio", {
          t({
            "ios_base::sync_with_stdio(false);",
            "cin.tie(NULL);"
          })
        }),
        
        s("vi", {
          t("vector<int> "), i(1, "name"), t("("), i(2, "size"), t(");")
        }),
        
        })
    end,
  },

  -- Enhanced clipboard support
  {
    "ojroques/nvim-osc52",
    config = function()
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

      require('osc52').setup {
        max_length = 0,
        silent = false,
        trim = false,
      }
    end,
  },

  -- Notifications
  {
    "rcarriga/nvim-notify",
    config = function()
      require("notify").setup({
        stages = "fade_in_slide_out",
        background_colour = "FloatShadow",
        timeout = 3000,
      })
      vim.notify = require("notify")
    end,
  },
}
