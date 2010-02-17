filetype plugin on
filetype indent on

set expandtab shiftwidth=4 softtabstop=4
set incsearch ignorecase hlsearch

" Press space to clear search highlighting and any message already displayed.
nnoremap <silent> <Space> :silent noh<Bar>echo<CR>

" Map toggling paste mode
nnoremap <F2> :set invpaste paste?<CR>
set pastetoggle=<F2>
set showmode

