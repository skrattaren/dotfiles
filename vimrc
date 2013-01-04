filetype plugin on
filetype indent on
syntax on

set paste

set expandtab shiftwidth=4 softtabstop=4 tabstop=4
set list
set listchars=tab:▹\ ,eol:↵,trail:▿
nmap <leader>l :set list! relativenumber!<CR>

set incsearch hlsearch
set ignorecase smartcase
set gdefault
set showmatch

set nobackup noswapfile
set undofile
set undodir=~/.vim/undodir

set modeline nowrap
set relativenumber
set cursorline showmode showcmd ruler
set colorcolumn=79
set ttyfast
set wildmenu
set wildignore=*.pyc
set hidden
set scrolloff=3

" gimme cyrillics
set keymap=russian-jcukenwin
set iminsert=0
set imsearch=0

" Ё!
set spelllang=ru_yo,en_gb
autocmd FileType rst setlocal spell

" press space to clear search highlighting
nnoremap <silent> <Space> :noh<CR>

" map toggling paste mode
nnoremap <F2> :set invpaste paste?<CR>
set pastetoggle=<F2>
set invpaste

set background=dark
if has('gui_running')
    set guioptions=a
    colorscheme zenburn
    set guifont=Terminus\ 11
    set cursorcolumn
else
    set t_Co=16
    colorscheme ir_black
endif

set textwidth=79

" open epub as zip archive
au BufReadCmd *.epub call zip#Browse(expand("<amatch>"))

" beat some sense into python-mode
let g:pymode_folding = 0
let g:pymode_lint_ignore = "E301,E302"

" format headers in rST (<leader>1 then symbol)
nnoremap <leader>1 yypVr

