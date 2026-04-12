return {
  "stevearc/conform.nvim",
  opts = {
    format_on_save = {
      timeout_ms = 500,
      lsp_fallback = true, -- ← LSP fallback
    },

    formatters_by_ft = {
      lua = { "stylua" },
      python = { "black" },
      javascript = { "prettier" },
      typescript = { "prettier" },
      json = { "prettier" },
      sh = { "shfmt" },
    },
  },
}
