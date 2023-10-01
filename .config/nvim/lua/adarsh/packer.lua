-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
	-- Packer can manage itself
	use 'wbthomason/packer.nvim'

	use {
		'nvim-telescope/telescope.nvim', tag = '0.1.0',
		-- or                            , branch = '0.1.x',
		requires = { {'nvim-lua/plenary.nvim'} }
	}

	use({
		'rose-pine/neovim',
		as = 'rose-pine'
	})

	use({
	    'morhetz/gruvbox',
	})

	use({
		'bradcush/nvim-base16'
	})

	use({
		'norcalli/nvim-colorizer.lua',
		require'colorizer'.setup()
	})

	use('nvim-treesitter/nvim-treesitter', {run = ':TSUpdate'})

	use {
	    "windwp/nvim-autopairs",
	    config = function() require("nvim-autopairs").setup {} end
	}

	use("windwp/nvim-ts-autotag")

	use {
		'VonHeikemen/lsp-zero.nvim',
		requires = {
			-- LSP Support
			{'neovim/nvim-lspconfig'},
			{'williamboman/mason.nvim'},
			{'williamboman/mason-lspconfig.nvim'},

			-- Autocompletion
			{'hrsh7th/nvim-cmp'},
			{'hrsh7th/cmp-buffer'},
			{'hrsh7th/cmp-path'},
			{'saadparwaiz1/cmp_luasnip'},
			{'hrsh7th/cmp-nvim-lsp'},
			{'hrsh7th/cmp-nvim-lua'},

			-- Snippets
			{'L3MON4D3/LuaSnip'},
			--{'rafamadriz/friendly-snippets'},
		}
	}
	use 'lervag/vimtex'
	use {
		'mattn/emmet-vim',
		setup = function ()
			vim.g.user_emmet_install_global = 0
			vim.cmd "autocmd FileType html,css EmmetInstall"
		end
	}

	use 'junegunn/goyo.vim'
end)
