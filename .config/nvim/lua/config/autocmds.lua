-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

vim.api.nvim_create_autocmd("ColorScheme", {
  pattern = "*",
  callback = function()
    -- neo-tree sidebar
    local neo = { "NeoTreeNormal", "NeoTreeNormalNC", "NeoTreeEndOfBuffer" }
    for _, g in ipairs(neo) do
      pcall(function()
        local hl = vim.api.nvim_get_hl(0, { name = g })
        hl.bg = "NONE"
        vim.api.nvim_set_hl(0, g, hl)
      end)
    end
    -- snacks explorer / picker sidebar
    local snacks = {
      "SnacksPickerNormal",
      "SnacksPickerEndOfBuffer",
      "EndOfBuffer",
      "SignColumn",
      "StatusColumn",
      "NormalNC",
    }
    for _, g in ipairs(snacks) do
      pcall(function()
        local hl = vim.api.nvim_get_hl(0, { name = g })
        hl.bg = "NONE"
        vim.api.nvim_set_hl(0, g, hl)
      end)
    end
  end,
})
