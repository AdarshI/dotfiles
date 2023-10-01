local lsp = require('lsp-zero')

lsp.preset('recommended')

lsp.ensure_installed({
	'rust_analyzer',
})

-- luasnip compatibility

local has_words_before = function()
  unpack = unpack or table.unpack
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

local luasnip = require("luasnip")
local cmp = require("cmp")

local cmp_autopairs = require('nvim-autopairs.completion.cmp')
cmp.event:on(
    'confirm_done',
    cmp_autopairs.on_confirm_done()
)

local cmp_mappings = lsp.defaults.cmp_mappings({
	["<C-n>"] = cmp.mapping(function(fallback)
		if cmp.visible() then
			cmp.select_next_item()
			-- You could replace the expand_or_jumpable() calls with expand_or_locally_jumpable() 
			-- they way you will only jump inside the snippet region
		elseif luasnip.expand_or_locally_jumpable() then
			luasnip.expand_or_jump()
		elseif has_words_before() then
			cmp.complete()
		else
			fallback()
		end
	end, { "i", "s" }),

	["<C-p>"] = cmp.mapping(function(fallback)
		if cmp.visible() then
			cmp.select_prev_item()
		elseif luasnip.jumpable(-1) then
			luasnip.jump(-1)
		else
			fallback()
		end
	end, { "i", "s" }),

	['<Tab>'] = cmp.mapping(function (fallback)
		if luasnip.expand_or_jumpable() then
			luasnip.expand_or_jump()
	--	elseif has_words_before() then
	--		cmp.complete()
		else
			fallback()
		end
	end)
})

lsp.setup_nvim_cmp({
	mapping = cmp_mappings
})

lsp.nvim_workspace()
lsp.setup()
