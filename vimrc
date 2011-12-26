filetype plugin on
filetype indent on

set paste

set expandtab shiftwidth=4 softtabstop=4 tabstop=4
set list
set listchars=tab:▹\ ,eol:↵,trail:▿
nmap <leader>l :set list! relativenumber!<CR>

set incsearch hlsearch smartcase
set gdefault
set showmatch

set modeline nowrap
set relativenumber
set cursorline showmode showcmd ruler
set colorcolumn=83
set ttyfast
set wildmenu

" Press space to clear search highlighting
nnoremap <silent> <Space> :noh<CR>

" Map toggling paste mode
nnoremap <F2> :set invpaste paste?<CR>
set pastetoggle=<F2>
set invpaste

set background=dark
if has('gui_running')
    set guioptions=a
    colorscheme solarized
    set guifont=Terminus\ 11
else
    set t_Co=16
    colorscheme ir_black
endif

set textwidth=79

