require "nvchad.autocmds"

-- THÊM: Laravel autocmds (từ features: auto-detect env, virtual info on open)
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "php", "blade" },
  callback = function()
    -- Auto-enable virtual info (model/route info) nếu plugin loaded
    if vim.fn.exists("Laravel") == 1 then
      vim.cmd("doautocmd User LaravelBufferEntered")
    end
    
    -- Notify nếu không detect Laravel project
    local root = vim.fn.getcwd()
    if vim.fn.filereadable(root .. "/artisan") == 0 then
      vim.notify("Not a Laravel project. Run in Laravel root.", vim.log.levels.WARN)
    end
  end,
})

-- Auto-format on save cho PHP/Blade (enhance với php-cs-fixer)
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = { "*.php", "*.blade.php" },
  callback = function()
    require("conform").format({ bufnr = vim.api.nvim_get_current_buf(), lsp_fallback = true })
  end,
})
