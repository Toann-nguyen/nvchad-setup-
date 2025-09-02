-- -- ~/.config/nvim/lua/configs/conform.lua
-- -- Cấu hình auto-formatting cho competitive programming

-- local options = {
--   formatters_by_ft = {
--     cpp = { "clang-format" },
--     c = { "clang-format" },
--     lua = { "stylua" },
--     python = { "isort", "black" },
--     javascript = { "prettier" },
--     typescript = { "prettier" },
--     json = { "prettier" },
--     yaml = { "prettier" },
--     markdown = { "prettier" },
--   },

--   -- Format on save configuration
--   format_on_save = {
--     -- These options will be passed to conform.format()
--     timeout_ms = 500,
--     lsp_fallback = true,
--   },

--   -- Formatter configurations
--   formatters = {
--     ["clang-format"] = {
--       args = {
--         "--style={BasedOnStyle: Google, IndentWidth: 2, TabWidth: 2, UseTab: Never, "
--         .. "ColumnLimit: 100, AllowShortFunctionsOnASingleLine: Empty, "
--         .. "AllowShortIfStatementsOnASingleLine: true, "
--         .. "AllowShortLoopsOnASingleLine: true, "
--         .. "BinPackArguments: false, "
--         .. "BinPackParameters: false, "
--         .. "BreakBeforeBraces: Attach, "
--         .. "Cpp11BracedListStyle: true, "
--         .. "SpaceBeforeParens: ControlStatements}",
--       },
--     },
--   },
-- }

-- require("conform").setup(options)

-- -- Manual format keymap
-- vim.keymap.set({ "n", "v" }, "<leader>fm", function()
--   require("conform").format({ lsp_fallback = true })
-- end, { desc = "Format files" })

-- -- Format on save autocmd for specific filetypes
-- vim.api.nvim_create_autocmd("BufWritePre", {
--   pattern = { "*.cpp", "*.c", "*.h", "*.hpp" },
--   callback = function(args)
--     require("conform").format({ bufnr = args.buf })
--   end,
-- })

-- -- Create .clang-format file in project root if it doesn't exist
-- local function create_clang_format()
--   local clang_format_content = [[
-- BasedOnStyle: Google
-- IndentWidth: 2
-- TabWidth: 2
-- UseTab: Never
-- ColumnLimit: 100
-- AllowShortFunctionsOnASingleLine: Empty
-- AllowShortIfStatementsOnASingleLine: true
-- AllowShortLoopsOnASingleLine: true
-- BinPackArguments: false
-- BinPackParameters: false
-- BreakBeforeBraces: Attach
-- Cpp11BracedListStyle: true
-- SpaceBeforeParens: ControlStatements
-- ]]
  
--   local cwd = vim.fn.getcwd()
--   local clang_format_file = cwd .. "/.clang-format"
  
--   -- Check if .clang-format exists
--   if vim.fn.filereadable(clang_format_file) == 0 then
--     -- Create .clang-format file
--     local file = io.open(clang_format_file, "w")
--     if file then
--       file:write(clang_format_content)
--       file:close()
--       vim.notify("Created .clang-format file in " .. cwd, vim.log.levels.INFO)
--     end
--   end
-- end

-- -- Auto-create .clang-format when opening C++ files
-- vim.api.nvim_create_autocmd("BufEnter", {
--   pattern = { "*.cpp", "*.c", "*.h", "*.hpp" },
--   callback = create_clang_format,
--   once = true,
-- })
