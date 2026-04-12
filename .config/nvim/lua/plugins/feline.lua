return {
  "feline-nvim/feline.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    vim.opt.termguicolors = true
    vim.opt.laststatus = 3
    vim.opt.showmode = false
    --require("config.feline")
    require("feline").setup()
  end,
}



