return {
  {
    "romgrk/barbar.nvim",
    event = "VeryLazy",

    dependencies = {
      "lewis6991/gitsigns.nvim",
      "nvim-tree/nvim-web-devicons",
    },

    init = function()
      vim.g.barbar_auto_setup = false
      vim.opt.hidden = true
    end,

    keys = {
      -- ===== バッファ操作 =====

      -- 現在のバッファを閉じる
      { "<leader>bd", "<cmd>BufferClose<cr>",              desc = "Buffer: close current" },

      -- 現在以外を閉じる
      { "<leader>bo", "<cmd>BufferCloseAllButCurrent<cr>", desc = "Buffer: close others" },

      -- 強制削除
      { "<leader>bD", "<cmd>BufferClose!<cr>",             desc = "Buffer: force close" },

      -- ===== バッファ移動 =====

      -- 左右移動（← → 感覚）
      { "<leader>bh", "<cmd>BufferPrevious<cr>",           desc = "Buffer: previous" },
      { "<leader>bl", "<cmd>BufferNext<cr>",               desc = "Buffer: next" },

      -- Altキーでも移動（素早く操作用）
      { "<A-,>",      "<cmd>BufferPrevious<cr>",           desc = "Buffer: previous" },
      { "<A-.>",      "<cmd>BufferNext<cr>",               desc = "Buffer: next" },

      -- ===== 並び替え =====

      { "<A-<>",      "<cmd>BufferMovePrevious<cr>",       desc = "Buffer: move left" },
      { "<A->>",      "<cmd>BufferMoveNext<cr>",           desc = "Buffer: move right" },
    },

    opts = {},

    config = function(_, opts)
      require("barbar").setup(opts)
      vim.api.nvim_create_autocmd("ColorScheme", {
        callback = function()
          vim.api.nvim_set_hl(0, "BufferCurrent", { bg = "NONE" })
          vim.api.nvim_set_hl(0, "BufferVisible", { bg = "NONE" })
          vim.api.nvim_set_hl(0, "BufferInactive", { bg = "NONE" })

          vim.api.nvim_set_hl(0, "BufferCurrentSign", { bg = "NONE" })
          vim.api.nvim_set_hl(0, "BufferVisibleSign", { bg = "NONE" })
          vim.api.nvim_set_hl(0, "BufferInactiveSign", { bg = "NONE" })

          vim.api.nvim_set_hl(0, "BufferTabpages", { bg = "NONE" })
          vim.api.nvim_set_hl(0, "BufferTabpageFill", { bg = "NONE" })

          vim.api.nvim_set_hl(0, "TabLine", { bg = "NONE" })
          vim.api.nvim_set_hl(0, "TabLineFill", { bg = "NONE" })
        end,
      })

      -- 起動時にも1回適用
      vim.cmd("doautocmd ColorScheme")
    end,

    version = "^1.0.0",

  },
}
