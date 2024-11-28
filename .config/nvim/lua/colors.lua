function ColorMyPencils(color)
	color = color or "base16-default-dark"

	vim.o.background = 'dark'
	vim.g.gruvbox_contrast_light = 'hard'
	vim.g.gruvbox_contrast_dark = 'soft'

	vim.cmd.colorscheme(color)

	-- vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
	-- vim.dawnapi.nvim_set_hl(0, "NormalFloat", { bg = "none" })
end

ColorMyPencils("pywal")
