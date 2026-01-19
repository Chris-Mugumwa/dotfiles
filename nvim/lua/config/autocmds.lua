-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

-- Kitty opacity: 100% when Neovim is active, restore on exit
if vim.env.TERM == "xterm-kitty" then
  local kitty_opacity = vim.api.nvim_create_augroup("KittyOpacity", { clear = true })

  vim.api.nvim_create_autocmd("VimEnter", {
    group = kitty_opacity,
    callback = function()
      vim.fn.system("kitty @ set-background-opacity 1")
    end,
  })

  vim.api.nvim_create_autocmd("VimLeave", {
    group = kitty_opacity,
    callback = function()
      vim.fn.system("kitty @ set-background-opacity 0.9")
    end,
  })
end
