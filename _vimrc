set bg=dark
set number
set showmode
set ruler
syntax on
set directory=/tmp

" Status Line
set laststatus=2
set statusline=\ %f\ %m\ %r\ %y%=L:\ %l/%L,%c%V\ \ \ %p%%\ %P\ 
highlight statusline cterm=bold ctermfg=Green ctermbg=Black

" put plugins in discrete subdirectories:
call pathogen#infect()

set nofoldenable

"highlight Comment ctermfg=LightBlue
filetype plugin indent on
set noexpandtab
set copyindent
set preserveindent
set softtabstop=0

" Language-specific settings
autocmd FileType c setlocal shiftwidth=4
autocmd FileType c setlocal tabstop=4

autocmd FileType cpp setlocal shiftwidth=4
autocmd FileType cpp setlocal tabstop=4

autocmd FileType perl setlocal shiftwidth=4
autocmd FileType perl setlocal tabstop=4

autocmd FileType make setlocal noexpandtab

set grepprg=grep\ -nH\ $*
let g:tex_flavour = "latex"
autocmd FileType tex setlocal shiftwidth=4
autocmd FileType tex setlocal tabstop=4
autocmd FileType tex setlocal tw=80

autocmd FileType mkd setlocal tw=80
