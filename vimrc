filetype plugin on
filetype indent on

set expandtab shiftwidth=4 softtabstop=4
set incsearch hlsearch smartcase
set modeline nowrap
set relativenumber
set cursorline ruler showmode showcmd
set ttyfast
set wildmenu

" Press space to clear search highlighting and any message already displayed.
nnoremap <silent> <Space> :silent noh<Bar>echo<CR>

" Map toggling paste mode
nnoremap <F2> :set invpaste paste?<CR>
set pastetoggle=<F2>
set showmode
set invpaste paste

colorscheme ir_black

