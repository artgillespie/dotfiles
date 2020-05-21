filetype plugin indent on

set encoding=utf-8

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

" NERDTree
"
" toggle with F7
noremap <F7> :NERDTreeToggle<CR>
" show hidden files by default; use I (shift+i) to toggle
let NERDTreeShowHidden=1


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

autocmd FileType cpp setlocal shiftwidth=4 tabstop=4
autocmd FileType cpp nmap gd :YcmCompleter GoTo<CR>
autocmd FileType cpp nmap <F2> :YcmCompleter FixIt<CR>
autocmd FileType cpp nmap <c-t> <c-o>

" project-specific vimrc files
"
set exrc
set secure

echom ">^.^<"

imap <c-u> <esc>viwUi
nmap <c-u> viwU

