" .vimrc
" Author: Steve Losh <steve@stevelosh.com>
" Source: http://bitbucket.org/sjl/dotfiles/src/tip/vim/
"
" This file changes a lot.  I'll try to document pieces of it whenever I have
" a few minutes to kill.

" Preamble -------------------------------------------------------------------- {{{

filetype off
call pathogen#runtime_append_all_bundles()
filetype plugin indent on
set nocompatible

" }}}
" Basic options --------------------------------------------------------------- {{{

set encoding=utf-8
set modelines=0
set scrolljump=5
set scrolloff=3
set autoindent
set showmode
set foldenable



if has('cmdline_info')
		set ruler                  	" show the ruler
		set rulerformat=%30(%=\:b%n%y%m%r%w\ %l,%c%V\ %P%) " a ruler on steroids
		set showcmd                	" show partial commands in status line and
									" selected characters/lines in visual mode
endif

set showcmd
set hidden
set wildmenu
set wildmode=list:longest,full
set whichwrap=b,s,h,l,<,>,[,]
set visualbell
set cursorline
set ttyfast
set ruler
set backspace=indent,eol,start   
set nu
set nonumber
set norelativenumber
set history=1000
set undofile
set undoreload=10000
set cpoptions+=J
set list
set listchars=tab:▸\ ,eol:¬
set shell=/bin/bash
set lazyredraw
set wildignore+=*.pyc,.hg,.git
set matchtime=3
set showbreak=↪
set splitbelow
set splitright

" Save when losing focus
" au FocusLost * :wa

" Tabs, spaces, wrapping {{{

set tabstop=2
set shiftwidth=2
set softtabstop=2
set expandtab
set nowrap
set textwidth=120
set formatoptions=qrn1
" set colorcolumn=+1

" }}}
" Status line {{{

if has('statusline')
  set laststatus=2                                          " statusline setup  
  "set statusline=\ \ \ \ \ line:%l\ column:%c\ \ \ %M%Y%r%=%-14.(%t%)\ %p%%
  set statusline=   " clear the statusline, allow for rearranging parts
  set statusline+=%f\                "Path to the file, as typed or relative to current dir
  set statusline+=%#errormsg#        "change color
  set statusline+=%{&ff!='unix'?'['.&ff.']':''}   "display a warning if fileformat isnt unix
  set statusline+=%*                "reset color to normal statusline color
  set statusline+=%#errormsg#       "change color
  set statusline+=%{(&fenc!='utf-8'&&&fenc!='')?'['.&fenc.']':''}   "display a warning if file encoding isnt utf-8
  set statusline+=%*                "reset color to normal statusline color
  set statusline+=\ %y              "filetype
  set statusline+=%([%R%M]%)        "read-only (RO), modified (+) and unmodifiable (-) flags between braces
  set statusline+=%{'~'[&pm=='']}   "shows a '~' if in patchmode
  set statusline+=\ %{fugitive#statusline()}  "show Git info, via fugitive.git
  "set statusline+=\ (%{synIDattr(synID(line('.'),col('.'),0),'name')}) "DEBUG : display the current syntax item name
  set statusline+=%#error#          "change color
  set statusline+=%{&paste?'[paste]':''}    "display a warning if &paste is set
  set statusline+=%*                "reset color to normal statusline color
  set statusline+=%=                "right-align following items
  set statusline+=#%n               "buffer number
  set statusline+=\ %l/%L,          "current line number/total number of lines,
  set statusline+=%c                "Column number
  set statusline+=%V                " -{Virtual column number} (Not displayed if equal to 'c')
  set statusline+=\ %p%%            "percentage of lines through the file%
  set statusline+=\                 "trailing space
  if has('title')
    set titlestring=%t%(\ [%R%M]%)
  endif
endif





" }}}
" Backups {{{

set undodir=~/.vim/tmp/undo//     " undo files
set backupdir=~/.vim/tmp/backup// " backups
set directory=~/.vim/tmp/swap//   " swap files
set backup                        " enable backups

" }}}
" Leader {{{

let mapleader = ","
let maplocalleader = "\\"

" }}}
" Color scheme {{{

syntax on
set background=dark
colorscheme molokai
set tabpagemax=15 "only show 15 tabs

" }}}

" }}}
" Useful abbreviations -------------------------------------------------------- {{{

iabbrev ldis ಠ_ಠ


" }}}
" Searching and movement ------------------------------------------------------ {{{
                      
" Fix home and end keybindings for screen, particularly on mac
" - for some reason this fixes the arrow keys too. huh.
" map [F $
" imap [F $
" map [H g0
" imap [H g0

nnoremap <up> <nop>
nnoremap <down> <nop>
nnoremap <left> <nop>
nnoremap <right> <nop>
inoremap <up> <nop>
inoremap <down> <nop>
inoremap <left> <nop>
inoremap <right> <nop>                                                  

" Wrapped lines goes down/up to next row, rather than next line in file.
" nnoremap j gj
" nnoremap k gk       

" Stupid shift key fixes
cmap W w 						
cmap WQ wq
cmap wQ wq
cmap Q q
cmap Tabe tabe

""" Code folding options
nmap <leader>f0 :set foldlevel=0<CR>
nmap <leader>f1 :set foldlevel=1<CR>
nmap <leader>f2 :set foldlevel=2<CR>
nmap <leader>f3 :set foldlevel=3<CR>
nmap <leader>f4 :set foldlevel=4<CR>
nmap <leader>f5 :set foldlevel=5<CR>
nmap <leader>f6 :set foldlevel=6<CR>
nmap <leader>f7 :set foldlevel=7<CR>
nmap <leader>f8 :set foldlevel=8<CR>
nmap <leader>f9 :set foldlevel=9<CR>

"clearing highlighted search
nmap <silent> <leader>/ :nohlsearch<CR>     

" Shortcuts

" Change Working Directory to that of the current file
cmap cwd lcd %:p:h
cmap cd. lcd %:p:h

" visual shifting (does not exit Visual mode)
vnoremap < <gv
vnoremap > >gv

	
" For when you forget to sudo.. Really Write the file.
cmap w!! w !sudo tee % >/dev/null


" Use sane regexes.
nnoremap / /\v
vnoremap / /\v

set ignorecase
set smartcase

set incsearch
set showmatch
set hlsearch

set gdefault

set virtualedit+=block

" map <leader><space> :noh<cr>

runtime macros/matchit.vim
map <tab> %

" Yank from the cursor to the end of the line, to be consistent with C and D.
nnoremap Y y$
nnoremap D d$

" Keep search matches in the middle of the window.
" nnoremap * *zzzv
" nnoremap # #zzzv
" nnoremap n nzzzv
" nnoremap N Nzzzv

" L is easier to type, and I never use the default behavior.
" noremap L $

" Heresy
" inoremap <c-a> <esc>I
" inoremap <c-e> <esc>A

" Open a Quickfix window for the last search
" nnoremap <silent> <leader>/ :execute 'vimgrep /'.@/.'/g %'<CR>:copen<CR>

" Fix linewise visual selection of various text objects
" nnoremap Vit vitVkoj
" nnoremap Vat vatV
" nnoremap Vab vabV
" nnoremap VaB vaBV

" Error navigation {{{
"
"             Location List     QuickFix Window
"            (e.g. Syntastic)     (e.g. Ack)
"            ----------------------------------
" Next      |     M-k               M-Down     |
" Previous  |     M-l                M-Up      |
"            ----------------------------------
"
" nnoremap ˚ :lnext<cr>zvzz
" nnoremap ¬ :lprevious<cr>zvzz
" inoremap ˚ <esc>:lnext<cr>zvzz
" inoremap ¬ <esc>:lprevious<cr>zvzz
" nnoremap <m-Down> :cnext<cr>zvzz
" nnoremap <m-Up> :cprevious<cr>zvzz
" }}}

" Directional Keys {{{

" Easy buffer navigation
noremap <C-j>  <C-w>j
noremap <C-k>  <C-w>k
noremap <C-l>  <C-w>l
noremap <C-h>  <C-w>h
noremap <leader>g <C-w>v

" Easier moving in tabs and windows
map <C-J> <C-W>j<C-W>_
map <C-K> <C-W>k<C-W>_
map <C-L> <C-W>l<C-W>_
map <C-H> <C-W>h<C-W>_
map <C-K> <C-W>k<C-W>_



" }}}

" }}}
" Folding --------------------------------------------------------------------- {{{

set foldlevelstart=99

" Space to toggle folds.
nnoremap <Space> za
vnoremap <Space> za

" Make zO recursively open whatever top level fold we're in, no matter where the
" cursor happens to be.
nnoremap zO zCzO

function! MyFoldText() " {{{
    let line = getline(v:foldstart)

    let nucolwidth = &fdc + &number * &numberwidth
    let windowwidth = winwidth(0) - nucolwidth - 3
    let foldedlinecount = v:foldend - v:foldstart

    " expand tabs into spaces
    let onetab = strpart('          ', 0, &tabstop)
    let line = substitute(line, '\t', onetab, 'g')

    let line = strpart(line, 0, windowwidth - 2 -len(foldedlinecount))
    let fillcharcount = windowwidth - len(line) - len(foldedlinecount)
    return line . '…' . repeat(" ",fillcharcount) . foldedlinecount . '…' . ' '
endfunction " }}}
set foldtext=MyFoldText()

" }}}
" Destroy infuriating keys ---------------------------------------------------- {{{

" Fuck you, help key.
set fuoptions=maxvert,maxhorz
noremap <F1> :set invfullscreen<CR>
inoremap <F1> <ESC>:set invfullscreen<CR>a

" Fuck you too, manual key.
nnoremap K <nop>

" Stop it, hash key.
inoremap # X<BS>#

" }}}
" Various filetype-specific stuff --------------------------------------------- {{{

" Cram {{{

au BufNewFile,BufRead *.t set filetype=cram

let cram_fold=1
autocmd Syntax cram setlocal foldlevel=1

" }}}
" Clojure {{{

au FileType clojure call TurnOnClojureFolding()

" Eval toplevel form, even when you're on the opening paren.
au FileType clojure nmap <localleader>ee 0;\et

" }}}
" C {{{

au FileType c setlocal foldmethod=syntax

" }}}
" HTML and HTMLDjango {{{

" au BufNewFile,BufRead *.html setlocal filetype=htmldjango
au BufNewFile,BufRead *.html setlocal foldmethod=manual

" Use <localleader>f to fold the current tag.
au BufNewFile,BufRead *.html nnoremap <buffer> <localleader>f Vatzf
au BufNewFile,BufRead *.html nnoremap <buffer> VV vatV

" Use Shift-Return to turn this:
"     <tag>|</tag>
"
" into this:
"     <tag>
"         |
"     </tag>
au BufNewFile,BufRead *.html inoremap <buffer> <s-cr> <cr><esc>kA<cr>
au BufNewFile,BufRead *.html nnoremap <buffer> <s-cr> vit<esc>a<cr><esc>vito<esc>i<cr><esc>

" Django tags
au FileType jinja,htmldjango inoremap <buffer> <c-t> {%<space><space>%}<left><left><left>

" Django variables
au FileType jinja,htmldjango inoremap <buffer> <c-f> {{<space><space>}}<left><left><left>

" }}}
" CSS and LessCSS {{{

au BufNewFile,BufRead *.less setlocal filetype=less

au BufNewFile,BufRead *.css  setlocal foldmethod=marker
au BufNewFile,BufRead *.less setlocal foldmethod=marker

au BufNewFile,BufRead *.css  setlocal foldmarker={,}
au BufNewFile,BufRead *.less setlocal foldmarker={,}

" Use cc to change lines without borking the indentation.
au BufNewFile,BufRead *.css  nnoremap <buffer> cc ddko
au BufNewFile,BufRead *.less nnoremap <buffer> cc ddko

" Use <leader>S to sort properties.  Turns this:
"
"     p {
"         width: 200px;
"         height: 100px;
"         background: red;
"
"         ...
"     }
"
" into this:

"     p {
"         background: red;
"         height: 100px;
"         width: 200px;
"
"         ...
"     }
"
au BufNewFile,BufRead *.css  nnoremap <buffer> <localleader>S ?{<CR>jV/\v^\s*\}?$<CR>k:sort<CR>:noh<CR>
au BufNewFile,BufRead *.less nnoremap <buffer> <localleader>S ?{<CR>jV/\v^\s*\}?$<CR>k:sort<CR>:noh<CR>

" Make {<cr> insert a pair of brackets in such a way that the cursor is correctly
" positioned inside of them AND the following code doesn't get unfolded.
au BufNewFile,BufRead *.css  inoremap <buffer> {<cr> {}<left><cr>.<cr><esc>kA<bs><space><space><space><space>
au BufNewFile,BufRead *.less inoremap <buffer> {<cr> {}<left><cr>.<cr><esc>kA<bs><space><space><space><space>

" }}}
" Javascript {{{

au FileType javascript setlocal foldmethod=marker
au FileType javascript setlocal foldmarker={,}

" }}}
" Confluence {{{

au BufRead,BufNewFile *.confluencewiki setlocal filetype=confluencewiki

" Wiki pages should be soft-wrapped.
au FileType confluencewiki setlocal wrap linebreak nolist

" }}}
" Fish {{{

au BufNewFile,BufRead *.fish setlocal filetype=fish

" }}}
" Markdown {{{

au BufNewFile,BufRead *.m*down setlocal filetype=markdown

" Use <localleader>1/2/3 to add headings.
au Filetype markdown nnoremap <buffer> <localleader>1 yypVr=
au Filetype markdown nnoremap <buffer> <localleader>2 yypVr-
au Filetype markdown nnoremap <buffer> <localleader>3 I### <ESC>

" }}}
" Vim {{{

au FileType vim setlocal foldmethod=marker
au FileType help setlocal textwidth=78

" }}}
" Python {{{

au Filetype python noremap  <localleader>rr :RopeRename<CR>
au Filetype python vnoremap <localleader>rm :RopeExtractMethod<CR>
au Filetype python noremap  <localleader>ri :RopeOrganizeImports<CR>
au FileType python setlocal omnifunc=pythoncomplete#Complete

" }}}
" Django {{{

au BufNewFile,BufRead urls.py      setlocal nowrap
au BufNewFile,BufRead urls.py      normal! zR
au BufNewFile,BufRead dashboard.py normal! zR

au BufNewFile,BufRead admin.py     setlocal filetype=python.django
au BufNewFile,BufRead urls.py      setlocal filetype=python.django
au BufNewFile,BufRead models.py    setlocal filetype=python.django
au BufNewFile,BufRead views.py     setlocal filetype=python.django
au BufNewFile,BufRead settings.py  setlocal filetype=python.django
au BufNewFile,BufRead settings.py  setlocal foldmethod=marker
au BufNewFile,BufRead forms.py     setlocal filetype=python.django
au BufNewFile,BufRead common_settings.py  setlocal filetype=python.django
au BufNewFile,BufRead common_settings.py  setlocal foldmethod=marker

" }}}
" Nginx {{{

au BufRead,BufNewFile /etc/nginx/conf/*                      set ft=nginx
au BufRead,BufNewFile /etc/nginx/sites-available/*           set ft=nginx
au BufRead,BufNewFile /usr/local/etc/nginx/sites-available/* set ft=nginx

" }}}
" Pentadactyl {{{

au BufNewFile,BufRead .pentadactylrc set filetype=pentadactyl

" }}}
" Vagrant {{{

au BufRead,BufNewFile Vagrantfile set ft=ruby

" }}}
" Puppet {{{

au Filetype puppet setlocal foldmethod=marker
au Filetype puppet setlocal foldmarker={,}

" }}}
" Firefox {{{

au BufRead,BufNewFile ~/Library/Caches/* setlocal buftype=nofile

" }}}
" ReStructuredText {{{

au Filetype rst nnoremap <buffer> <localleader>1 yypVr=
au Filetype rst nnoremap <buffer> <localleader>2 yypVr-
au Filetype rst nnoremap <buffer> <localleader>3 yypVr~
au Filetype rst nnoremap <buffer> <localleader>4 yypVr`

" }}}

" }}}
" Convenience mappings -------------------------------------------------------- {{{

" Clean whitespace
map <leader>W :%s/\s\+$//<cr>:let @/=''<CR>

" Change case
nnoremap <C-u> gUiw
inoremap <C-u> <esc>gUiwea

" Yankring
nnoremap <silent> <F6> :YRShow<cr>

" Formatting, TextMate-style
nnoremap <leader>q gqip

" Easier linewise reselection
nnoremap <leader>v V`]

" HTML tag closing
inoremap <C-_> <Space><BS><Esc>:call InsertCloseTag()<cr>a

" Faster Esc
" inoremap jk <ESC>

" Marks and Quotes
" noremap ' `
" noremap æ '
" noremap ` <C-^>

" Calculator
inoremap <C-B> <C-O>yiW<End>=<C-R>=<C-R>0<CR>

" Better Completion
set completeopt=longest,menuone,preview
" inoremap <expr> <CR>  pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
" inoremap <expr> <C-p> pumvisible() ? '<C-n>'  : '<C-n><C-r>=pumvisible() ? "\<lt>up>" : ""<CR>'
" inoremap <expr> <C-n> pumvisible() ? '<C-n>'  : '<C-n><C-r>=pumvisible() ? "\<lt>Down>" : ""<CR>'

" Rainbows!
nmap <leader>R :RainbowParenthesesToggle<CR>

" Edit vim stuff
nnoremap <leader>ev <C-w>s<C-w>j<C-w>L:e $MYVIMRC<cr>
nnoremap <leader>es <C-w>s<C-w>j<C-w>L:e ~/.vim/snippets/<cr>

" Sudo to write
cmap w!! w !sudo tee % >/dev/null

" Easy filetype switching
nnoremap _hd :set ft=htmldjango<CR>
nnoremap _jt :set ft=htmljinja<CR>
nnoremap _cw :set ft=confluencewiki<CR>
nnoremap _pd :set ft=python.django<CR>
nnoremap _d  :set ft=diff<CR>
nnoremap _a  :AnsiEsc<CR>

" Toggle paste
set pastetoggle=<F8>

" Replaste
nnoremap <D-p> "_ddPV`]

" }}}
" Plugin settings ------------------------------------------------------------- {{{

" Ack {{{

" map <leader>a :Ack! 

" }}}
" NERD Tree {{{

map <F2> :NERDTreeToggle<CR>:NERDTreeMirror<CR>
map <leader>e :NERDTreeFind<CR>
nmap <leader>nt :NERDTreeFind<CR>
let NERDTreeIgnore=['\.pyc', '\~$', '\.swo$', '\.swp$', '\.git', '\.hg', '\.svn', '\.bzr']
let NERDTreeShowBookmarks=1
let NERDTreeChDirMode=0
" let NERDTreeQuitOnOpen=1
" let NERDTreeShowHidden=1
let NERDTreeKeepTreeInNewTab=1

" }}}
" HTML5 {{{

let g:event_handler_attributes_complete = 0
let g:rdfa_attributes_complete = 0
let g:microdata_attributes_complete = 0
let g:atia_attributes_complete = 0

" }}}
" Show syntax filetypes in menu {{{

let do_syntax_sel_menu = 1|runtime! synmenu.vim|aunmenu &Syntax.&Show\ filetypes\ in\ menu

" }}}
" Rope {{{

let ropevim_enable_shortcuts = 0
let ropevim_guess_project = 1
let ropevim_global_prefix = '<C-c>p'

source $HOME/.vim/sadness/sadness.vim

" }}}
" Gundo {{{

nnoremap <F5> :GundoToggle<CR>
let g:gundo_debug = 1
let g:gundo_preview_bottom = 1
let g:gundo_map_move_older = "k"
let g:gundo_map_move_newer = "l"

" }}}
" VimClojure {{{

let vimclojure#HighlightBuiltins = 1
let vimclojure#ParenRainbow = 1
let vimclojure#WantNailgun = 1
let vimclojure#NailgunClient = $HOME . "/.vim/bundle/vimclojure/bin/ng"
let vimclojure#SplitPos = "right"

" }}}
" Syntastic {{{

let g:syntastic_enable_signs=1
let g:syntastic_disabled_filetypes = ['html', 'python']

" }}}
" Delimitmate {{{

au FileType * let b:delimitMate_autoclose = 1
  " If using html auto complete (complete closing tag)
  au FileType xml,html,xhtml let b:delimitMate_matchpairs = "(:),[:],{:}"

" }}}
" AutoCloseTag {{{
  " Make it so AutoCloseTag works for xml and xhtml files as well
"au FileType xhtml,xml ru ftplugin/html/autoclosetag.vim
au FileType xhtml,xml ru ~/.vim/bundle/autoclosetag/ftplugin/html/autoclose.vim

" }}}
" SnipMate {{{

" Setting the author var
" If forking, please overwrite in your .vimrc.local file
let g:snips_author = 'Andrew Cates <catesandrew@netflix.com>'
" Shortcut for reloading snippets, useful when developing
nnoremap ,smr <esc>:exec ReloadAllSnippets()<cr>    

" }}}
" ShowMarks {{{

let showmarks_include = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
" Don't leave on by default, use :ShowMarksOn to enable
let g:showmarks_enable = 0
" For marks a-z
highlight ShowMarksHLl gui=bold guibg=LightBlue guifg=Blue
" For marks A-Z
highlight ShowMarksHLu gui=bold guibg=LightRed guifg=DarkRed
" For all other marks
highlight ShowMarksHLo gui=bold guibg=LightYellow guifg=DarkYellow
" For multiple marks on the same line.
highlight ShowMarksHLm gui=bold guibg=LightGreen guifg=DarkGreen

" }}}
" Tabularize {{{

if exists(":Tabularize")
  nmap <Leader>a= :Tabularize /=<CR>
  vmap <Leader>a= :Tabularize /=<CR>
  nmap <Leader>a: :Tabularize /:<CR>
  vmap <Leader>a: :Tabularize /:<CR>
  nmap <Leader>a:: :Tabularize /:\zs<CR>
  vmap <Leader>a:: :Tabularize /:\zs<CR>
  nmap <Leader>a, :Tabularize /,<CR>
  vmap <Leader>a, :Tabularize /,<CR>
  nmap <Leader>a| :Tabularize /|<CR>
  vmap <Leader>a| :Tabularize /|<CR>
endif  

" }}}
" Ctags Variables {{{

" This will look in the current directory for 'tags', and work up the tree towards root until one is found. 
set tags=./tags;/,$HOME/vimtags
map <C-\> :tab split<CR>:exec("tag ".expand("<cword>"))<CR> " C-\ - Open the definition in a new tab
map <A-]> :vsp <CR>:exec("tag ".expand("<cword>"))<CR>      " A-] - Open the definition in a vertical split

" }}}
" EasyTags {{{

" Disabling for now. It doesn't work well on large tag files 
let g:loaded_easytags = 1  " Disable until it's working better
let g:easytags_cmd = 'ctags'
let g:easytags_dynamic_files = 1
if !has('win32') && !has('win64')
  let g:easytags_resolve_links = 1
endif


" }}}
" Taglist Variables {{{

let Tlist_Auto_Highlight_Tag = 1
let Tlist_Auto_Update = 1
let Tlist_Exit_OnlyWindow = 1
let Tlist_File_Fold_Auto_Close = 1
let Tlist_Highlight_Tag_On_BufEnter = 1
let Tlist_Use_Right_Window = 1
let Tlist_Use_SingleClick = 1

let g:ctags_statusline=1
" Override how taglist does javascript
let g:tlist_javascript_settings = 'javascript;f:function;c:class;m:method;p:property;v:global'  

" }}}
" JSON {{{

nmap <leader>jt <Esc>:%!python -m json.tool<CR><Esc>:set filetype=json<CR>                       

" }}}
" LISP (built-in) {{{

let g:lisp_rainbow = 1

" }}}
" Easymotion {{{

let g:EasyMotion_do_mapping = 0

nnoremap <silent> <Leader>f      :call EasyMotionF(0, 0)<CR>
vnoremap <silent> <Leader>f :<C-U>call EasyMotionF(1, 0)<CR>

nnoremap <silent> <Leader>F      :call EasyMotionF(0, 1)<CR>
vnoremap <silent> <Leader>F :<C-U>call EasyMotionF(1, 1)<CR>

" }}}
" Sparkup {{{

let g:sparkupExecuteMapping = '<c-s>'
let g:sparkupNextMapping = '<c-q>'

"}}}
" Autoclose {{{

nmap <Leader>x <Plug>ToggleAutoCloseMappings

" }}}
" Tasklist {{{

let g:SuperTabDefaultCompletionType = "context"
let g:SuperTabContextDefaultCompletionType = "<c-x><c-o>"

" }}}
" Tasklist {{{

let g:tlRememberPosition = 1
map <leader>td <Plug>TaskList

" }}}
" Pydoc {{{

au FileType python noremap <buffer> <localleader>lw :call ShowPyDoc('<C-R><C-W>', 1)<CR>
au FileType python noremap <buffer> <localleader>lW :call ShowPyDoc('<C-R><C-A>', 1)<CR>

" }}}
" Scratch {{{

command! ScratchToggle call ScratchToggle()
function! ScratchToggle() " {{{
  if exists("w:is_scratch_window")
    unlet w:is_scratch_window
    exec "q"
  else
    exec "normal! :Sscratch\<cr>\<C-W>J:resize 13\<cr>"
    let w:is_scratch_window = 1
  endif
endfunction " }}}
nnoremap <silent> <leader><tab> :ScratchToggle<cr>

" }}}
" OrgMode {{{
let g:org_plugins = ['ShowHide', '|', 'Navigator', 'EditStructure', '|', 'Todo', 'Misc']

let g:org_todo_keywords = ['TODO', 'HOLD', '|', 'DONE']
let g:org_debug = 1
" }}}
" DirDiff {{{
map <unique> <Leader>Dg <Plug>DirDiffGet
map <unique> <Leader>Dp <Plug>DirDiffPut
map <unique> <Leader>Dj <Plug>DirDiffNext
map <unique> <Leader>Dk <Plug>DirDiffPrev
" }}}

" }}}
" Synstack -------------------------------------------------------------------- {{{

" Show the stack of syntax hilighting classes affecting whatever is under the
" cursor.
function! SynStack() " {{{
  if !exists("*synstack")
    return
  endif

  echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
endfunc " }}}

nmap <M-S> :call SynStack()<CR>

" }}}
" Text objects ---------------------------------------------------------------- {{{

" Shortcut for [] {{{

onoremap id i[
onoremap ad a[
vnoremap id i[
vnoremap ad a[

" }}}
" Next/Last () {{{
vnoremap <silent> inb :<C-U>normal! f(vib<cr>
onoremap <silent> inb :<C-U>normal! f(vib<cr>
vnoremap <silent> anb :<C-U>normal! f(vab<cr>
onoremap <silent> anb :<C-U>normal! f(vab<cr>
vnoremap <silent> in( :<C-U>normal! f(vi(<cr>
onoremap <silent> in( :<C-U>normal! f(vi(<cr>
vnoremap <silent> an( :<C-U>normal! f(va(<cr>
onoremap <silent> an( :<C-U>normal! f(va(<cr>

vnoremap <silent> ilb :<C-U>normal! F)vib<cr>
onoremap <silent> ilb :<C-U>normal! F)vib<cr>
vnoremap <silent> alb :<C-U>normal! F)vab<cr>
onoremap <silent> alb :<C-U>normal! F)vab<cr>
vnoremap <silent> il( :<C-U>normal! F)vi(<cr>
onoremap <silent> il( :<C-U>normal! F)vi(<cr>
vnoremap <silent> al( :<C-U>normal! F)va(<cr>
onoremap <silent> al( :<C-U>normal! F)va(<cr>
" }}}
" Next/Last {} {{{
vnoremap <silent> inB :<C-U>normal! f{viB<cr>
onoremap <silent> inB :<C-U>normal! f{viB<cr>
vnoremap <silent> anB :<C-U>normal! f{vaB<cr>
onoremap <silent> anB :<C-U>normal! f{vaB<cr>
vnoremap <silent> in{ :<C-U>normal! f{vi{<cr>
onoremap <silent> in{ :<C-U>normal! f{vi{<cr>
vnoremap <silent> an{ :<C-U>normal! f{va{<cr>
onoremap <silent> an{ :<C-U>normal! f{va{<cr>

vnoremap <silent> ilB :<C-U>normal! F}viB<cr>
onoremap <silent> ilB :<C-U>normal! F}viB<cr>
vnoremap <silent> alB :<C-U>normal! F}vaB<cr>
onoremap <silent> alB :<C-U>normal! F}vaB<cr>
vnoremap <silent> il{ :<C-U>normal! F}vi{<cr>
onoremap <silent> il{ :<C-U>normal! F}vi{<cr>
vnoremap <silent> al{ :<C-U>normal! F}va{<cr>
onoremap <silent> al{ :<C-U>normal! F}va{<cr>
" }}}
" Next/Last [] {{{
vnoremap <silent> ind :<C-U>normal! f[vi[<cr>
onoremap <silent> ind :<C-U>normal! f[vi[<cr>
vnoremap <silent> and :<C-U>normal! f[va[<cr>
onoremap <silent> and :<C-U>normal! f[va[<cr>
vnoremap <silent> in[ :<C-U>normal! f[vi[<cr>
onoremap <silent> in[ :<C-U>normal! f[vi[<cr>
vnoremap <silent> an[ :<C-U>normal! f[va[<cr>
onoremap <silent> an[ :<C-U>normal! f[va[<cr>

vnoremap <silent> ild :<C-U>normal! F]vi[<cr>
onoremap <silent> ild :<C-U>normal! F]vi[<cr>
vnoremap <silent> ald :<C-U>normal! F]va[<cr>
onoremap <silent> ald :<C-U>normal! F]va[<cr>
vnoremap <silent> il[ :<C-U>normal! F]vi[<cr>
onoremap <silent> il[ :<C-U>normal! F]vi[<cr>
vnoremap <silent> al[ :<C-U>normal! F]va[<cr>
onoremap <silent> al[ :<C-U>normal! F]va[<cr>
" }}}
" Next/Last <> {{{
vnoremap <silent> in< :<C-U>normal! f<vi<<cr>
onoremap <silent> in< :<C-U>normal! f<vi<<cr>
vnoremap <silent> an< :<C-U>normal! f<va<<cr>
onoremap <silent> an< :<C-U>normal! f<va<<cr>

vnoremap <silent> il< :<C-U>normal! f>vi<<cr>
onoremap <silent> il< :<C-U>normal! f>vi<<cr>
vnoremap <silent> al< :<C-U>normal! f>va<<cr>
onoremap <silent> al< :<C-U>normal! f>va<<cr>
" }}}
" Next '' {{{
vnoremap <silent> in' :<C-U>normal! f'vi'<cr>
onoremap <silent> in' :<C-U>normal! f'vi'<cr>
vnoremap <silent> an' :<C-U>normal! f'va'<cr>
onoremap <silent> an' :<C-U>normal! f'va'<cr>

vnoremap <silent> il' :<C-U>normal! F'vi'<cr>
onoremap <silent> il' :<C-U>normal! F'vi'<cr>
vnoremap <silent> al' :<C-U>normal! F'va'<cr>
onoremap <silent> al' :<C-U>normal! F'va'<cr>
" }}}
" Next "" {{{
vnoremap <silent> in" :<C-U>normal! f"vi"<cr>
onoremap <silent> in" :<C-U>normal! f"vi"<cr>
vnoremap <silent> an" :<C-U>normal! f"va"<cr>
onoremap <silent> an" :<C-U>normal! f"va"<cr>

vnoremap <silent> il" :<C-U>normal! F"vi"<cr>
onoremap <silent> il" :<C-U>normal! F"vi"<cr>
vnoremap <silent> al" :<C-U>normal! F"va"<cr>
onoremap <silent> al" :<C-U>normal! F"va"<cr>
" }}}

" }}}
" Quickreturn ----------------------------------------------------------------- {{{

inoremap <c-cr> <esc>A<cr>
inoremap <s-cr> <esc>A:<cr>

" }}}
" Error toggles --------------------------------------------------------------- {{{

command! ErrorsToggle call ErrorsToggle()
function! ErrorsToggle() " {{{
  if exists("w:is_error_window")
    unlet w:is_error_window
    exec "q"
  else
    exec "Errors"
    lopen
    let w:is_error_window = 1
  endif
endfunction " }}}

command! -bang -nargs=? QFixToggle call QFixToggle(<bang>0)
function! QFixToggle(forced) " {{{
  if exists("g:qfix_win") && a:forced == 0
    cclose
    unlet g:qfix_win
  else
    copen 10
    let g:qfix_win = bufnr("$")
  endif
endfunction " }}}

nmap <silent> <f3> :ErrorsToggle<cr>
nmap <silent> <f4> :QFixToggle<cr>

" }}}
" Persistent echo ------------------------------------------------------------- {{{

" http://vim.wikia.com/wiki/Make_echo_seen_when_it_would_otherwise_disappear_and_go_unseen
"
" further improvement in restoration of the &updatetime. To make this
" usable in the plugins, we want it to be safe for the case when
" two plugins use same this same technique. Two independent
" restorations of &ut can run in unpredictable sequence. In order to
" make it safe, we add additional check in &ut restoration.
let s:Pecho=''
fu! s:Pecho(msg)
  let s:hold_ut=&ut | if &ut>1|let &ut=1|en
  let s:Pecho=a:msg
  aug Pecho
    au CursorHold * if s:Pecho!=''|echo s:Pecho
          \|let s:Pecho=''|if s:hold_ut > &ut |let &ut=s:hold_ut|en|en
          \|aug Pecho|exe 'au!'|aug END|aug! Pecho
  aug END
endf

" }}}
" Open quoted ----------------------------------------------------------------- {{{

nnoremap <silent> ø :OpenQuoted<cr>
command! OpenQuoted call OpenQuoted()

" Open the file in the current (or next) set of quotes.
function! OpenQuoted() " {{{
    let @r = ''

    exe 'normal! vi' . "'" . '"ry'

    if len(@r) == 0
        exe 'normal! i' . '"' . '"ry'
    endif

    if len(@r) == 0
        exe 'normal! "ry'
        let @r = ''
    endif

    exe "silent !open ." . @r
endfunction " }}}

" }}}
" MacVim ---------------------------------------------------------------------- {{{

if has('gui_running')
    set guifont=Anonymous\ Pro:h14   
    set guioptions-=T          	" remove the toolbar
    set lines=96               	" 40 lines of text instead of 24,
    set transparency=5          " Make the window slightly transparent

    " Remove all the UI cruft
    set go-=T
    set go-=l
    set go-=L
    set go-=r
    set go-=R

    " PeepOpen
    if has("gui_macvim")
        macmenu &File.New\ Tab key=<nop>
        map <leader><leader> <Plug>PeepOpen
    end

    highlight SpellBad term=underline gui=undercurl guisp=Orange

    " Use a line-drawing char for pretty vertical splits.
    set fillchars=vert:│

    " Different cursors for different modes.
    set guicursor=n-c:block-Cursor-blinkon0
    set guicursor+=v:block-vCursor-blinkon0
    set guicursor+=i-ci:ver20-iCursor

    " Use the normal HIG movements, except for M-Up/Down
    let macvim_skip_cmd_opt_movement = 1
    no   <D-Left>       <Home>
    no!  <D-Left>       <Home>
    no   <M-Left>       <C-Left>
    no!  <M-Left>       <C-Left>

    no   <D-Right>      <End>
    no!  <D-Right>      <End>
    no   <M-Right>      <C-Right>
    no!  <M-Right>      <C-Right>

    no   <D-Up>         <C-Home>
    ino  <D-Up>         <C-Home>
    imap <M-Up>         <C-o>{

    no   <D-Down>       <C-End>
    ino  <D-Down>       <C-End>
    imap <M-Down>       <C-o>}

    imap <M-BS>         <C-w>
    inoremap <D-BS>     <esc>my0c`y
else
  set term=builtin_ansi       " Make arrow and other keys work
endif

" }}}
