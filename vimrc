filetype plugin on
filetype indent on
syntax on

set expandtab shiftwidth=4 softtabstop=4 tabstop=4
set list
set listchars=tab:▹\ ,eol:↵,trail:▿
nmap <leader>l :set list! relativenumber!<CR>

set incsearch hlsearch
set ignorecase smartcase
set gdefault
set showmatch

" split windows
set splitbelow splitright

if has('nvim')
    set inccommand=split
endif

nnoremap / /\v
vnoremap / /\v

nnoremap <up> <nop>
nnoremap <down> <nop>
nnoremap <left> <nop>
nnoremap <right> <nop>
vnoremap <up> <nop>
vnoremap <down> <nop>
vnoremap <left> <nop>
vnoremap <right> <nop>

nnoremap j gj
nnoremap k gk

inoremap <F1> <ESC>
nnoremap <F1> <ESC>
vnoremap <F1> <ESC>

set nobackup noswapfile
set undofile
set undodir=~/.vim/undodir

autocmd FocusLost * :wa

set modeline nowrap
set relativenumber
set cursorline showmode showcmd ruler
set colorcolumn=79
set textwidth=79
set backspace=indent,eol,start
set formatoptions-=t
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
autocmd FileType {rst,markdown} setlocal spell formatoptions+=t
autocmd FileType crontab setlocal backupcopy=yes
autocmd FileType yaml setlocal shiftwidth=2 softtabstop=2 tabstop=2

" press space to clear search highlighting
nnoremap <silent> <Space> :noh<CR>

" map toggling paste mode
nnoremap <F2> :set invpaste paste?<CR>
set pastetoggle=<F2>

nnoremap <leader>w :%s/\s\+$//<cr>:let @/=''<CR>

set background=dark
colorscheme solarized
if has('gui_running')
    set guioptions=a
    set cursorcolumn
    set mouse="a"
    if has("gui_macvim")
        set macligatures
        set guifont=Fira\ Code:h16
    elseif ! has("gui_vimr")
        set guifont=xos4\ Terminus\ 11
    endif
else
    set mouse=
endif

" open epub as zip archive
autocmd BufReadCmd *.epub call zip#Browse(expand("<amatch>"))

" beat some sense into python-mode
let g:pymode_folding = 0
let g:pymode_lint_ignore = ["E301", "E302"]

" format headers in rST (<leader>1 then symbol)
nnoremap <leader>1 yypVr
" wrap current paragraph
nnoremap <leader>P vipgq

" FZF/Skim stuff
nnoremap <silent> <leader>f :Files<CR>
nnoremap <silent> <leader>b :Buffers<CR>


" don't let YankRing conflict with CtrlP
let g:yankring_replace_n_nkey = '<m-n>'
let g:yankring_replace_n_pkey = '<m-p>'

" don't litter my $HOME
let g:yankring_history_dir = "$HOME/.vim"

" Grepper settings
let g:grepper = {}
let g:grepper.tools = ['rg', 'ag', 'pt', 'ack', 'git', 'grep']
" shove results into location list
" let g:grepper.quickfix = 0
command! -nargs=+ -complete=file Rg Grepper -noprompt -tool rg -query <args>

" ALE settings
let g:ale_python_pylint_options = "-d broad-except"
" ALE mappings
nmap <silent> <leader>e <Plug>(ale_next_wrap)
