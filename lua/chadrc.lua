-- This file needs to have same structure as nvconfig.lua 
-- https://github.com/NvChad/ui/blob/v3.0/lua/nvconfig.lua
-- Please read that file to know all available options :( 

---@type ChadrcConfig
local M = {}
-- Base46 theme configuration
M.base46 = {
  theme = "bearded-arc",
  transparency = false,
  hl_add = {},
  hl_override = {},
  integrations = { "cmp", "telescope", "treesitter", "mason" },
  changed_themes = {},
  theme_toggle = { "bearded-arc", "one_light" },
}

-- UI configuration
M.ui = {
  cmp = {
    lspkind_text = true,
    style = "default",
    format_colors = {
      tailwind = false,
    },
  },

  telescope = { 
    style = "borderless" 
  },

  statusline = {
    theme = "default",
    separator_style = "default",
    order = { "mode", "file", "git", "%=", "lsp_msg", "%=", "diagnostics", "lsp", "cwd", "cursor" },
    modules = nil,
  },
-- THÊM: Laravel Lualine items (verbatim từ README)
    items = {
      {
        function()
          local ok, laravel_version = pcall(function()
            return Laravel.app("status"):get("laravel")
          end)
          if ok then
            return laravel_version
          end
        end,
        icon = { "", color = { fg = "#F55247" } },
        cond = function()
          local ok, has_laravel_versions = pcall(function()
            return Laravel.app("status"):has("laravel")
          end)
          return ok and has_laravel_versions
        end,
      },
      {
        function()
          local ok, php_version = pcall(function()
            return Laravel.app("status"):get("php")
          end)
          if ok then
            return php_version
          end
          return nil
        end,
        icon = { "", color = { fg = "#AEB2D5" } },
        cond = function()
          local ok, has_php_version = pcall(function()
            return Laravel.app("status"):has("php")
          end)
          return ok and has_php_version
        end,
      },
      {
        function()
          local ok, hostname = pcall(function()
            return Laravel.extensions.composer_dev.hostname()
          end)
          if ok then
            return hostname
          end
          return nil
        end,
        icon = { "", color = { fg = "#8FBC8F" } },
        cond = function()
          local ok, is_running = pcall(function()
            return Laravel.extensions.composer_dev.isRunning()
          end)
          return ok and is_running
        end,
      },
      {
        function()
          local ok, unseen_records = pcall(function()
            return #(Laravel.extensions.dump_server.unseenRecords())
          end)

          if ok then
            return unseen_records
          end
          return 0
        end,
        icon = { "󰱧 ", color = { fg = "#FFCC66" } },
        cond = function()
          local ok, is_running = pcall(function()
            return Laravel.extensions.dump_server.isRunning()
          end)

          return ok and is_running
        end,
      },
    },
  },

  tabufline = {
    enabled = true,
    lazyload = true,
    order = { "treeOffset", "buffers", "tabs", "btns" },
    modules = nil,
  },
  nvdash = {
    load_on_startup = false,
    header = {
      "                            ",
      "   ▄████▄   ██▓███  ██▓███   ",
      "  ▒██▀ ▀█  ▓██░  ██▓██░  ██▒ ",
      "  ▒▓█    ▄ ▓██░ ██▓▓██░ ██▓▒ ",
      "  ▒▓▓▄ ▄██▒▒██▄█▓▒ ▒██▄█▓▒ ▒ ",
      "  ▒ ▓███▀ ░▒██▒ ░  ░▒██▒ ░  ░ ",
      "  ░ ░▒ ▒  ░▒▓▒░ ░  ░▒▓▒░ ░  ░ ",
      "    ░  ▒   ░▒ ░     ░▒ ░      ",
      "  ░        ░░       ░░        ",
      "  ░ ░                        ",
      "  ░       Competitive Programming",
      "                            ",
    },

    buttons = {
      { txt = "  New Problem", keys = "Spc n", cmd = "enew | call SetCPTemplate()" },
      { txt = "  Find Files", keys = "Spc f f", cmd = "Telescope find_files" },
      { txt = "  Recent Files", keys = "Spc f o", cmd = "Telescope oldfiles" },
      { txt = "  Run Tests", keys = "Spc r r", cmd = "CompetitestRunNormal" },
      -- THÊM: Laravel buttons
      { txt = "  Artisan Cmd", keys = "Spc L a", cmd = "Artisan" },
      { txt = "  Routes List", keys = "Spc L r", cmd = "LaravelRoute" },
      { txt = "  Dump Viewer", keys = "Spc L d", cmd = "LaravelDumps" },
    { txt = "  Laravel Picker", keys = "Spc l l", cmd = "Laravel" },  -- THÊM
    { txt = "  Artisan", keys = "Spc l a", cmd = "lua Laravel.pickers.artisan()" },
    },
  }
}
-- Terminal configuration
M.term = {
  winopts = { number = false },
  sizes = { sp = 0.3, vsp = 0.2, ["bo sp"] = 0.3, ["bo vsp"] = 0.2 },
  float = {
    relative = "editor",
    row = 0.3,
    col = 0.25,
    width = 0.5,
    height = 0.4,
    border = "single",
  },
}

-- LSP configuration
M.lsp = { 
  signature = true 
}

-- Mason packages to install
M.mason = {
  pkgs = {
    "clangd",
    "clang-format",
    "cpptools",
    "intelephense",
    "php-cs-fixer",
  }
}
return M
