"if using a version 6 vim, enable folding
if version >= 600
set foldenable
set foldmethod=marker
endif

""""""""""""""""""""""""""""""""""""""""
" General
""""""""""""""""""""""""""""""""""""""""
set nocompatible	" get out of horrible vi-compatible mode
filetype off		" detect the type of file
set history=1000	" How many lines of history to remember
"filetype plugin on	" load filetype plugins
"set isk+=_,$,@,%,",-	" none of these should be word dividers, so make them not be
"set iskeywords+=_,$,@,%,",-	" none of these should be word dividers, so make them not be

""""""""""""""""""""""""""""""""""""""""
" Vundle
""""""""""""""""""""""""""""""""""""""""
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'VundleVim/Vundle.vim'
Bundle 'pearofducks/ansible-vim'
"Bundle 'chase/vim-ansible-yaml'
"Bundle 'ycm-core/YouCompleteMe'

call vundle#end()            " required
filetype plugin indent on    " required

""""""""""""""""""""""""""""""""""""""""
" Theme/Colors
""""""""""""""""""""""""""""""""""""""""
set background=dark	" we are using a dark background
syntax on		" syntax highlighting on
""""""""""""""""""""""""""""""""""""""""
" Vim UI
""""""""""""""""""""""""""""""""""""""""
set hid			" you can change buffer without saving
set report=0		" tell us when anything is changed via :...
set noerrorbells	" don't make noise
""""""""""""""""""""""""""""""""""""""""
" Visual Cues
""""""""""""""""""""""""""""""""""""""""
set showmatch		" show matching brackets
set so=5		" Keep 10 lines (top/bottom) for scope
set novisualbell	" don't blink
set noerrorbells	" no noises
""""""""""""""""""""""""""""""""""""""""
" Text Formatting/Layout
""""""""""""""""""""""""""""""""""""""""
set noai		" autoindent
set si			" smartindent 
set cindent		" do c-style indenting
set tabstop=4		" tab spacing (settings below are just to unify it)
set softtabstop=4	" unify
set shiftwidth=4	" unify 
set noexpandtab		" real tabs please!
autocmd FileType YAML setlocal expandtab " We'll need to use spaces instead of tabulators
set nowrap		" do not wrap lines  
set smarttab		" use tabs at the start of a line, spaces elsewhere

" Own modifications

" Use different coloscheme for vimdiff-cmd
if &diff
    colorscheme blue
endif

" Try to do the Right Thing<TM> with pastes
" set paste

" Some abreviations 
ab @T @tuni.fi

" Insert current time
map \<F8> :r!date^MI# ^[j

" Prevent accidental undo 
inoremap <c-u> <c-g>u<c-u>
inoremap <c-w> <c-g>u<c-w>
function HideComments()"{{{
set fdm=expr
set fde=getline(v:lnum)=~'\\s*#'?1:getline(prevnonblank(v:lnum))=~'\\s*#'?1:getline(nextnonblank(v:lnum))=~'^\\s*#'?1:0
" folds are open per default..
" set nofen
endfunction "}}}

fu! FileTime()"{{{
    let ext=tolower(expand("%:e"))
    let fname=tolower(expand('%<'))
    let filename=fname . '.' . ext
    let msg=""
    let msg=msg." ".strftime("(Modified %b,%d %y %H:%M:%S)",getftime(filename))
    return msg
endf"}}}

fu! CurTime()"{{{
    let ftime=""
    let ftime=ftime." ".strftime("%d/%m %H:%M")
    return ftime
endf "}}}
set statusline=%<%f%<%{FileTime()}%<%h%m%r%=%-20.(line=%03l,col=%02c%V,totlin=%L%)\%h%m%r%=%-30(,BfNm=%n%Y%)\%P\*%=%{CurTime()}
set rulerformat=%15(%c%V\ %p%%%)
set ls=2    

" Python settings
au BufNewFile,BufRead *.py *.yml *.yaml
    \ setlocal tabstop=4
    \ setlocal softtabstop=4
    \ setlocal shiftwidth=4
    \ setlocal textwidth=110
    \ setlocal expandtab
    \ setlocal smarttab
    \ setlocal autoindent
    \ setlocal fileformat=unix
    \ match BadWhitespace /\s\+$/

" Use special settings for mail-mode
autocmd FileType mail setlocal tw=8 tw=72 nosmartindent nocindent

" Faster Scrolling
nnoremap <C-e> 10<C-e>
nnoremap <C-y> 10<C-y>

" Load all plugins now.
" Plugins need to be added to runtimepath before helptags can be generated.
packloadall
" Load all of the helptags now, after plugins have been loaded.
" All messages and errors will be ignored.
silent! helptags ALL

"// vim: ts=8 noet


