-- ~/.config/nvim/lua/configs/lazy.lua
-- Fixed lazy configuration

return {
  defaults = {
    lazy = false,
    version = false,
  },
  
  install = {
    missing = true,
    colorscheme = { "nvchad" },
  },
  
  checker = {
    enabled = true,
    notify = false,
  },
  
  change_detection = {
    enabled = true,
    notify = false,
  },
  
  ui = {
    size = { width = 0.8, height = 0.8 },
    wrap = true,
    border = "rounded",
    title = nil,
    title_pos = "center",
    pills = true,
    icons = {
      cmd = " ",
      config = "",
      event = "",
      ft = " ",
      init = " ",
      import = " ",
      keys = " ",
      lazy = "󰒲 ",
      loaded = "●",
      not_loaded = "○",
      plugin = " ",
      runtime = " ",
      require = "󰢱 ",
      source = " ",
      start = "",
      task = "✔ ",
      list = {
        "●",
        "➜",
        "★",
        "‒",
      },
    },
  },
  
  performance = {
    rtp = {
      disabled_plugins = {
        "gzip",
        "matchit",
        "matchparen",
        "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
}