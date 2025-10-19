local ok, autotag = pcall(require, "nvim-ts-autotag")
if ok then
  autotag.setup({
    opts = {
      enable_close = true,
      enable_rename = true,
    }
  })
end
