local lsp = require('lsp-zero')
lsp.extend_lspconfig()

lsp.on_attach(function(client,bufnr)
	lsp.default_keymaps({buffer=bufnr})
end)

-- mason
require('mason').setup({})
require('mason-lspconfig').setup({
	ensure_installed = {'rust_analyzer'},
	handlers = {
		lsp.default_setup,
		lua_ls = function()
			local lua_opts = lsp.nvim_lua_ls()
			require('lspconfig').lua_ls.setup(lua_opts)
		end,
	},
})

-- luasnip compatibility

local has_words_before = function()
  unpack = unpack or table.unpack
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

local luasnip = require("luasnip")
local cmp = require("cmp")
local cmp_action = require('lsp-zero').cmp_action()

local cmp_mappings = cmp.mapping.preset.insert({
	-- luasnip
    ["<Tab>"] = cmp.mapping(function(fallback)
      if luasnip.expand_or_jumpable() then
		luasnip.expand_or_jump()
        --vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<Plug>luasnip-expand-or-jump", true, true, true), "")
	  elseif cmp.visible() then
        cmp.select_next_item()
      else
        fallback()
      end
    end, {
      "i",
      "s",
    }),
    ["<S-Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
		luasnip.jump(-1)
        --vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<Plug>luasnip-jump-prev", true, true, true), "")
      else
        fallback()
      end
    end, {
      "i",
      "s",
    }),
-- 	["<C-n>"] = cmp.mapping(function(fallback)
-- 		if cmp.visible() then
-- 			cmp.select_next_item()
-- 			-- You could replace the expand_or_jumpable() calls with expand_or_locally_jumpable() 
-- 			-- they way you will only jump inside the snippet region
-- 		elseif luasnip.expand_or_locally_jumpable() then
-- 			luasnip.expand_or_jump()
-- 		elseif has_words_before() then
-- 			cmp.complete()
-- 		else
-- 			fallback()
-- 		end
-- 	end, { "i", "s" }),
-- 
-- 	["<C-p>"] = cmp.mapping(function(fallback)
-- 		if cmp.visible() then
-- 			cmp.select_prev_item()
-- 		elseif luasnip.jumpable(-1) then
-- 			luasnip.jump(-1)
-- 		else
-- 			fallback()
-- 		end
-- 	end, { "i", "s" }),
-- 
-- 	['<Tab>'] = cmp.mapping(function (fallback)
-- 		if luasnip.expand_or_jumpable() then
-- 			luasnip.expand_or_jump()
-- 	--	elseif has_words_before() then
-- 	--		cmp.complete()
-- 		else
-- 			fallback()
-- 		end
-- 	end)
})

cmp.setup({
	window = {
		completion = cmp.config.window.bordered(),
		documentation = cmp.config.window.bordered(),
	},
	mapping = cmp_mappings,
    sources = cmp.config.sources {
      { name = "nvim_lsp" },
      { name = "luasnip" },
      { name = "buffer" },
      { name = "nvim_lua" },
      { name = "path" },
    },
})

lsp.setup()
