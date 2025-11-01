-- ~/.config/nvim/lua/plugins/init.lua
-- Enhanced plugins for competitive programming + web development

local overrides = require("configs.overrides")

return {
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

  -- Code formatting with Conform
  {
    "stevearc/conform.nvim",
    event = "BufWritePre",
    opts = {
      formatters_by_ft = {
        -- C++ (competitive programming)
        cpp = { "clang-format" },
        c = { "clang-format" },
        
        -- Web development
        javascript = { "prettier" },
        typescript = { "prettier" },
        javascriptreact = { "prettier" },
        typescriptreact = { "prettier" },
        json = { "prettier" },
        jsonc = { "prettier" },
        yaml = { "prettier" },
        markdown = { "prettier" },
        html = { "prettier" },
        css = { "prettier" },
        scss = { "prettier" },
        less = { "prettier" },
        graphql = { "prettier" },
        
        -- Other
        lua = { "stylua" },
        python = { "isort", "black" },
      },

      format_on_save = {
        timeout_ms = 500,
        lsp_fallback = true,
      },
    },
    config = function(_, opts)
      require("conform").setup(opts)
    end,
  },

  -- Linting with nvim-lint
  {
    "mfussenegger/nvim-lint",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      local lint = require("lint")
      
      lint.linters_by_ft = {
        javascript = { "eslint_d" },
        typescript = { "eslint_d" },
        javascriptreact = { "eslint_d" },
        typescriptreact = { "eslint_d" },
      }
      
      -- Auto-lint on save and text change
      local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })
      
      vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
        group = lint_augroup,
        callback = function()
          lint.try_lint()
        end,
      })
    end,
  },

  -- Competitive Programming
  {
    "xeluxee/competitest.nvim",
    dependencies = { "MunifTanjim/nui.nvim" },
    config = function()
      require("competitest").setup({
        template_file = { cpp = "~/competitive-programming/template.cpp" },
        testcases_directory = "./testcases",
        compile_command = {
          cpp = { exec = "g++", args = {"-Wall", "-Wextra", "-std=c++17", "-O2", "-o", "$(FNOEXT)", "$(FNAME)"} },
        },
        run_command = { cpp = { exec = "./$(FNOEXT)" } },
        multiple_testing = -1,
        maximum_time = 5000,
      })
    end,
    cmd = { "CompetiTest" },
  },

  -- Snippet support
  {
    "L3MON4D3/LuaSnip",
    dependencies = { "rafamadriz/friendly-snippets" },
    config = function()
      require("luasnip.loaders.from_vscode").lazy_load()
      local ls = require("luasnip")
      local s = ls.snippet
      local t = ls.text_node
      local i = ls.insert_node
      local extras = require("luasnip.extras")
      local rep = extras.rep
      -- C++ snippets
      ls.add_snippets("cpp", {
        s("template", {
          t({
            "#include <bits/stdc++.h>",
            "using namespace std;",
            "",
            "#define int long long",
            "#define MOD 1000000007",
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
            "    int t = 1;",
            "    cin >> t;",
            "    while (t--) solve();",
            "    return 0;",
            "}"
          })
        }),
      })
      
     -- React/TypeScript snippets
          ls.add_snippets("javascript", {
      s("log", { -- Console log một biến
        t("console.log('"),
        i(1, "variable"),
        t(":', "),
        rep(1),
        t(");"),
      }),
      s("af", { -- Arrow function
        t("("),
        i(1, "params"),
        t(") => {"),
        i(0),
        t({"", "}"}),
      }),
    })

       ls.add_snippets("typescriptreact", {
      s("rfc", {
          t({"import React from 'react';", "", "interface Props {", "  "}),
          i(1, ""),
          t({"", "}", "", "const "}),
          i(2, "ComponentName"),
          t({": React.FC<Props> = () => {", "  return (", "    <div>", "      "}),
          i(3, ""),
          t({"", "    </div>", "  );", "};", "", "export default "}),
          rep(2),
          t(";")
      }),
      -- Thêm một snippet useState tiện lợi hơn
      s("usf", {
          t("const ["),
          i(1, "state"),
          t(", set"),
          -- Tự động viết hoa chữ cái đầu
          ls.function_node(function(args)
            local state_val = args[1][1] or ""
            return state_val:sub(1,1):upper() .. state_val:sub(2)
          end, {1}),
          t("] = useState("),
          i(2, "initialState"),
          t(");")
      })
    })
  end,
}, 
  -- Enhanced clipboard
  {
    "ojroques/nvim-osc52",
    config = function()
      require('osc52').setup { max_length = 0, silent = false, trim = false }
    end,
  },

  -- Notifications
  {
    "rcarriga/nvim-notify",
    config = function()
      require("notify").setup({
        stages = "fade_in_slide_out",
        timeout = 3000,
        max_width = 50,
      })
      vim.notify = require("notify")
    end,
  },

  -- Auto pairs
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function()
      local autopairs = require("nvim-autopairs")
      autopairs.setup({
        check_ts = true,
        ts_config = {
          lua = { "string" },
          javascript = { "template_string" },
          typescript = { "template_string" },
        },
        disable_filetype = { "TelescopePrompt", "vim" },
        fast_wrap = {
          map = '<M-e>',
          chars = { '{', '[', '(', '"', "'" },
          pattern = [=[[%'%"%>%]%)%}%,]]=],
          end_key = '$',
          keys = 'qwertyuiopzxcvbnmasdfghjkl',
          check_comma = true,
          highlight = 'Search',
          highlight_grey = 'Comment'
        },
      })
      
      -- Integration with cmp
      local cmp_autopairs = require("nvim-autopairs.completion.cmp")
      local cmp = require("cmp")
      cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
    end,
  },

  -- Auto close tags for React/HTML
  {
    "windwp/nvim-ts-autotag",
    event = "InsertEnter",
    config = function()
      require("nvim-ts-autotag").setup({
        opts = {
          enable_close = true,
          enable_rename = true,
          enable_close_on_slash = true,
        },
        filetypes = {
          "html",
          "javascript",
          "typescript",
          "javascriptreact",
          "typescriptreact",
          "svelte",
          "vue",
          "tsx",
          "jsx",
          "xml",
          "markdown",
        },
      })
    end,
  },

  -- Comment plugin
  {
    "numToStr/Comment.nvim",
    event = "VeryLazy",
    dependencies = { "JoosepAlviste/nvim-ts-context-commentstring" },
    config = function()
      require("Comment").setup({
        pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
      })
    end,
  },

  -- Context commentstring
  {
    "JoosepAlviste/nvim-ts-context-commentstring",
    event = "VeryLazy",
    config = function()
      require("ts_context_commentstring").setup({
        enable_autocmd = false,
      })
    end,
  },

  -- Surround plugin
  {
    "kylechui/nvim-surround",
    event = "VeryLazy",
    config = function()
      require("nvim-surround").setup({})
    end,
  },

  -- Git signs
  {
    "lewis6991/gitsigns.nvim",
    event = "BufReadPre",
    config = function()
      require("gitsigns").setup({
        signs = {
          add = { text = "│" },
          change = { text = "│" },
          delete = { text = "_" },
          topdelete = { text = "‾" },
          changedelete = { text = "~" },
          untracked = { text = "┆" },
        },
      })
    end,
  },

  -- Indent guides
  {
    "lukas-reineke/indent-blankline.nvim",
    event = "BufReadPre",
    config = function()
      require("ibl").setup({
        indent = { char = "│" },
        scope = { enabled = false },
        exclude = {
          filetypes = {
            "help", "alpha", "dashboard", "nvdash", "nvchad",
            "neo-tree", "Trouble", "lazy", "mason", "notify",
          },
        },
      })
    end,
  },

  -- Better escape
  {
    "max397574/better-escape.nvim",
    event = "InsertEnter",
    config = function()
      require("better_escape").setup({
        mapping = { "jk", "jj" },
        timeout = vim.o.timeoutlen,
      })
    end,
  },

  -- Color highlighter for CSS/Tailwind
  {
    "NvChad/nvim-colorizer.lua",
    event = "BufReadPre",
    config = function()
      require("colorizer").setup({
        user_default_options = {
          tailwind = true,
          RGB = true,
          RRGGBB = true,
          names = false,
          RRGGBBAA = true,
          rgb_fn = true,
          hsl_fn = true,
          css = true,
          css_fn = true,
          mode = "background",
        },
      })
    end,
  },

  -- TypeScript utilities
  {
    "pmizio/typescript-tools.nvim",
    dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
    ft = { "typescript", "typescriptreact", "javascript", "javascriptreact" },
    config = function()
      require("typescript-tools").setup({
        settings = {
          expose_as_code_action = "all",
          tsserver_file_preferences = {
            includeInlayParameterNameHints = "all",
            includeInlayParameterNameHintsWhenArgumentMatchesName = false,
            includeInlayFunctionParameterTypeHints = true,
            includeInlayVariableTypeHints = true,
            includeInlayPropertyDeclarationTypeHints = true,
            includeInlayFunctionLikeReturnTypeHints = true,
            includeInlayEnumMemberValueHints = true,
          },
        },
      })
    end,
  },

  -- JSON schemas
  {
    "b0o/schemastore.nvim",
    ft = { "json", "jsonc" },
  },

  -- Tailwind CSS colorizer in virtual text
  {
    "themaxmarchuk/tailwindcss-colors.nvim",
    config = function()
      require("tailwindcss-colors").setup()
    end,
  },

  -- Package info for package.json
  {
    "vuki656/package-info.nvim",
    dependencies = { "MunifTanjim/nui.nvim" },
    ft = "json",
    config = function()
      require("package-info").setup()
    end,
  },

  -- Better quickfix window
  {
    "kevinhwang91/nvim-bqf",
    ft = "qf",
    config = function()
      require("bqf").setup()
    end,
  },

  -- Todo comments
  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    event = "BufReadPost",
    config = function()
      require("todo-comments").setup()
    end,
  },

  -- Trouble (better diagnostics)
  {
    "folke/trouble.nvim",
    cmd = { "TroubleToggle", "Trouble" },
    config = function()
      require("trouble").setup({
        use_diagnostic_signs = true,
      })
    end,
  },
}
