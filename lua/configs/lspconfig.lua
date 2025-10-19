-- ~/.config/nvim/lua/configs/lspconfig.lua
local configs = require("nvchad.configs.lspconfig")
local on_attach = configs.on_attach
local on_init = configs.on_init
local capabilities = configs.capabilities

local lspconfig = require("lspconfig")
lspconfig.pyright.setup{}
-- Enhanced on_attach function
local function enhanced_on_attach(client, bufnr)
  on_attach(client, bufnr)
  
  local function opts(desc)
    return { buffer = bufnr, desc = "LSP " .. desc }
  end

  vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts "Go to declaration")
  vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts "Go to definition")
  vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts "Go to implementation")
  vim.keymap.set("n", "<leader>sh", vim.lsp.buf.signature_help, opts "Show signature help")
  vim.keymap.set("n", "<leader>D", vim.lsp.buf.type_definition, opts "Go to type definition")
  vim.keymap.set("n", "<leader>ra", function()
    require("nvchad.lsp.renamer")()
  end, opts "NvRename")
  vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts "Code action")
  vim.keymap.set("n", "gr", vim.lsp.buf.references, opts "Show references")
end

-- ========== REACT/TYPESCRIPT LSP SETUP ==========

-- TypeScript/JavaScript (tsserver)
lspconfig.ts_ls.setup({
  on_attach = enhanced_on_attach,
  on_init = on_init,
  capabilities = capabilities,
  settings = {
    typescript = {
      inlayHints = {
        includeInlayParameterNameHints = "all",
        includeInlayParameterNameHintsWhenArgumentMatchesName = true,
        includeInlayFunctionParameterTypeHints = true,
        includeInlayVariableTypeHints = true,
        includeInlayPropertyDeclarationTypeHints = true,
        includeInlayFunctionLikeReturnTypeHints = true,
        includeInlayEnumMemberValueHints = true,
      },
    },
    javascript = {
      inlayHints = {
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
  filetypes = {
    "html",
    "css",
    "scss",
    "javascript",
    "javascriptreact",
    "typescript",
    "typescriptreact",
    "vue",
  },
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
    },
  },
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

-- HTML
lspconfig.html.setup({
  on_attach = enhanced_on_attach,
  on_init = on_init,
  capabilities = capabilities,
  filetypes = { "html", "htmldjango" },
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

-- ESLint
lspconfig.eslint.setup({
  on_attach = function(client, bufnr)
    enhanced_on_attach(client, bufnr)
    vim.api.nvim_create_autocmd("BufWritePre", {
      buffer = bufnr,
      command = "EslintFixAll",
    })
  end,
  on_init = on_init,
  capabilities = capabilities,
  settings = {
    workingDirectory = { mode = "auto" },
  },
})

-- ========== END REACT/TYPESCRIPT SETUP ==========

-- PHP/Laravel (Intelephense)
lspconfig.intelephense.setup({
  on_attach = enhanced_on_attach,
  on_init = on_init,
  capabilities = capabilities,
  settings = {
    intelephense = {
      environment = {
        includePaths = { "vendor" },
      },
      files = {
        maxSize = 500000,
      },
    },
  },
  filetypes = { "php" },
  root_dir = lspconfig.util.root_pattern("composer.json", ".git"),
})

-- C/C++ (Clangd)
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
  
  init_options = {
    usePlaceholders = true,
    completeUnimported = true,
    clangdFileStatus = true,
  },
  
  settings = {
    clangd = {
      semanticHighlighting = true,
    },
  },
  
  filetypes = { "c", "cpp", "objc", "objcpp", "cuda" },
  
  root_dir = lspconfig.util.root_pattern(
    ".clangd",
    ".clang-tidy",
    ".clang-format",
    "compile_commands.json",
    "compile_flags.txt",
    "configure.ac",
    ".git"
  ),
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
  },
  signs = true,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
})

-- Custom diagnostic signs
local signs = { Error = "󰅚 ", Warn = "󰀪 ", Hint = "󰌶 ", Info = " " }
for type, icon in pairs(signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end
