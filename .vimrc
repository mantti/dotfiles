"if using a version 6 vim, enable folding
if version >= 600
set foldenable
set foldmethod=marker
endif

""""""""""""""""""""""""""""""""""""""""
" General
""""""""""""""""""""""""""""""""""""""""
set nocompatible	" get out of horrible vi-compatible mode
filetype on		" detect the type of file
set history=1000	" How many lines of history to remember
filetype plugin on	" load filetype plugins
"set isk+=_,$,@,%,",-	" none of these should be word dividers, so make them not be
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
set nowrap		" do not wrap lines  
set smarttab		" use tabs at the start of a line, spaces elsewhere

" Own modifications

" Try to do the Right Thing<TM> with pastes
" set paste

" Some abreviations 
ab @T @tut.fi

" Insert current time
map \<F8> :r!date^MI# ^[j

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

" Use special settings for mail-mode
autocmd FileType mail setlocal tw=8 tw=72 nosmartindent nocindent
source ~/ansible/ansible.vim/ansible.vim
"// vim: ts=8 noet
