local configs = require("nvchad.configs.lspconfig")
local on_attach = configs.on_attach
local on_init = configs.on_init
local capabilities = configs.capabilities

local lspconfig = require("lspconfig")

-- Enhanced on_attach function for competitive programming
local function cp_on_attach(client, bufnr)
  on_attach(client, bufnr)
  
  -- Additional keymaps for competitive programming
  local function opts(desc)
    return { buffer = bufnr, desc = "LSP " .. desc }
  end

  vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts "Go to declaration")
  vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts "Go to definition")
  vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts "Go to implementation")
  vim.keymap.set("n", "<leader>sh", vim.lsp.buf.signature_help, opts "Show signature help")
  vim.keymap.set("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, opts "Add workspace folder")
  vim.keymap.set("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, opts "Remove workspace folder")
  vim.keymap.set("n", "<leader>wl", function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, opts "List workspace folders")
  vim.keymap.set("n", "<leader>D", vim.lsp.buf.type_definition, opts "Go to type definition")
  vim.keymap.set("n", "<leader>ra", function()
    require("nvchad.lsp.renamer")()
  end, opts "NvRename")
  vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts "Code action")
  vim.keymap.set("n", "gr", vim.lsp.buf.references, opts "Show references")
end

-- THÊM: Intelephense cho PHP/Laravel (ưu tiên cho autocompletion facades/routes)
lspconfig.intelephense.setup({
  on_attach = cp_on_attach,
  on_init = on_init,
  capabilities = capabilities,
  settings = {
    intelephense = {
      environment = {
        includePaths = { "vendor" },  -- Để nhận Laravel vendor libs
      },
      files = {
        maxSize = 500000,
      },
    },
  },
  filetypes = { "php" },
  root_dir = lspconfig.util.root_pattern("composer.json", ".git"),
})

-- Clangd configuration for competitive programming
lspconfig.clangd.setup({
  on_attach = cp_on_attach,
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

-- Additional LSP servers
local servers = { "html", "cssls" }
for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup({
    on_attach = on_attach,
    on_init = on_init,
    capabilities = capabilities,
  })
end

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
