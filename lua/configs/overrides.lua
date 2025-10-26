-- ~/.config/nvim/lua/configs/overrides.lua
local M = {}

-- Treesitter configuration
M.treesitter = {
  ensure_installed = {
    -- Competitive Programming
    "c",
    "cpp",
    
    -- Web Development
    "html",
    "css",
    "scss",
    "javascript",
    "typescript",
    "tsx",
    "json",
    "jsonc",
    "graphql",
    
    -- Config files
    "yaml",
    "toml",
    "vim",
    "lua",
    "vimdoc",
    "markdown",
    "markdown_inline",
    
    -- Others
    "bash",
    "regex",
  },
  
  highlight = {
    enable = true,
    use_languagetree = true,
    additional_vim_regex_highlighting = false,
  },

  indent = {
    enable = true,
  },

  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "<leader>ss",
      node_incremental = "<leader>si",
      scope_incremental = "<leader>sc",
      node_decremental = "<leader>sd",
    },
  },
  
  autotag = {
    enable = true,
  },
  
  context_commentstring = {
    enable = true,
    enable_autocmd = false,
  },
}

-- Mason configuration
M.mason = {
  ensure_installed = {
    -- C++ (Competitive Programming)
    "clangd",
    "clang-format",
    "cpptools",
    
    -- TypeScript/JavaScript
    "typescript-language-server",
    "eslint-lsp",
    "prettier",
    "eslint_d",
    
    -- HTML/CSS
    "html-lsp",
    "css-lsp",
    "tailwindcss-language-server",
    "emmet-ls",
    
    -- JSON/YAML
    "json-lsp",
    "yaml-language-server",
    
    -- Lua
    "lua-language-server",
    "stylua",
    
    -- Others
    "marksman", -- Markdown
  },
  
  ui = {
    icons = {
      package_installed = "✓",
      package_pending = "➜",
      package_uninstalled = "✗"
    }
  }
}

-- nvim-cmp configuration
M.cmp = function()
  local cmp = require("cmp")
  local luasnip = require("luasnip")
  
  local function border(hl_name)
    return {
      { "╭", hl_name },
      { "─", hl_name },
      { "╮", hl_name },
      { "│", hl_name },
      { "╯", hl_name },
      { "─", hl_name },
      { "╰", hl_name },
      { "│", hl_name },
    }
  end

  local options = {
    completion = {
      completeopt = "menu,menuone,noinsert",
    },

    window = {
      completion = {
        border = border("CmpBorder"),
        winhighlight = "Normal:CmpPmenu,CursorLine:CmpSel,Search:PmenuSel",
        scrollbar = false,
      },
      documentation = {
        border = border("CmpDocBorder"),
        winhighlight = "Normal:CmpDoc",
      },
    },
    
    snippet = {
      expand = function(args)
        luasnip.lsp_expand(args.body)
      end,
    },

    formatting = {
      fields = { "kind", "abbr", "menu" },
      format = function(entry, vim_item)
        local kind_icons = {
          Text = "",
          Method = "󰆧",
          Function = "󰊕",
          Constructor = "",
          Field = "󰇽",
          Variable = "󰂡",
          Class = "󰠱",
          Interface = "",
          Module = "",
          Property = "󰜢",
          Unit = "",
          Value = "󰎠",
          Enum = "",
          Keyword = "󰌋",
          Snippet = "",
          Color = "󰏘",
          File = "󰈙",
          Reference = "",
          Folder = "󰉋",
          EnumMember = "",
          Constant = "󰏿",
          Struct = "",
          Event = "",
          Operator = "󰆕",
          TypeParameter = "󰅲",
        }
        
        vim_item.kind = string.format("%s %s", kind_icons[vim_item.kind], vim_item.kind)
        vim_item.menu = ({
          nvim_lsp = "[LSP]",
          luasnip = "[Snippet]",
          buffer = "[Buffer]",
          path = "[Path]",
          nvim_lua = "[Lua]",
        })[entry.source.name]
        
        -- Show source for tailwind colors
        if vim_item.kind == "Color" then
          vim_item.menu = "[Color]"
        end
        
        return vim_item
      end,
    },

    mapping = {
      ["<C-p>"] = cmp.mapping.select_prev_item(),
      ["<C-n>"] = cmp.mapping.select_next_item(),
      ["<C-d>"] = cmp.mapping.scroll_docs(-4),
      ["<C-f>"] = cmp.mapping.scroll_docs(4),
      ["<C-Space>"] = cmp.mapping.complete(),
      ["<C-e>"] = cmp.mapping.close(),
      ["<CR>"] = cmp.mapping.confirm({
        behavior = cmp.ConfirmBehavior.Replace,
        select = true,
      }),
      ["<Tab>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_next_item()
        elseif luasnip.expand_or_jumpable() then
          luasnip.expand_or_jump()
        else
          fallback()
        end
      end, { "i", "s" }),
      ["<S-Tab>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_prev_item()
        elseif luasnip.jumpable(-1) then
          luasnip.jump(-1)
        else
          fallback()
        end
      end, { "i", "s" }),
    },
    
    sources = {
      { name = "nvim_lsp", priority = 1000 },
      { name = "luasnip", priority = 750 },
      { name = "buffer", priority = 500 },
      { name = "nvim_lua", priority = 400 },
      { name = "path", priority = 250 },
    },
    
    experimental = {
      ghost_text = true,
    },
  }
  
  return options
end

-- Telescope configuration
M.telescope = {
  defaults = {
    vimgrep_arguments = {
      "rg",
      "-L",
      "--color=never",
      "--no-heading",
      "--with-filename",
      "--line-number",
      "--column",
      "--smart-case",
    },
    prompt_prefix = "   ",
    selection_caret = "  ",
    entry_prefix = "  ",
    initial_mode = "insert",
    selection_strategy = "reset",
    sorting_strategy = "ascending",
    layout_strategy = "horizontal",
    layout_config = {
      horizontal = {
        prompt_position = "top",
        preview_width = 0.55,
        results_width = 0.8,
      },
      vertical = {
        mirror = false,
      },
      width = 0.87,
      height = 0.80,
      preview_cutoff = 120,
    },
    file_sorter = require("telescope.sorters").get_fuzzy_file,
    file_ignore_patterns = { "node_modules", ".git/", "dist/", "build/", ".next/" },
    generic_sorter = require("telescope.sorters").get_generic_fuzzy_sorter,
    path_display = { "truncate" },
    winblend = 0,
    border = {},
    borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
    color_devicons = true,
    set_env = { ["COLORTERM"] = "truecolor" },
    file_previewer = require("telescope.previewers").vim_buffer_cat.new,
    grep_previewer = require("telescope.previewers").vim_buffer_vimgrep.new,
    qflist_previewer = require("telescope.previewers").vim_buffer_qflist.new,
    buffer_previewer_maker = require("telescope.previewers").buffer_previewer_maker,
    mappings = {
      n = { ["q"] = require("telescope.actions").close },
    },
  },
  
  extensions_list = { "themes", "terms", "fzf" },
  extensions = {
    fzf = {
      fuzzy = true,
      override_generic_sorter = true,
      override_file_sorter = true,
      case_mode = "smart_case",
    },
  },
}

return M
