set ts=2 sts=2 noet
set autoindent nocindent

" line nos
set number

" unix
set fileformat=unix

" show me where my cursor is
set cursorline nocursorcolumn ruler

" give me more room
set cmdheight=2

" define comments
set comments=b:#,b:\",n:>

" this is distracting
set nohlsearch

" dont be stupid when searching
set ignorecase

" this puts our search term in the middle of the screen
nmap n nmzz.`z
nmap N Nmzz.`z
nmap * *mzz.`z
nmap # #mzz.`z
nmap g* g*mzz.`z
nmap g# g#mzz.`z

" honestly i dont know what this does
set magic

" syntax & color scheme
syntax on
colo koehler

" that stupid backspace bell thing
set backspace=indent,eol,start

" less-lame wrap behavior
set whichwrap+=<,>,h,l

" utf-8 plox
set encoding=utf-8 fileencodings=

" limit text files to 78 chars
autocmd BufRead *.txt set textwidth=78

" this shows me my indentation, you may not like this
set list
set listchars=tab:\|\ ,trail:. "

" this sets views to automatically be made when i leave an edit and to
" load it if it's available - this preserves folds
au BufWinLeave * mkview
au BufWinEnter * silent loadview
set foldenable
set foldmethod=marker
set foldmarker={{{,}}}

" my perl typos
cabbrev Prel perl
cabbrev prel perl
cabbrev Perl perl
cabbrev pelr perl
cabbrev peerl perl
ab prnt print
ab wran warn
ab prnit print

" perl macros i use
ab ubp #!/usr/bin/perl
ab u518 use v5.18;
ab uws use warnings;use strict;

" js fail
ab vst var
ab reutnr return

" stupid yurope
ab £ #

" pipe the selected text to gist
cabbrev gist ,w !gist

" like :wq except write and suspend
command Wst w <bar> st
cabbrev wst Wst
cabbrev wt st
cabbrev Wq wq

" i tag my files with my name, you should too
ab mystamp // @janearc 🐙👾 // jane@cpan.org // vim:tw=80:ts=2:noet
ab sstamp // 🐙👾  vim:tw=80:ts=2:noet

" lay out my files - you will want to `mkdir -p ~/.vim/{backup,tmp}`
set backup
set backupdir=~/.vim/backup
set directory=~/.vim/tmp

" typos
cabbrev zsg zsh
cabbrev bim vim
cabbrev pate paste

" user paradigm on freenode suggested this from the help:
map <F10> :set paste<CR>
map <F11> :set nopaste<CR>
imap <F10> <C-O>:set paste<CR>
imap <F11> <nop>
set pastetoggle=<F11>

" @18f's @cm suggested to fix markdown wrapping when i am listing:
au FileType mkd set tw=0


" dem pathogenz
set shell=bash
call pathogen#infect()
call pathogen#helptags()
filetype plugin indent on
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
"autocmd BufWritePre * :%s/\s\+$//e
set viminfo='100,\"2500,:200,%,n~/.viminfo

" go syntax, requires syntastic and pathogen
let g:go_fmt_command = "goimports"
let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_structs = 1
let g:go_highlight_operators = 1
let g:go_highlight_build_constraints = 1
let g:syntastic_go_checkers = ['go', 'golint', 'errcheck']
au Filetype go nnoremap <leader>v :vsp <CR>:exe "GoDef" <CR>
au Filetype go nnoremap <leader>s :sp <CR>:exe "GoDef"<CR>
au Filetype go nnoremap <leader>t :tab split <CR>:exe "GoDef"<CR>

" lightline
set laststatus=2

" Tabular from joshua corbin
nnoremap <leader>tt :Tab<cr>
nnoremap <leader>t= :Tab/=/<cr>
nnoremap <leader>t, :Tab/,/<cr>
nnoremap <leader>t: :Tab/:/<cr>

" there's a thrift syntax file here: https://raw.githubusercontent.com/apache/thrift/master/contrib/thrift.vim
