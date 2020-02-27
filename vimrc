filetype plugin on

set tabstop=2
set shiftwidth=2
" tabs are spaces, as god intended
set expandtab

" vim-code-dark (make vim look like vscode)
colorscheme codedark

" show line numbers
set number

" toggle NERD tree with F7
noremap <F7> :NERDTreeToggle<CR>

" please stop leaving swp files everywhere, thx
set directory=~/tmp

" prettier format on save 
let g:prettier#autoformat_require_pragma = 0

