local configs = require("nvchad.configs.lspconfig")
local on_attach = configs.on_attach
local on_init = configs.on_init
local capabilities = configs.capabilities

local lspconfig = require("lspconfig")

-- Enhanced on_attach function
local function enhanced_on_attach(client, bufnr)
  on_attach(client, bufnr)
  
  -- Additional keymaps
  local function opts(desc)
    return { buffer = bufnr, desc = "LSP " .. desc }
  end

  vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts "Go to declaration")
  vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts "Go to definition")
  vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts "Go to implementation")
  vim.keymap.set("n", "K", vim.lsp.buf.hover, opts "Hover documentation")
  vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts "Signature help")
  vim.keymap.set("n", "gr", vim.lsp.buf.references, opts "Show references")
  vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts "Code action")
  vim.keymap.set("n", "<leader>ra", function()
    require("nvchad.lsp.renamer")()
  end, opts "Rename")
  
  -- Format on save for web dev files
  if client.supports_method("textDocument/formatting") then
    vim.api.nvim_create_autocmd("BufWritePre", {
      group = vim.api.nvim_create_augroup("LspFormat." .. bufnr, { clear = true }),
      buffer = bufnr,
      callback = function()
        vim.lsp.buf.format({
          filter = function(format_client)
            -- Use null-ls/conform for formatting if available
            return format_client.name ~= "tsserver" and format_client.name ~= "volar"
          end,
        })
      end,
    })
  end
end

-- C++ / Clangd (for competitive programming)
lspconfig.clangd.setup({
  on_attach = enhanced_on_attach,
  on_init = on_init,
  capabilities = capabilities,
  
  cmd = {
    "clangd",
    "--offset-encoding=utf-16",
    "--clang-tidy",
    "--clang-tidy-checks=-*,readability-*,performance-*,bugprone-*",
    "--completion-style=detailed",
    "--cross-file-rename",
    "--header-insertion=iwyu",
    "--pch-storage=memory",
    "--function-arg-placeholders",
    "--fallback-style=Google",
  },
  
  filetypes = { "c", "cpp", "objc", "objcpp", "cuda" },
})

-- TypeScript & JavaScript (tsserver)
lspconfig.ts_ls.setup({
  on_attach = enhanced_on_attach,
  on_init = on_init,
  capabilities = capabilities,
  
  init_options = {
    preferences = {
      disableSuggestions = false,
      quotePreference = "auto",
      includeCompletionsForModuleExports = true,
      includeCompletionsForImportStatements = true,
      importModuleSpecifierPreference = "shortest",
    },
  },
  
  filetypes = {
    "javascript",
    "javascriptreact",
    "javascript.jsx",
    "typescript",
    "typescriptreact",
    "typescript.tsx",
  },
})

-- Tailwind CSS
lspconfig.tailwindcss.setup({
  on_attach = enhanced_on_attach,
  on_init = on_init,
  capabilities = capabilities,
  
  settings = {
    tailwindCSS = {
      classAttributes = { "class", "className", "classList", "ngClass" },
      lint = {
        cssConflict = "warning",
        invalidApply = "error",
        invalidConfigPath = "error",
        invalidScreen = "error",
        invalidTailwindDirective = "error",
        invalidVariant = "error",
        recommendedVariantOrder = "warning",
      },
      validate = true,
      experimental = {
        classRegex = {
          "tw`([^`]*)",
          "tw=\"([^\"]*)",
          "tw={\"([^\"}]*)",
          "tw\\.\\w+`([^`]*)",
          { "clsx\\(([^)]*)\\)", "(?:'|\"|`)([^']*)(?:'|\"|`)" },
          { "classnames\\(([^)]*)\\)", "'([^']*)'" },
          { "cva\\(([^)]*)\\)", "[\"'`]([^\"'`]*).*?[\"'`]" },
        },
      },
    },
  },
  
  filetypes = {
    "html",
    "css",
    "scss",
    "javascript",
    "javascriptreact",
    "typescript",
    "typescriptreact",
    "vue",
    "svelte",
  },
})

-- HTML
lspconfig.html.setup({
  on_attach = enhanced_on_attach,
  on_init = on_init,
  capabilities = capabilities,
  
  filetypes = { "html", "htmldjango" },
})

-- CSS
lspconfig.cssls.setup({
  on_attach = enhanced_on_attach,
  on_init = on_init,
  capabilities = capabilities,
  
  settings = {
    css = {
      validate = true,
      lint = {
        unknownAtRules = "ignore",
      },
    },
    scss = {
      validate = true,
      lint = {
        unknownAtRules = "ignore",
      },
    },
    less = {
      validate = true,
      lint = {
        unknownAtRules = "ignore",
      },
    },
  },
})

-- ESLint
lspconfig.eslint.setup({
  on_attach = function(client, bufnr)
    enhanced_on_attach(client, bufnr)
    
    -- Auto fix on save
    vim.api.nvim_create_autocmd("BufWritePre", {
      buffer = bufnr,
      command = "EslintFixAll",
    })
  end,
  on_init = on_init,
  capabilities = capabilities,
  
  settings = {
    workingDirectory = { mode = "auto" },
    format = true,
    nodePath = "",
    quiet = false,
    onIgnoredFiles = "off",
    rulesCustomizations = {},
    run = "onType",
    validate = "on",
    codeAction = {
      disableRuleComment = {
        enable = true,
        location = "separateLine",
      },
      showDocumentation = {
        enable = true,
      },
    },
  },
})

-- JSON
lspconfig.jsonls.setup({
  on_attach = enhanced_on_attach,
  on_init = on_init,
  capabilities = capabilities,
  
  settings = {
    json = {
      schemas = require("schemastore").json.schemas(),
      validate = { enable = true },
    },
  },
})

-- Emmet (for HTML/JSX)
lspconfig.emmet_ls.setup({
  on_attach = enhanced_on_attach,
  on_init = on_init,
  capabilities = capabilities,
  
  filetypes = {
    "html",
    "typescriptreact",
    "javascriptreact",
    "css",
    "sass",
    "scss",
    "less",
  },
})

-- Lua (for Neovim config)
lspconfig.lua_ls.setup({
  on_attach = enhanced_on_attach,
  on_init = on_init,
  capabilities = capabilities,
  
  settings = {
    Lua = {
      diagnostics = {
        globals = { "vim" },
      },
      workspace = {
        library = {
          [vim.fn.expand("$VIMRUNTIME/lua")] = true,
          [vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true,
          [vim.fn.stdpath("data") .. "/lazy/lazy.nvim/lua/lazy"] = true,
        },
        maxPreload = 100000,
        preloadFileSize = 10000,
      },
    },
  },
})

-- Enhanced diagnostics configuration
vim.diagnostic.config({
  virtual_text = {
    prefix = "●",
    source = "if_many",
  },
  float = {
    source = "always",
    border = "rounded",
    header = "",
    prefix = "",
  },
  signs = true,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
})

-- Diagnostic signs
local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
for type, icon in pairs(signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
end
