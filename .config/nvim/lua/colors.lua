function ColorMyPencils(color)
	color = color or "rose-pine"

	vim.o.background = 'dark'
	vim.g.gruvbox_contrast_light = 'medium'

	vim.cmd.colorscheme(color)

	-- vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
	-- vim.dawnapi.nvim_set_hl(0, "NormalFloat", { bg = "none" })
end

ColorMyPencils("base16-default-dark")
