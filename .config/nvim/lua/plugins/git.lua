return {
  "lewis6991/gitsigns.nvim",
  event = "BufReadPre",
  config = function()
    local gitsigns = require("gitsigns")

    gitsigns.setup({
      signs = {
        add          = { text = "│" },
        change       = { text = "│" },
        delete       = { text = "_" },
        topdelete    = { text = "‾" },
        changedelete = { text = "~" },
      },

      current_line_blame = false, -- 重いからオフ（必要ならオン）

      on_attach = function(bufnr)
        local map = function(mode, lhs, rhs, desc)
          vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
        end

        -- 🔥 差分移動（これ超使う）
        map("n", "]c", gitsigns.next_hunk, "Next Hunk")
        map("n", "[c", gitsigns.prev_hunk, "Prev Hunk")

        -- 🔥 hunk操作
        map("n", "<leader>hs", gitsigns.stage_hunk, "Stage Hunk")
        map("n", "<leader>hr", gitsigns.reset_hunk, "Reset Hunk")

        -- ビジュアルでも使える
        map("v", "<leader>hs", function()
          gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
        end, "Stage Hunk")

        map("v", "<leader>hr", function()
          gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
        end, "Reset Hunk")

        -- 🔍 プレビュー
        map("n", "<leader>hp", gitsigns.preview_hunk, "Preview Hunk")

        -- ❌ バッファ単位
        map("n", "<leader>hS", gitsigns.stage_buffer, "Stage Buffer")
        map("n", "<leader>hR", gitsigns.reset_buffer, "Reset Buffer")

        -- 🧠 blame
        map("n", "<leader>hb", gitsigns.blame_line, "Blame Line")

        -- 📄 diff表示
        map("n", "<leader>hd", gitsigns.diffthis, "Diff This")
        map("n", "<leader>hD", function()
          gitsigns.diffthis("~")
        end, "Diff Against Last Commit")

        -- 💡 トグル系
        map("n", "<leader>tb", gitsigns.toggle_current_line_blame, "Toggle Blame")
        map("n", "<leader>td", gitsigns.toggle_deleted, "Toggle Deleted")
      end,
    })
  end,
}
