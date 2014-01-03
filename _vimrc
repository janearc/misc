" jane avriette's vimrc. i've been carrying this around since 2000 or so.
" i honestly don't remember all the places i ganked shit from.
"
" Jan 2014



" jane is a perl tab fascist
set ts=2 sts=2 noet
set autoindent nocindent

" line nos
set number

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

" like :wq except write and suspend
command Wst w <bar> st
cabbrev wst Wst 
cabbrev Wq wq

" i tag my files with my name, you should too
ab mystamp # jane@cpan.org // vim:tw=80:ts=2:noet

" lay out my files
set backup
set backupdir=~/.vim/backup
set directory=~/.vim/tmp

" typos 
cabbrev zsg zsh
cabbrev bim vim

" i have more spelling typos in a specific file (english, vs code)
" source! "~/.vim/spelling.vim"
