return {
	{
		"OXY2DEV/markview.nvim",
		lazy = false,
		priority = 999,
		opts = {
			hybrid_modes = { "n" },
			modes = { "n", "no", "c" },
			callbacks = {
				on_enable = function(_, win)
					vim.wo[win].conceallevel = 2
					vim.wo[win].concealcursor = "nc"
				end,
			},
			preview = {
				icon_provider = "mini",
			},
		},
		keys = {
			{ "<Leader>mt", ":Markview toggle<CR>", desc = "Markview [t]oggle" },
			{ "<Leader>me", ":Markview enable<CR>", desc = "Markview [e]nable" },
			{ "<Leader>md", ":Markview disable<CR>", desc = "Markview [d]isable" },
			{ "<Leader>ms", ":Markview splitToggle<CR>", desc = "Markview [s]plit view" },
			{ "<Leader>mh", ":Markview hybridToggle<CR>", desc = "Markview [h]ybrid mode" },
		},
	},
}
