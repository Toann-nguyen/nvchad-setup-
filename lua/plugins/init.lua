-- ~/.config/nvim/lua/plugins/init.lua
-- Cấu hình tất cả plugins cho competitive programming

local overrides = require("configs.overrides")

return {
    -- Disable default plugins không cần thiết
  {
    "NvChad/nvterm",
    enabled = false,
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

  -- Competitive Programming plugins
  {
    "xeluxee/competitest.nvim",
    dependencies = { "MunifTanjim/nui.nvim" },
    config = function()
      require("configs.competitest")
    end,
    cmd = { "CompetiTest", "CompetiTestAdd", "CompetiTestEdit", "CompetiTestDelete" },
    keys = {
      { "<leader>rr", "<cmd>CompetiTest run<cr>", desc = "Run tests" },
      { "<leader>rt", "<cmd>CompetiTest add_testcase<cr>", desc = "Add test case" },
      { "<leader>rc", "<cmd>CompetiTest edit_template<cr>", desc = "Edit template" },
    },
  },

  -- Code formatting
  {
    "stevearc/conform.nvim",
    event = "BufWritePre",
    config = function()
      require("configs.conform")
    end,
  },

  -- Snippet support
  {
    "L3MON4D3/LuaSnip",
    dependencies = {
      "rafamadriz/friendly-snippets",
    },
    config = function()
      require("luasnip.loaders.from_vscode").lazy_load()
      require("configs.luasnip")
    end,
  },

  -- Enhanced clipboard support
  {
    "ojroques/nvim-osc52",
    config = function()
      require("configs.osc52")
    end,
  },

  -- Additional utilities for CP
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


  {
    "stevearc/conform.nvim",
    -- event = 'BufWritePre', -- uncomment for format on save
    opts = require "configs.conform",
  },

  -- These are some examples, uncomment them if you want to see them work!
  {
    "neovim/nvim-lspconfig",
    config = function()
      require "configs.lspconfig"
    end,
  },

  -- test new blink
  -- { import = "nvchad.blink.lazyspec" },

  -- {
  -- 	"nvim-treesitter/nvim-treesitter",
  -- 	opts = {
  -- 		ensure_installed = {
  -- 			"vim", "lua", "vimdoc",
  --      "html", "css"
  -- 		},
  -- 	},
  -- },
}
