return {
  {
    "sindrets/diffview.nvim",
    cmd = {
      "DiffviewOpen",
      "DiffviewClose",
      "DiffviewToggleFiles",
      "DiffviewFocusFiles",
    },
    keys = {
      { "<leader>dv", "<cmd>DiffviewOpen<CR>", desc = "Open Diffview" },
      { "<leader>dc", "<cmd>DiffviewClose<CR>", desc = "Close Diffview" },
      { "<leader>df", "<cmd>DiffviewToggleFiles<CR>", desc = "Toggle Diff Files" },
    },
  },
}
