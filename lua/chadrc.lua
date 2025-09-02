-- This file needs to have same structure as nvconfig.lua 
-- https://github.com/NvChad/ui/blob/v3.0/lua/nvconfig.lua
-- Please read that file to know all available options :( 

---@type ChadrcConfig
local M = {}
-- Base46 theme configuration
M.base46 = {
  theme = "tokyonight",
  transparency = false,
  hl_add = {},
  hl_override = {},
  integrations = { "cmp", "telescope", "treesitter", "mason" },
  changed_themes = {},
  theme_toggle = { "tokyonight", "one_light" },
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
  }
}
return M
