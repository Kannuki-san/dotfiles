return {
  {
    "rebelot/kanagawa.nvim",
    priority = 1000,
    config = function()
	require('kanagawa').setup({
		compile = false,
		undercurl = true,
		commentStyle = { italic = true },
      		functionStyle = { italic = true },
      		keywordStyle = { italic = true },
      		stringStyle = { italic = true },
		variableStyle = { italic = true },
		
		background = {
			dark = "dragon",
			light = "dragon"
		},
		transparent = true,
		dimInactive = false
	})

      vim.cmd.colorscheme("kanagawa")
    end,
  },
}
