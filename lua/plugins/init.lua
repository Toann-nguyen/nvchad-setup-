-- ~/.config/nvim/lua/plugins/init.lua
-- Cấu hình tất cả plugins cho competitive programming

local overrides = require("configs.overrides")

return {
  -- THÊM: Snacks.nvim (required cho pickers provider mặc định của laravel.nvim)
  {
    "folke/snacks.nvim",
    lazy = true,
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-lua/plenary.nvim",
    },
    opts = {
      -- Default config from repo (brief)
      ui = {
        border = "rounded",
      },
    },
  },
  -- THÊM: Dependencies cho laravel.nvim (nui, plenary, nio đã có; thêm vim-dotenv và mcphub optional)
  {
    "tpope/vim-dotenv",  -- Required cho .env completions
    event = "VeryLazy",
  },
  {
    "nvim-neotest/nvim-nio",  -- Required cho async
    lazy = true,
  },
  {
    "ravitemer/mcphub.nvim",  -- Optional cho mcphub integration (skip nếu không cần)
    lazy = true,
  },

  -- THÊM: adalessa/laravel.nvim (verbatim từ README, với opts lsp_server = "intelephense" để match config bạn)
  {
    "adalessa/laravel.nvim",
    dependencies = {
      "tpope/vim-dotenv",
      "MunifTanjim/nui.nvim",
      "nvim-lua/plenary.nvim",
      "nvim-neotest/nvim-nio",
      "ravitemer/mcphub.nvim", -- optional
    },
  -- Telescope setup với tag 0.1.8
  {
    "nvim-telescope/telescope.nvim",
    tag = '0.1.8',  -- Tag ổn định từ GitHub
    dependencies = { 
      'nvim-lua/plenary.nvim'  -- Dependency bắt buộc
    },
    cmd = "Telescope",
    config = function()
      require("telescope").setup({})
    end,
  },
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
    cmd = { "Laravel" },
    keys = {
      { "<leader>ll", function() Laravel.pickers.laravel() end,              desc = "Laravel: Open Laravel Picker" },
      { "<c-g>",      function() Laravel.commands.run("view:finder") end,    desc = "Laravel: Open View Finder" },
      { "<leader>la", function() Laravel.pickers.artisan() end,              desc = "Laravel: Open Artisan Picker" },
      { "<leader>lt", function() Laravel.commands.run("actions") end,        desc = "Laravel: Open Actions Picker" },
      { "<leader>lr", function() Laravel.pickers.routes() end,               desc = "Laravel: Open Routes Picker" },
      { "<leader>lh", function() Laravel.run("artisan docs") end,            desc = "Laravel: Open Documentation" },
      { "<leader>lm", function() Laravel.pickers.make() end,                 desc = "Laravel: Open Make Picker" },
      { "<leader>lc", function() Laravel.pickers.commands() end,             desc = "Laravel: Open Commands Picker" },
      { "<leader>lo", function() Laravel.pickers.resources() end,            desc = "Laravel: Open Resources Picker" },
      { "<leader>lp", function() Laravel.commands.run("command_center") end, desc = "Laravel: Open Command Center" },
      {
        "gf",
        function()
          local ok, res = pcall(function()
            if Laravel.app("gf").cursorOnResource() then
              return "<cmd>lua Laravel.commands.run('gf')<cr>"
            end
          end)
          if not ok or not res then
            return "gf"
          end
          return res
        end,
        expr = true,
        noremap = true,
      },
    },
    event = { "VeryLazy" },
    opts = {
      lsp_server = "intelephense", -- "phpactor | intelephense" (match config bạn)
      features = {
        pickers = {
          provider = "snacks", -- "snacks | telescope | fzf-lua | ui-select" (mặc định snacks)
        },
      },
    },
  },
-- THÊM: Laravel.nvim (load cho PHP/Blade, dependencies plenary đã có)
  {
    "adibhanna/laravel.nvim",
    ft = { "php", "blade" },  -- Lazy load cho file PHP/Blade
    dependencies = {
      "nvim-telescope/telescope.nvim",  -- Đã có, cho route/view finder
      "nvim-lua/plenary.nvim",         -- Đã có
      "nvim-treesitter/nvim-treesitter", -- Đã có, cho parsing
    },
    config = function()
      require("laravel").setup({
        -- Config mặc định từ docs (có thể customize sau)
        root_dir = {
          "composer.json",
          ".git",
          "artisan",
        },
        -- Enable dump viewer (tự động capture dump()/dd())
        dump = {
          enable = true,
          open = "current",  -- Mở dump viewer trong buffer hiện tại
        },
        -- Artisan/Composer integration
        artisan = {
          bin = "php artisan",  -- Hoặc "sail artisan" nếu dùng Sail
        },
        composer = {
          bin = "composer",
        },
        -- Autocompletion cache (30s như docs)
        cache = {
          ttl = 30,
        },
      })
      -- Đăng ký commands/keymaps tự động từ plugin
    end,
    cmd = { "Artisan", "Composer", "LaravelMake", "LaravelRoute", "LaravelStatus" },  -- Commands chính
  },
  -- Telescope setup
  {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    dependencies = {
      "nvim-lua/plenary.nvim", -- Dependency bắt buộc
      {
        "nvim-telescope/telescope-fzf-native.nvim", -- Tùy chọn, tăng tốc độ tìm kiếm
        build = "make", -- Compile với make
        cond = function()
          return vim.fn.executable("make") == 1 -- Kiểm tra make có sẵn
        end,
      },
    },
    config = function()
      local telescope = require("telescope")
      telescope.setup({
        defaults = {
          mappings = {
            i = {
              ["<C-j>"] = require("telescope.actions").move_selection_next,
              ["<C-k>"] = require("telescope.actions").move_selection_previous,
            },
          },
        },
      })
      -- Load extension fzf nếu có
      pcall(require("telescope").load_extension, "fzf")
    end,
  },

  -- Code formatting - Fixed configuration
  {
    "stevearc/conform.nvim",
    event = "BufWritePre",
    opts = {
      formatters_by_ft = {
        cpp = { "clang-format" },
        c = { "clang-format" },
        php = { "php-cs-fixer" },
        lua = { "stylua" },
        python = { "isort", "black" },
        javascript = { "prettier" },
        typescript = { "prettier" },
        tsx = { "prettier" },
        html = { "prettier" },
        css = { "prettier" },
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

  -- PHP/Laravel support
  {
    "phpactor/phpactor",
    ft = "php",
    build = "composer install --no-dev",
    config = function()
      require("phpactor").setup()
    end,
  },
  -- Frontend support (ReactJS, NextJS, HTML/CSS)
  {
    "mxsdev/nvim-dap-vscode-js",
    ft = { "javascript", "typescript", "javascriptreact", "typescriptreact" },
    config = function()
      require("dap-vscode-js").setup({
        debugger_path = vim.fn.stdpath("data") .. "/mason/packages/js-debug-adapter",
      })
    end,
  },

  {
    "jose-elias-alvarez/null-ls.nvim",
    config = function()
      local null_ls = require("null-ls")
      null_ls.setup({
        sources = {
          null_ls.builtins.formatting.prettier.with({
            filetypes = { "javascript", "typescript", "css", "html", "json" },
          }),
        },
      })
    end,
  },

  {
    "MunifTanjim/prettier.nvim",
    ft = { "javascript", "typescript", "css", "html", "json" },
    config = function()
      require("prettier").setup()
    end,
  },

  -- Telescope cho tìm kiếm
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("telescope").setup()
    end,
  },

  -- FIXED: Competitive Programming plugins
  {
    "xeluxee/competitest.nvim",
    dependencies = { "MunifTanjim/nui.nvim" },
    config = function()
      require("competitest").setup({
        -- Không sử dụng testcase files, chỉ dùng input trực tiếp
        testcases_directory = "./testcases",
        testcases_use_single_file = true,  -- Changed to true
        
        -- FIXED: Compile command
        compile_command = {
          cpp = { 
            exec = "g++", 
            args = {
              "-std=c++17", 
              "-O2", 
              "-Wall", 
              "-o", 
              "$(FNOEXT)", 
              "$(FNAME)"
            } 
          },
        },
        
        running_directory = "./",
        run_command = {
          cpp = { exec = "./$(FNOEXT)" },
        },
        
        -- FIXED: Test settings
        multiple_testing = 1,  -- Changed to 1 for single test
        maximum_time = 5000,
        
        output_compare_method = "squish",  -- Back to squish for flexible comparison
        view_output = true,
        
        -- FIXED: UI configuration để có thể edit input trực tiếp
        popup_width = 0.95,
        popup_height = 0.95,
        popup_ui = {
          total_width = 0.95,
          total_height = 0.95,
          layout = {
            { 1, "tc" },  -- Test cases selection
            { 4, {        -- Main content area
                { 1, "si" },  -- Standard input (editable)
                { 1, "so" },  -- Standard output
              },
            },
            { 3, {        -- Expected and error area
                { 1, "eo" },  -- Expected output
                { 1, "se" },  -- Standard error
              },
            },
          },
        },
        
        -- Split UI configuration (alternative layout)
        split_ui = {
          position = "right",
          relative_to_editor = true,
          total_width = 0.5,
          vertical_layout = {
            { 1, "si" },  -- Input area (editable)
            { 2, { { 1, "so" }, { 1, "eo" } } }, -- Output comparison
            { 1, "se" },  -- Error area
          },
        },
        
        -- FIXED: Auto-save settings
        save_current_file = true,
        save_all_files = false,
        
        -- Companion settings
        companion_port = 27121,
        receive_print_message = true,
        
        -- FIXED: Testcase naming
        testcases_input_name = "input",
        testcases_output_name = "output",
        
        -- FIXED: Editor integration
        editor_ui = {
          editor_split_horizontal = false,
          editor_split_vertical = true,
        },
      })
      
      -- FIXED: Remove auto-create testcase files - use direct input instead
      -- No autocmd needed for file-based testcases
    end,
    cmd = { "CompetiTest", "CompetiTestAdd", "CompetiTestEdit", "CompetiTestDelete", "CompetiTestRun" },
    keys = {
      { "<F5>", function()
        -- Auto save before running
        vim.cmd("w")
        vim.cmd("CompetiTest run")
      end, desc = "Save and run tests" },
      { "<leader>rr", function()
        vim.cmd("w")
        vim.cmd("CompetiTest run")
      end, desc = "Save and run tests" },
      { "<leader>rt", "<cmd>CompetiTest add_testcase<cr>", desc = "Add test case" },
      { "<leader>re", "<cmd>CompetiTest edit_testcase<cr>", desc = "Edit test case" },
      { "<leader>rd", "<cmd>CompetiTest delete_testcase<cr>", desc = "Delete test case" },
      { "<leader>ro", "<cmd>CompetiTest show_ui<cr>", desc = "Show test UI" },
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
            "#include <iostream>",
            "using namespace std;",
            "",
            "int main() {",
            "    ios_base::sync_with_stdio(false);",
            "    cin.tie(NULL);",
            "    ",
            "    "
          }),
          i(1, "cout << \"hello\" << endl;"),
          t({
            "",
            "    return 0;",
            "}",
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
