filetype plugin indent on

set tabstop=2
set shiftwidth=2
" tabs are spaces, as god intended
set expandtab

set autoindent
set smartindent

" for vim-go, automatically save file when running :GoBuild
set autowrite

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

" golang
"
"
autocmd FileType go nmap <leader>b  <Plug>(go-build)
autocmd FileType go nmap <leader>r  <Plug>(go-run)
autocmd FileType go nmap <leader>t <Plug>(go-test)
autocmd FileType go nmap <leader>t <Plug>(go-test-func)
let g:go_fmt_command = "goimports"

" project-specific vimrc files
"
set exrc
set secure

