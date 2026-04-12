-- いろいろ
vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.opt.clipboard = "unnamedplus"
vim.keymap.set("i", "jk", "<Esc>")
vim.keymap.set("t", "<Esc>", [[<C-\><C-n>]], { noremap = true })
vim.keymap.set("n", "<leader>gg", ":LazyGit<CR>", { desc = "Open LazyGit" })
vim.opt.number = true
vim.opt.wrap = false
vim.opt.linebreak = false
vim.opt.breakindent = false
vim.opt.sidescroll = 8
vim.opt.sidescrolloff = 8

-- init.lua
vim.loader.enable()
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- よびだし
require("lazy").setup("plugins",
  {
    ui = {
      icons = {
        cmd = "⌘",
        config = "🛠",
        event = "📅",
        ft = "📂",
        init = "⚙",
        keys = "🗝",
        plugin = "🔌",
        runtime = "💻",
        require = "🌙",
        source = "📄",
        start = "🚀",
        task = "📌",
        lazy = "💤 ",
      },
    },
    checker = {
      enabled = true, -- プラグインのアップデートを自動的にチェック
    },
    --diff = {
    --	cmd = "delta",
    --},
    rtp = {
      disabled_plugins = {
        "gzip",
        "matchit",
        "matchparen",
        "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  })

-- init.lua
require("config")


-- neovim remote server
if vim.fn.executable('nvr') == 1 then
  vim.env.EDITOR = 'nvr -cc split -c "set bufhidden=delete" --remote-tab-wait'
end
vim.opt.splitright = true


--vim.api.nvim_create_autocmd("VimEnter", {
--  callback = function()
--   local arg = vim.fn.argv(0)
--
--    if arg ~= "" then
--      if vim.fn.isdirectory(arg) == 1 then
--        vim.cmd("cd " .. vim.fn.fnameescape(arg))
--      else
--        local dir = vim.fn.fnamemodify(arg, ":p:h")
--        vim.cmd("cd " .. vim.fn.fnameescape(dir))
--      end
--    end

--    -- tree開く
--    vim.cmd("Neotree filesystem reveal left")
--  end,
--})
