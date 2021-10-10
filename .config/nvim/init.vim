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
	Plug 'neovim/nvim-lspconfig'
	Plug 'hrsh7th/nvim-compe'
	Plug 'glepnir/lspsaga.nvim'
	Plug 'SirVer/ultisnips'
	Plug 'tpope/vim-commentary'
	Plug 'tpope/vim-surround'
	Plug 'junegunn/goyo.vim'
	Plug 'lervag/vimtex'
	" plug 'xuhdev/vim-latex-live-preview'
	Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
	Plug 'JuliaEditorSupport/julia-vim'
	Plug 'rrethy/vim-hexokinase', { 'do': 'make hexokinase' }
	Plug 'morhetz/gruvbox'
	Plug 'arcticicestudio/nord-vim'
	Plug 'vim-airline/vim-airline'
	Plug 'vim-airline/vim-airline-themes'	
	Plug 'dylanaraps/wal.vim'
	Plug 'mattn/emmet-vim'
call plug#end()

" LSP
lua require ('luavim.lsp')
source $XDG_CONFIG_HOME/nvim/lsp.vim

"
" Settings
"
set number relativenumber
set so=5
set clipboard+=unnamedplus		" Allows copy paste between Neovim and global clipboard
filetype plugin on
set wildmode=longest,list,full
set path+=$HOME/.local/bin,**
set wildmenu
set hidden
set mouse=a						" Enables mouse
" let g:go_highlight_trailing_whitespace_error=0
filetype plugin indent on
set iskeyword+=- 				" Treats dash separated words as a word text object
au! BufWritePost source $MYVIMRC %

syntax on
set nohlsearch
" set cursorline 					" Enable highlighting of the current line
set guicursor=
set smarttab					" Makes tabbing smarter will realize you have 2 vs 4
set smartindent					" Makes indenting smart
" set autoindent 				" Good auto indent
set tabstop=4
set shiftwidth=4
"" golang syntax highlighting
let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_structs = 1
let g:go_highlight_interfaces = 1
let g:go_highlight_operators = 1
let g:go_highlight_build_constraints = 1

" set termguicolors

set background=dark				" Tells Vim the background color
let g:gruvbox_contrast_light 	= 'hard'
let g:gruvbox_contrast_dark 	= 'medium'
let g:gruxbox_transparent_bg 	= 1 " Doesn't work
colorscheme wal
" colorscheme gruvbox
" colorscheme nord
" hi Normal ctermbg=NONE guibg=NONE
" hi! NonText ctermbg=NONE guibg=NONE

" Enables powerline to function properly
let g:airline_powerline_fonts = 1
let g:airline_theme='gruvbox'

"
" Keymaps
"
let g:mapleader = "\<Space>"
let g:maplocalleader = "\<Space>"

" Line number toggle
noremap<C-M-l> :set invnumber invrelativenumber<CR>

" Use alt + hjkl to resize windows
nnoremap <M-j>    :resize -2<CR>
nnoremap <M-k>    :resize +2<CR>
nnoremap <M-h>    :vertical resize -2<CR>
nnoremap <M-l>    :vertical resize +2<CR>

" TAB in general mode will move to next buffer
nnoremap <TAB> :bnext<CR>
" SHIFT-TAB will go back
nnoremap <S-TAB> :bprevious<CR>

" Navigation
" nnoremap <leader>h <C-W>h
" nnoremap <leader>j <C-W>j
" nnoremap <leader>k <C-W>k
" nnoremap <leader>l <C-W>l

" Better tabbing
vnoremap < <gv
vnoremap > >gv

" Better window navigation
" nnoremap <C-h> <C-w>h
" nnoremap <C-j> <C-w>j
" nnoremap <C-k> <C-w>k
" nnoremap <C-l> <C-w>l

function! s:goyo_enter()
	set scrolloff=999
endfunction

function! s:goyo_leave()
	set scrolloff=5
endfunction

autocmd! User GoyoEnter nested call <SID>goyo_enter()
autocmd! User GoyoLeave nested call <SID>goyo_leave()

" lspsaga
nnoremap <silent> gh :Lspsaga lsp_finder<CR>
nnoremap <silent><leader>ca :Lspsaga code_action<CR>
vnoremap <silent><leader>ca :<C-U>Lspsaga range_code_action<CR>
nnoremap <silent><leader>K :Lspsaga hover_doc<CR>
nnoremap <silent> <C-f> <cmd>lua require('lspsaga.action').smart_scroll_with_saga(1)<CR>
nnoremap <silent> <C-b> <cmd>lua require('lspsaga.action').smart_scroll_with_saga(-1)<CR>
nnoremap <silent> gs :Lspsaga signature_help<CR>
nnoremap <silent> gr :Lspsaga rename<CR>
nnoremap <silent> gd :Lspsaga preview_definition<CR>
nnoremap <silent> <leader>cd :Lspsaga show_line_diagnostics<CR>
nnoremap <silent> <leader>cc :Lspsaga show_cursor_diagnostics<CR>
nnoremap <silent> ]e :Lspsaga diagnostic_jump_next<CR>
nnoremap <silent> [e :Lspsaga diagnostic_jump_prev<CR>

let g:user_emmet_mode='n'
let g:user_emmet_leader_key=','

" Refresh vimrc
autocmd BufWritePost *.vim source $MYVIMRC

" Compile document, be it groff/LaTeX/markdown/etc.
map <leader>c :w! \| !compiler "<c-r>%"<CR>

" Runs a script that cleans out tex build files whenever I close out of a .tex file.
autocmd VimLeave *.tex !texclear %

" Update binds when sxhkdrc is updated
autocmd BufWritePost *sxhkdrc !killall sxhkd; setsid sxhkd &

" When shortcut files are updated, renew bash and ranger configs with new material:
autocmd BufWritePost bm-files,bm-dirs !shortcuts

" Run xrdb whenever Xdefaults or Xresources are updated.
autocmd BufRead,BufNewFile Xresources,Xdefaults,xresources,xdefaults set filetype=xdefaults
autocmd BufWritePost Xresources,Xdefaults,xresources,xdefaults !xrdb %

" Recompile suckless programs automatically
	" autocmd BufWritePost config.h,config.def.h !sudo make install
