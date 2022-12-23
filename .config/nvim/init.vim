" _   ___     _____ __  __ ____   ____
"| \ | \ \   / /_ _|  \/  |  _ \ / ___|
"|  \| |\ \ / / | || |\/| | |_) | |
"| |\  | \ V /  | || |  | |  _ <| |___
"|_| \_|  \_/  |___|_|  |_|_| \_\\____|
"

"
" Plugins
"
if ! filereadable(stdpath('data') . '/site/autoload/plug.vim')
  silent !curl -fLo $XDG_DATA_HOME/nvim/site/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  " autocmd VimEnter * PlugInstall
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin(stdpath('data') . '/plugged')

" LSP
Plug 'neovim/nvim-lspconfig'
Plug 'SirVer/ultisnips'
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'quangnguyen30192/cmp-nvim-ultisnips'

" Language Support
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
Plug 'rust-lang/rust.vim'
Plug 'simrat39/rust-tools.nvim'
Plug 'mfussenegger/nvim-jdtls'
Plug 'JuliaEditorSupport/julia-vim'
Plug 'lervag/vimtex'

Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'mattn/emmet-vim'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-surround'
Plug 'junegunn/goyo.vim'
Plug 'vimwiki/vimwiki'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim', { 'tag': '0.1.0' }

" Theme
Plug 'joshdick/onedark.vim'
Plug 'morhetz/gruvbox'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'AlphaTechnolog/pywal.nvim'
Plug 'xiyaowong/nvim-transparent'

" Plug 'github/copilot.vim'

call plug#end()

"
" Settings ################################################################
"
set mouse=a
set clipboard+=unnamedplus		" Allows copy paste between Neovim and global clipboard
set completeopt=menuone
set number relativenumber
set cursorline
set nohlsearch
set nowrap
syntax on
set scrolloff=5

filetype plugin on
syntax enable
set encoding=utf-8
set path+=$HOME/.local/bin,**
set hidden
set wildmenu
set wildmode=longest,list,full
filetype plugin indent on
set iskeyword+=- 				" Treats dash separated words as a word text object
au! BufWritePost source $MYVIMRC %

" Spacing
set smarttab					" Makes tabbing smarter will realize you have 2 vs 4
set smartindent					" Makes indenting smart
set tabstop=2
set shiftwidth=0

"" golang syntax highlighting
let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_structs = 1
let g:go_highlight_interfaces = 1
let g:go_highlight_operators = 1
let g:go_highlight_build_constraints = 1

set guifont=Mononoki\ NF:h12

let g:gruvbox_contrast_light 	= 'hard'
let g:gruvbox_contrast_dark 	= 'medium'
" let g:gruxbox_transparent_bg 	= 1
colorscheme pywal
" set background=dark		" Tells Vim the background color
" set termguicolors 		" pywal does this automatically
" let g:transparent_enabled = v:true

" Enables powerline to function properly
let g:airline_powerline_fonts = 1
let g:airline_theme='minimalist'

if exists("g:neovide")
    " Put anything you want to happen only in Neovide here
		" let g:neovide_refresh_rate=60
		" let g:neovide_transparency=0.8
		" let g:neovide_cursor_vfx_mode="railgun"
		" set guifont=Mononoki\ NF:h10
else
		" hi Normal ctermbg=NONE
		" hi! NonText ctermbg=NONE
		" hi Normal guibg=NONE
		" hi! NonText guibg=NONE
endif

"
" Keymaps ################################################################
"
let mapleader = "\<Space>"

" Line number toggle
noremap<C-M-l> :set invnumber invrelativenumber<CR>

" Use alt + hjkl to resize windows
" nnoremap <leader>h    :vertical resize -2<CR>
" nnoremap <leader>l    :vertical resize +2<CR>
" nnoremap <leader>j    :resize -2<CR>
" nnoremap <leader>k    :resize +2<CR>

" TAB in general mode will move to next buffer
nnoremap <TAB> :bnext<CR>
" SHIFT-TAB will go back
nnoremap <S-TAB> :bprevious<CR>

" Better tabbing
vnoremap < <gv
vnoremap > >gv

" vimtex
let g:tex_flavor='latex'
let g:vimtex_view_method='zathura'
let g:vimtex_quickfix_mode=0
set conceallevel=1
let g:tex_conceal='abdmgs'
" let g:tex_conceal=''
" let g:vimtex_syntax_conceal = {
" 	\ 'accents': 1,
" 	\ 'ligatures': 1,
" 	\ 'cites': 1,
" 	\ 'fancy': 1,
" 	\ 'greek': 1,
" 	\ 'math_bounds': 1,
" 	\ 'math_delimiters': 1,
" 	\ 'math_fracs': 1,
" 	\ 'math_super_sub': 1,
" 	\ 'math_symbols': 1,
" 	\ 'sections': 1,
" 	\ 'styles': 1,
" 	\}

" Ultisnips
let g:UltiSnipsExpandTrigger = '<tab>'
let g:UltiSnipsJumpForwardTrigger = '<tab>'
let g:UltiSnipsJumpBackwardTrigger = '<s-tab>'

" Goyo
function! s:goyo_enter()
	set scrolloff=999
endfunction

function! s:goyo_leave()
	set scrolloff=5
endfunction

autocmd! User GoyoEnter nested call <SID>goyo_enter()
autocmd! User GoyoLeave nested call <SID>goyo_leave()

" Telescope
nnoremap <leader>f<space> <cmd>lua require('telescope.builtin').find_files()<cr>
nnoremap <leader>fg <cmd>lua require('telescope.builtin').live_grep()<cr>
nnoremap <leader>fb <cmd>lua require('telescope.builtin').buffers()<cr>
nnoremap <leader>fh <cmd>lua require('telescope.builtin').help_tags()<cr>
autocmd BufWritePre * :%s/\s\+$//e

autocmd BufWritePost,BufNewFile *.njk set filetype=html

" Refresh vimrc
autocmd BufWritePost *.vim source $MYVIMRC

" Compile document, be it groff/LaTeX/markdown/etc.
map <leader>c :w! \| !compiler "<c-r>%"<CR>

" Open corresponding .pdf/.html or preview
	map <leader>p :!opout <c-r>%<CR><CR>

" Runs a script that cleans out tex build files whenever I close out of a .tex file.
autocmd VimLeave *.tex !texclear %

" autocmd BufRead *.tex setlocal spell spelllang=en_us

" Update binds when sxhkdrc is updated
autocmd BufWritePost *sxhkdrc !killall sxhkd; setsid sxhkd &

" When shortcut files are updated, renew bash and ranger configs with new material:
autocmd BufWritePost bm-files,bm-dirs !shortcuts

" Run xrdb whenever Xdefaults or Xresources are updated.
autocmd BufRead,BufNewFile Xresources,Xdefaults,xresources,xdefaults,.Xresources set filetype=xdefaults
autocmd BufWritePost Xresources,Xdefaults,xresources,xdefaults,.Xresources !xrdb -load "$XDG_CONFIG_HOME/X11/xresources" %

" Recompile suckless programs automatically
	" autocmd BufWritePost config.h,config.def.h !sudo make install

lua require ('adarsh.lsp')
