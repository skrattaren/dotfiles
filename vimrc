filetype plugin on
filetype indent on

set paste

set expandtab shiftwidth=4 softtabstop=4 tabstop=4
set list
set listchars=tab:▹\ ,eol:↵,trail:▿
nmap <leader>l :set list!<CR>

set incsearch hlsearch smartcase
set modeline nowrap
set relativenumber
set cursorline showmode showcmd ruler
set ttyfast
set wildmenu

" Press space to clear search highlighting
nnoremap <silent> <Space> :noh<CR>

" Map toggling paste mode
nnoremap <F2> :set invpaste paste?<CR>
set pastetoggle=<F2>
set invpaste

colorscheme ir_black

