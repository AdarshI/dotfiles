local ls = require('luasnip')

-- custom snippets
--require('luasnip.loaders.from_lua').load({ paths = "~/.config/nvim/snippets/" })
require('luasnip.loaders.from_lua').load()

-- config LuaSnip
local types = require('luasnip.util.types')
ls.config.set_config({
	history = true, --keep around last snippet local to jump back
	updateevents = "TextChanged,TextChangedI", --update changes as you type
	enable_autosnippets = true,
	exp_opts = {
		[types.choiceNode] = {
			active = {
				virt_text = { { "choiceNoce", "Comment" } },
			},
		},
	},
	ft_funct = function()
		return vim.split(vim.bo.filetype, ".", true)
	end,
})

vim.keymap.set({"i", "s"}, "<Tab>", function ()
	if ls.expand_or_jumpable() then
		ls.expand_or_jump()
	else
		vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Tab>", true, true, true), "n", false)
	end 
end, { silent = true })

vim.keymap.set({"i", "s"}, "<S-Tab>", function ()
	if ls.jumpable(-1) then
		ls.jump(-1)
	else
		vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<S-Tab>", true, true, true), "n", false)
	end
end, { silent = true })

vim.keymap.set({"i", "s"}, "<C-s>", function ()
	if ls.choice_active() then
		ls.change_choice(1)
	end
end, { silent = true })

-- vim.keymap.set("n", "<leader><leader>s", "<cmd>so $XDG_CONFIG_HOME/nvim/after/plugin/luasnip.lua<CR>")
