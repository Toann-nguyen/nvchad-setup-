-- ~/.config/nvim/lua/plugins/init.lua
-- Enhanced config for C++, PHP/Laravel, React/TypeScript/TailwindCSS

local overrides = require("configs.overrides")

return {
  {
  "b0o/schemastore.nvim",
},

  {
  'mrcjkb/rustaceanvim',
  version = '^6',
  lazy = false,
  config = function()
    local mason_registry = require("mason-registry")

    if not mason_registry.is_installed("codelldb") then
      vim.notify("codelldb chưa được cài, chạy :MasonInstall codelldb", vim.log.levels.ERROR)
      return
    end
    
  -- Lấy thông tin package và kiểm tra xem có lấy được không
  local codelldb = mason_registry.get_package('codelldb')
  if not codelldb then
    vim.notify("Không thể lấy thông tin package 'codelldb' từ Mason.", vim.log.levels.ERROR)
    return
  end

    local codelldb = mason_registry.get_package("codelldb")
    local extension_path = codelldb:get_install_dir() .. "/extension/"
    local codelldb_path = extension_path .. "adapter/codelldb"
    local liblldb_path = extension_path .. "lldb/lib/liblldb.so"

    local cfg = require("rustaceanvim.config")
    vim.g.rustaceanvim = {
      server = {
        on_attach = function(client, bufnr)
          -- config LSP riêng
        end,
        settings = {
          ["rust-analyzer"] = {
            cargo = { allFeatures = true },
          },
        },
      },
      dap = {
        adapter = cfg.get_codelldb_adapter(codelldb_path, liblldb_path),
      },
    }
  end,
},

  {
    'rust-lang/rust.vim',
    ft = "rust",
    init = function()
      vim.g.rustfmt_autosave = 1
    end
  },

  -- DAP (Debugger)
  {
    "mfussenegger/nvim-dap",
    config = function()
      local dap, dapui = require("dap"), require("dapui")
      dap.listeners.before.attach.dapui_config = function()
        dapui.open()
      end
      dap.listeners.before.launch.dapui_config = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated.dapui_config = function()
        dapui.close()
      end
      dap.listeners.before.event_exited.dapui_config = function()
        dapui.close()
      end
    end,
  },

  {
    "rcarriga/nvim-dap-ui",
    dependencies = {
      "mfussenegger/nvim-dap",
      "nvim-neotest/nvim-nio",
    },
    config = function()
      require("dapui").setup()
    end,
  },

  {
    'saecki/crates.nvim',
    ft = {"toml"},
    config = function()
      require("crates").setup {
        completion = {
          cmp = {
            enabled = true
          },
        },
      }
      require('cmp').setup.buffer({
        sources = { { name = "crates" }}
      })
    end
  },

  -- ========== REACT/TYPESCRIPT/TAILWIND SETUP ==========
  
  -- TypeScript/JavaScript LSP & Tools
  {
    "pmizio/typescript-tools.nvim",
    dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
    ft = { "typescript", "typescriptreact", "javascript", "javascriptreact" },
    opts = {
      settings = {
        tsserver_file_preferences = {
          includeInlayParameterNameHints = "all",
          includeInlayParameterNameHintsWhenArgumentMatchesName = true,
          includeInlayFunctionParameterTypeHints = true,
          includeInlayVariableTypeHints = true,
          includeInlayPropertyDeclarationTypeHints = true,
          includeInlayFunctionLikeReturnTypeHints = true,
          includeInlayEnumMemberValueHints = true,
        },
      },
    },
  },

  -- Tailwind CSS support
  {
    "neovim/nvim-lspconfig",
    config = function()
      require("nvchad.configs.lspconfig").defaults()
      require("configs.lspconfig")
    end,
  },

  -- Auto-pairing brackets
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function()
      require("nvim-autopairs").setup({
        check_ts = true,
        ts_config = {
          lua = { "string" },
          javascript = { "template_string" },
          typescript = { "template_string" },
        },
        fast_wrap = {
          map = '<M-e>',
          chars = { '{', '[', '(', '"', "'" },
          pattern = [=[[%'%"%>%]%)%}%,]]=],
          end_key = '$',
          keys = 'qwertyuiopzxcvbnmasdfghjkl',
          check_comma = true,
          highlight = 'Search',
          highlight_grey='Comment'
        },
      })
      
      -- Integration with cmp
      local cmp_autopairs = require('nvim-autopairs.completion.cmp')
      local cmp = require('cmp')
      cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done())
    end,
  },

  -- Auto close/rename HTML tags
  {
    "windwp/nvim-ts-autotag",
    ft = {
      "html",
      "javascript",
      "javascriptreact",
      "typescript",
      "typescriptreact",
      "vue",
      "xml",
      "php",
      "markdown",
    },
    config = function()
      require("nvim-ts-autotag").setup({
        opts = {
          enable_close = true,
          enable_rename = true,
          enable_close_on_slash = false
        },
      })
    end,
  },

  -- Colorize color codes (#fff, rgb(), etc)
  {
    "norcalli/nvim-colorizer.lua",
    ft = { "css", "scss", "html", "javascript", "typescript", "jsx", "tsx" },
    config = function()
      require("colorizer").setup({
        "css",
        "scss",
        "html",
        "javascript",
        "typescript",
        "javascriptreact",
        "typescriptreact",
      }, {
        RGB = true,
        RRGGBB = true,
        names = true,
        RRGGBBAA = true,
        rgb_fn = true,
        hsl_fn = true,
        css = true,
        css_fn = true,
      })
    end,
  },

  -- Emmet for HTML/CSS
  {
    "mattn/emmet-vim",
    ft = { "html", "css", "javascriptreact", "typescriptreact" },
    config = function()
      vim.g.user_emmet_leader_key = '<C-Z>'
      vim.g.user_emmet_settings = {
        javascript = {
          extends = 'jsx',
        },
        typescript = {
          extends = 'tsx',
        },
      }
    end,
  },

  -- GitHub Copilot (optional)
  {
    "github/copilot.vim",
    event = "InsertEnter",
    config = function()
      vim.g.copilot_no_tab_map = true
      vim.keymap.set('i', '<C-J>', 'copilot#Accept("\\<CR>")', {
        expr = true,
        replace_keycodes = false
      })
      vim.g.copilot_filetypes = {
        ["*"] = false,
        javascript = true,
        typescript = true,
        lua = true,
        rust = true,
        c = true,
        cpp = true,
        python = true,
        php = true,
      }
    end,
  },

  -- ========== END REACT/TYPESCRIPT SETUP ==========

  -- Snacks.nvim (for Laravel)
  {
    "folke/snacks.nvim",
    lazy = true,
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-lua/plenary.nvim",
    },
    opts = {
      ui = {
        border = "rounded",
      },
    },
  },

  -- Laravel dependencies
  {
    "tpope/vim-dotenv",
    event = "VeryLazy",
  },
  
  {
    "nvim-neotest/nvim-nio",
    lazy = true,
  },

  -- Laravel.nvim
  {
    "adalessa/laravel.nvim",
    dependencies = {
      "tpope/vim-dotenv",
      "MunifTanjim/nui.nvim",
      "nvim-lua/plenary.nvim",
      "nvim-neotest/nvim-nio",
    },
    cmd = { "Laravel" },
    keys = {
      { "<leader>ll", function() require("laravel.pickers.laravel"):run() end, desc = "Laravel: Picker" },
      { "<leader>la", function() require("laravel.pickers.artisan"):run() end, desc = "Laravel: Artisan" },
      { "<leader>lr", function() require("laravel.pickers.routes"):run() end, desc = "Laravel: Routes" },
      { "<leader>lm", function() require("laravel.pickers.make"):run() end, desc = "Laravel: Make" },
    },
    event = { "VeryLazy" },
    opts = {
      lsp_server = "intelephense",
      features = {
        pickers = {
          provider = "snacks",
        },
      },
    },
  },

  -- Core plugins
  {
    "nvim-treesitter/nvim-treesitter",
    opts = overrides.treesitter,
  },

  {
    "williamboman/mason.nvim",
    opts = overrides.mason,
  },

  {
    "hrsh7th/nvim-cmp",
    opts = overrides.cmp,
  },

  -- Telescope
  {
    "nvim-telescope/telescope.nvim",
    tag = '0.1.8',
    dependencies = { 
      'nvim-lua/plenary.nvim',
      {
        'nvim-telescope/telescope-fzf-native.nvim',
        build = 'make',
        cond = function()
          return vim.fn.executable 'make' == 1
        end,
      },
    },
    cmd = "Telescope",
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
        pickers = {
          find_files = {
            hidden = true,
            find_command = { "rg", "--files", "--hidden", "--glob", "!.git/*" },
          },
        },
      })
      pcall(telescope.load_extension, 'fzf')
    end,
  },

  -- Code formatting
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
        javascriptreact = { "prettier" },
        typescript = { "prettier" },
        typescriptreact = { "prettier" },
        tsx = { "prettier" },
        html = { "prettier" },
        css = { "prettier" },
        scss = { "prettier" },
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
        prettier = {
          prepend_args = { "--single-quote", "--jsx-single-quote" },
        },
      },
    },
    config = function(_, opts)
      require("conform").setup(opts)
      
      vim.keymap.set({ "n", "v" }, "<leader>fm", function()
        require("conform").format({ lsp_fallback = true })
      end, { desc = "Format files" })
    end,
  },

  -- Competitive Programming
  {
    "xeluxee/competitest.nvim",
    dependencies = { "MunifTanjim/nui.nvim" },
    config = function()
      require("competitest").setup({
        testcases_directory = "./testcases",
        testcases_use_single_file = true,
        
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
        
        multiple_testing = 1,
        maximum_time = 5000,
        output_compare_method = "squish",
        view_output = true,
        
        popup_width = 0.95,
        popup_height = 0.95,
        popup_ui = {
          total_width = 0.95,
          total_height = 0.95,
          layout = {
            { 1, "tc" },
            { 4, {
                { 1, "si" },
                { 1, "so" },
              },
            },
            { 3, {
                { 1, "eo" },
                { 1, "se" },
              },
            },
          },
        },
        
        save_current_file = true,
        save_all_files = false,
        companion_port = 27121,
        receive_print_message = true,
      })
    end,
    cmd = { "CompetiTest" },
    keys = {
      { "<F5>", function()
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
    end,
  },

  -- Enhanced clipboard
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
