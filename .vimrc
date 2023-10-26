" vim: spell
"if using a version 6 vim, enable folding
if version >= 600
set foldenable
set foldmethod=marker
endif

""""""""""""""""""""""""""""""""""""""""
" General
""""""""""""""""""""""""""""""""""""""""
set nocompatible	" get out of horrible vi-compatible mode
"filetype off		" detect the type of file
set history=1000	" How many lines of history to remember
filetype plugin on	" load filetype plugins
"set isk+=_,$,@,%,",-	" none of these should be word dividers, so make them not be
"set iskeywords+=_,$,@,%,",-	" none of these should be word dividers, so make them not be
set spelllang=en_gb	" default spellcheck language
set nrformats-=octal    " Don't think 007 means octal numbers
""""""""""""""""""""""""""""""""""""""""
" Theme/Colors
""""""""""""""""""""""""""""""""""""""""
let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
set termguicolors " Enable full 24-bit colors for gnome-terminal
set background=dark	" we are using a dark background by default
syntax on		" syntax highlighting on
"let g:solarized_termcolors=256 " Tell the solarized colorscheme to use all colors
colorscheme solarized " Select solarized colorscheme <https://github.com/altercation/vim-colors-solarized>
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
set mouse=""        " we don't want mouse support from editor
set incsearch       " incremental search with /
""""""""""""""""""""""""""""""""""""""""
" Text Formatting/Layout
""""""""""""""""""""""""""""""""""""""""
set noai		" autoindent
set si			" smartindent 
set cindent		" do c-style indenting
set tabstop=4		" tab spacing (settings below are just to unify it)
set softtabstop=4	" unify
set shiftwidth=4	" unify 
set expandtab		" real tabs have been deprecated in so many places nowadays
" autocmd FileType YAML setlocal expandtab " We'll need to use spaces instead of tabulators
set nowrap		" do not wrap lines  
"set smarttab		" use tabs at the start of a line, spaces elsewhere

" Own modifications

runtime macros/matchit.vim

" Use different coloscheme for vimdiff-cmd
if &diff
    colorscheme blue
endif

" Try to do the Right Thing<TM> with pastes
" set paste

" Some abreviations 
"ab @T @tut.fi

" Insert current time
map \<F8> :r!date^MI# ^[j

map <F11> :tabprev
map <F12> :tabNext

" vim doesn't use Scandinavian keys in normal mode, so let's put them to better use
"    nnoremap ö ;
"    nnoremap Ö :
"    nnoremap ; <
"    nnoremap : >
"    vnoremap ö ;
"    vnoremap Ö :
"    vnoremap ; <
"    vnoremap : >

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

" For tmux-window plugin
"let g:tmux_navigator_no_mappings = 1
"
"noremap <silent> <C-m> :<C-U>TmuxNavigateLeft<cr>
"noremap <silent> <C-n> :<C-U>TmuxNavigateDown<cr>
"noremap <silent> <C-e> :<C-U>TmuxNavigateUp<cr>
"noremap <silent> <C-i> :<C-U>TmuxNavigateRight<cr>
"noremap <silent> <C-p> :<C-U>TmuxNavigatePrevious<cr>
"
"nmap m h
"nmap n j
"nmap e k
"nmap i l
"
"vmap m h
"vmap n j
"vmap e k
"vmap i l

" Python settings
" au BufNewFile,BufRead *.py *.yml
"     \ set tabstop=4
"     \ set softtabstop=4
"     \ set shiftwidth=4
"     \ set textwidth=110
"     \ set expandtab
"     \ set autoindent
"     \ set fileformat=unix
"     \ match BadWhitespace /\s\+$/

" Use special settings for mail-mode
autocmd FileType mail setlocal tw=8 tw=72 nosmartindent nocindent
"// vim: ts=8 noet
" Spellchecking and wrapping at 72 in git commit msgs
autocmd Filetype gitcommit setlocal spell textwidth=72

" Load all plugins now.
" Plugins need to be added to runtimepath before helptags can be generated.
packloadall
" Load all of the helptags now, after plugins have been loaded.
" All messages and errors will be ignored.
silent! helptags ALL
