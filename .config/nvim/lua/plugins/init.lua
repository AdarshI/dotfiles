local plugins = {
	{
		'bradcush/nvim-base16',
		priority = 1000
	},

	-- Aesthetic
	{
		'rebelot/kanagawa.nvim',
		config = function()
			require('kanagawa').setup({
				theme = 'dragon',
				background = {
					dark = 'dragon',
					light = 'lotus'
				}
			})
		end
	},

	{ "ellisonleao/gruvbox.nvim", priority = 1000,
		config = function()
			require("gruvbox").setup({
				terminal_colors = true,
				contrast = 'soft',
			})
		end,
		opts = ...
	},

	{ "rose-pine/neovim", name = "rose-pine",
		config = function()
			require("rose-pine").setup({
				dark_variant = "moon",
			})
		end
	},

	{
		'AlphaTechnolog/pywal.nvim',
	},

	-- Goyo
	{
		'junegunn/goyo.vim',
	},
	-- syntax highlighting
	{
		'nvim-treesitter/nvim-treesitter',
		build = ':TSUpdate',
		lazy = false,
		config = function()
			require 'plugins.configs.treesitter'
		end,
	},

	{
		'lervag/vimtex',
		config = function ()
			vim.g['vimtex_quickfix_ignore_filters'] = {'siunitx'}
		end,
	},

	-- mason
	{
		'williamboman/mason.nvim',
		build = ':MasonUpdate',
		cmd = { 'Mason', 'MasonInstall' },
	},
	{'williamboman/mason-lspconfig.nvim'},

	-- lsp-zero
	{
		'VonHeikemen/lsp-zero.nvim',
		branch = 'v3.x',
		config = function()
			require('plugins.configs.lspzero')
		end,
	},
	{
		'neovim/nvim-lspconfig',
		event = { 'BufReadPre', 'BufNewFile' },
	},

	-- auto-completion
	{'saadparwaiz1/cmp_luasnip'},
	{'hrsh7th/cmp-nvim-lsp'},
	{'hrsh7th/cmp-nvim-lua'},
	{'hrsh7th/nvim-cmp'},

	-- Snippets
	{
		'L3MON4D3/LuaSnip',
		version = 'v2.*',
		config = function ()
			require('plugins.configs.luasnip')
		end,
	},

	{
		'mattn/emmet-vim'
	},

	-- comment plugin
	{
		'numToStr/Comment.nvim',
		config = function()
			require('Comment').setup()
		end,
	},

	-- autopairs , autocompletes ()[] etc
	{
		'windwp/nvim-autopairs',
		config = function()
			require('nvim-autopairs').setup({})

				local npairs = require('nvim-autopairs')
				local Rule = require('nvim-autopairs.rule')

				local function is_math()
					return vim.fn["vimtex#syntax#in_mathzone"]() == 1
				end

				-- npairs.setup()
				npairs.add_rules({
					-- Rule("'", "'", {"tex"}):with_pair(is_math)
				})

			--  cmp integration
			local cmp_autopairs = require 'nvim-autopairs.completion.cmp'
			local cmp = require 'cmp'
			cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done())
		end,
	},

	-- formatting , linting
	{
		'stevearc/conform.nvim',
		lazy = true,
		config = function()
			require 'plugins.configs.conform'
		end,
	},

	{
		'nvim-neorg/neorg',
		build = ':Neorg sync-parsers',
		-- tag = '*',
		dependencies = { 'nvim-lua/plenary.nvim' },
		config = function()
			require('neorg').setup {
				load = {
					['core.defaults'] = {}, -- Loads default behaviour
					['core.concealer'] = {
						config = {
							icon_preset = 'diamond'
						}
					}, -- Adds pretty icons to your documents
					['core.dirman'] = { -- Manages Neorg workspaces
						config = {
							workspaces = {
								notes = '~/dox/notes',
							},
							default_workspace = 'notes',
						},
					},
				},
			}
		end,
	},

	-- files finder etc
	{
		'nvim-telescope/telescope.nvim', tag='0.1.4',
		dependencies = { 'nvim-lua/plenary.nvim' },
		cmd = 'Telescope',
		config = function()
			require 'plugins.configs.telescope'
		end,
	},

	{
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
		event = "ColorScheme",
		config = function()
			require("lualine").setup({
				options = {
					--- @usage 'rose-pine' | 'rose-pine-alt'
					theme = "rose-pine"
				}
			})
		end
	}

}

require('lazy').setup(plugins, require 'plugins.configs.lazy')
