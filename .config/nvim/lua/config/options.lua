-- tabindent settings
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.expandtab = true
vim.opt.smartindent = true

vim.api.nvim_create_autocmd("FileType", {
  pattern = "lua",
  callback = function()
    vim.opt.shiftwidth = 2
    vim.opt.tabstop = 2
  end,
})

vim.opt.list = true
vim.opt.listchars = { tab = "» ", trail = "·" }

vim.api.nvim_create_user_command("Q", "qa", {})
