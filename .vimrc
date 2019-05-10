filetype on
filetype plugin indent on
syntax on

" Editor
set background=dark
set number
set relativenumber
set backspace=eol,indent,start
set laststatus=2
set scrolloff=20

" allow modified buffer to not be displayed
set hidden

" system clipboard by default
set clipboard=unnamedplus


" Auto-Indentation
" Plugin 'vim-scripts/indentpython.vim'

" Flagging Unnecessary Whitespace
" au BufRead,BufNewFile *.py,*.pyw,*.c,*.h
"     \ match BadWhitespace /\s\+$/

" UTF-8 Support
set encoding=utf-8

" Python Mode
let g:pymode_rope = 0
" let g:pymode_syntax = 0
let g:pymode_lint = 0
let g:pymode_doc = 0

" FZF
let $FZF_DEFAULT_COMMAND = 'ag -g ""'

" Airline
let g:airline#extensions#tabline#enabled = 1
let g:airline_theme='powerlineish'
let g:airline_powerline_fonts = 1

" Plugins
call plug#begin('~/.vim/plugged')
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
Plug 'davidhalter/jedi-vim'
Plug 'morhetz/gruvbox'
Plug 'python-mode/python-mode'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
Plug 'w0rp/ale'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'ryanoasis/vim-devicons'
Plug 'alfredodeza/pytest.vim'
Plug 'mgedmin/coverage-highlight.vim'
call plug#end()

" Color Scheme
colorscheme gruvbox

noremap <C-p> :FZF<CR>
set nofoldenable
