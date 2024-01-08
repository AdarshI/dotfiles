local plugins = {
	{
		"bradcush/nvim-base16",
		priority = 1000
	},

  -- Goyo
  {
	  "junegunn/goyo.vim",
  },
  -- syntax highlighting
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require "plugins.configs.treesitter"
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
    "williamboman/mason.nvim",
    build = ":MasonUpdate",
    cmd = { "Mason", "MasonInstall" },
  },
  {'williamboman/mason-lspconfig.nvim'},

  -- lsp-zero
  {
	  'VonHeikemen/lsp-zero.nvim',
	  branch = 'v3.x',
	  config = function()
		  require("plugins.configs.lspzero")
	  end,
  },
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
  },

  -- auto-completion
  {'saadparwaiz1/cmp_luasnip'},
  {'hrsh7th/cmp-nvim-lsp'},
  {'hrsh7th/cmp-nvim-lua'},
  {'hrsh7th/nvim-cmp'},

  -- Snippets
  {
	  'L3MON4D3/LuaSnip',
	  version = "v2.*",
	  config = function ()
		  require("plugins.configs.luasnip")
	  end,
  },

  -- autopairs , autocompletes ()[] etc
  {
    "windwp/nvim-autopairs",
    config = function()
      require("nvim-autopairs").setup()

      --  cmp integration
      local cmp_autopairs = require "nvim-autopairs.completion.cmp"
      local cmp = require "cmp"
      cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
    end,
  },

  -- formatting , linting
  {
    "stevearc/conform.nvim",
    lazy = true,
    config = function()
      require "plugins.configs.conform"
    end,
  },

  -- files finder etc
  {
    "nvim-telescope/telescope.nvim", tag='0.1.4',
	dependencies = { 'nvim-lua/plenary.nvim' },
    cmd = "Telescope",
    config = function()
      require "plugins.configs.telescope"
    end,
  },

  -- comment plugin
  {
    "numToStr/Comment.nvim",
    lazy = true,
    config = function()
      require("Comment").setup()
    end,
  },
}

require("lazy").setup(plugins, require "plugins.configs.lazy")
