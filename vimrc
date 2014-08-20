" VIM runs in non-vi-compatible mode
set nocompatible

" Enable syntax highlighting
syntax on

" Autodetect file type, enable auto-indenting, enable filetype plugin loading
filetype indent plugin on

" automatically open and close the popup menu / preview window
au CursorMovedI,InsertLeave * if pumvisible() == 0|silent! pclose|endif
set completeopt=menuone,menu,longest,preview

" Shell to use
set shell=/bin/bash

" Set Status line to "BufferNo FilePath [help]|[modified]|[RO]|[Preview][filetype,encoding,format]        0xBYTEVAL  (line,col-vcol) FilePercentage"
set statusline=%-3.3n\ %f\ %h%m%r%w[%{strlen(&filetype)?&filetype:'?'},%{&encoding},%{&fileformat}]%=\ 0x%-8B\ \ %-14.(%l,%c%V%)\ %<%P

" Show line/col/percentage if statusline is unset
set ruler

" Set delete and backspace keys.
if &term == "xterm"
    set t_kb=
    fixdel
endif

" Show a funky little arrow for tab characters
if !has("gui_running") && version >= 700
    set list
    set listchars=tab:>-
endif

" Desert is a nice colorscheme
colorscheme desert

" Highlight extra whitespace after the end of a line
if has("autocmd") && version >= 700
    autocmd ColorScheme * highlight ExtraWhitespace ctermbg=red guibg=red
endif
highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$/

" When searching, show the next match as you type
set incsearch

" Case-insensitive searching
set ignorecase

" If upper-case characters are present in search string, use case-sensitive searching
set smartcase

" Highlight search matches
set hlsearch

" Does the last window have a status line?  2=always
set laststatus=2

" Splitting will put the new window below the old
set splitbelow

" Do not create ~filename backups
set nobackup

" Store backups in $HOME/.vim/backup - clearcase is slow, store outside of clearcase
set backupdir=$HOME/.vim/backup//

" Store tmpfiles in $HOME/.vim/temp - clearcase is slow, store outside of clearcase
set directory=$HOME/.vim/temp//

" Allow these navigation keys to wrap to the prev/next line
set whichwrap=h,l,<,>,[,]

" Allow backspacing over: autoindent, line breaks, start of insert
set backspace=indent,eol,start

" Default tabulation settings: tab is 8 chars wide, indent level is 4 spaces,
" expand tabs to spaces
set tabstop=8 shiftwidth=4 softtabstop=4 expandtab

" Make lines wrap after 80 characters
set textwidth=80

" Allow lines to run off the end of the screen
set nowrap

" Remember 500 commands of history
set history=500

" C indenting options:
" g0 = place C++ scope declarations at indent level of their containing block
" :0 = place case labels equal to indent level of switch() statement
" l1 = align contents of case labels with the case label itself
" (0 = align parenthesis across multiple lines
" t0 = indent function return type at the margin
set cinoptions=g0,:0,l1,(0,t0

" Do not automatically fold lines that are already longer than textwidth
set formatoptions+=l

" When in visual or select mode, allow cursor to be positioned one character
" past the line, and include last character in selection
set selection=inclusive

" Enable folding, fold on indent level, default to unfolded
if has("folding")
    set foldenable
    set foldmethod=indent
    set foldlevel=99
endif

" Display abbreviations for most messages
set shortmess=a

" Tab invokes command-line completion
set wildchar=<tab>

" Show a list of possible completions above the command line
set wildmenu

" Complete until longest common string
set wildmode=longest:full,full

" Remove toolbar from graphical VIM 
set guioptions-=T

" Preview window has default height 5
set previewheight=5

" Use F5 key to enable paste mode
set pastetoggle=<f5>

" Use UTF-8 encoding for text
set encoding=utf-8

if has("autocmd")
    "Set status lines for quickfix and help windows
    au FileType qf if &buftype == "quickfix" |
                   \    setlocal statusline=%-3.3n\ %0*[quickfix]%=%2*\ %<%P |
                   \endif
    au FileType help setlocal statusline=%-3.3n\ [help]%=\ %<%P

    "Ensure sv unit tests are treated as cpp files for syntax highlighting
    au BufNewFile,BufRead t_*.test set filetype=cpp

    "Ensure .m/.mk files are Makefile
    au BufNewFile,BufRead *.m set filetype=make
    au BufNewFile,BufRead *.mk set filetype=make

    "Ensure .pdb files are treated as cpp files for syntax highlighting
    au BufNewFile,BufRead *.pdb set filetype=cpp

    "Ensure .rvt files are treated as tcl files for syntax highlighting
    au BufNewFile,BufRead *.rvt set filetype=tcl

    "Proper indentation for makefiles
    au FileType make setlocal tabstop=8 softtabstop=8 shiftwidth=8 noexpandtab

endif

" Normal Mode bindings for switching windows
noremap <c-h> <c-w><c-h>
noremap <c-j> <c-w><c-j>
noremap <c-k> <c-w><c-k>
noremap <c-l> <c-w><c-l>

" Insert Mode bindings for switching windows
inoremap <c-h> <c-o><c-w><c-h>
inoremap <c-j> <c-o><c-w><c-j>
inoremap <c-k> <c-o><c-w><c-k>
inoremap <c-l> <c-o><c-w><c-l>

" Build errorformat
set errorformat=
      \%D\ Entering\ directory\ `%f',
      \%Dmake:\ Entering\ directory\ `%f',
      \%X\ Leaving\ directory\ `%f',
      \%f:%l:%c:\ %m,
      \%f:%l:\ %m,
      \Reading\ makefile\ `%f'\ %m,
      \%*[^\"]\"%f\"%*\\D%l:\ %m,
      \\"%f\"%*\\D%l:\ %m,
      \%-G%f:%l:\ %trror:\ (Each\ undeclared\ identifier\ is\ reported\ only\ once,
      \%-G%f:%l:\ %trror:\ for\ each\ function\ it\ appears\ in.),
      \%f:%l:\ %m,
      \\"%f\"\\,\ line\ %l%*\\D%c%*[^\ ]\ %m,
      \%D%*\\a[%*\\d]:\ Entering\ directory\ `%f',
      \%X%*\\a[%*\\d]:\ Leaving\ directory\ `%f',
      \%D%*\\a:\ Entering\ directory\ `%f',
      \%X%*\\a:\ Leaving\ directory\ `%f',
      \%DMaking\ %*\\a\ in\ %f,
      \%m\ at\ %f:%l

" Configuration for CSCOPE plugin
" Automatically close the quickfix window after jumping to match
let Cscope_AutoClose = 1

" Don't automatically jump to the first match
let Cscope_JumpError = 0

" Function that creates an include guard for me, according to nkaun
function! IncludeGuard()
    let gatename = substitute(toupper(expand("%:t")), "\\.", "_", "g")

    set paste

    execute "normal! 1G"
    execute "normal! O#ifndef " . gatename
    execute "normal! o#define " . gatename
    execute "normal! Go#endif //" . gatename
    execute "normal! Go"

    set nopaste
endfunction

command! -nargs=0 IG :call IncludeGuard()

" Generate an initial testcase stub
function! GenerateTestcase()
    let testname = substitute(expand("%:t"), "\\.test$", "", "g")
    let testname = substitute(testname, "^t_", "", "g")

    set paste

    execute "normal! 1Gi#include <cxxtest/TestSuite.h>"
    execute "normal! o"
    execute "normal! oclass " . testname . "Test : public CxxTest::TestSuite"
    execute "normal! o{"
    execute "normal! opublic:"
    execute "normal! o    void setUp();"
    execute "normal! o    void tearDown();"
    execute "normal! o"
    execute "normal! o    void TestXXX();"
    execute "normal! o};"
    execute "normal! o"

    set nopaste
endfunction

command! -nargs=0 GT :call GenerateTestcase()
