#!/bin/bash
echo 'Start Installing Vim, it will takes about 5 hours! Please wait...'
sleep 10
yum install gcc gcc-c++ -y
yum install wget curl cmake git python-devel -y
yum install vim -y
vimrc="/root/vimtest"
vimdir="/root/vimtestd"
if [ -f "$vimrc" ];then
mv $vimrc ${vimrc}.bak 
fi
if [ -d "$vimdir" ];then
mv $vimdir ${vimdir}.bak
fi

touch $vimrc
mkdir $vimdir
cat >> $vimrc <<EOF
set nocompatible
syntax on
filetype off
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'gmarik/Vundle.vim'
Plugin 'a.vim'
Plugin 'The-NERD-tree'
Plugin 'scrooloose/syntastic'
Plugin 'Valloric/YouCompleteMe'
call vundle#end()
filetype plugin indent on

set number
set cursorline
hi CursorColumn cterm=NONE ctermbg=darkred ctermfg=white
hi CursorLine cterm=NONE ctermbg=darkred ctermfg=white
set showmatch
set ruler
set hlsearch
set autoindent
set smartindent
set cindent
set incsearch
set ignorecase
set history=500
set undolevels=100
set shiftwidth=4
set tabstop=4
set laststatus=2
set softtabstop=4
set statusline=%F%m%r%h%w\ [FORMAT=%{&ff}]\ [TYPE=%Y]\ [POS=%l,%v][%p%%]\ %{strftime(\"%d/%m/%y\ -\ %H:%M\")}
set foldenable 
set foldmethod=manual
set autowrite
set iskeyword+=_,$,@,%,#,-
set whichwrap+=<,>,h,l
imap () ()<Left>
imap [] []<Left>
imap {} {}<Left>
imap "" ""<Left>
imap '' ''<Left>
"NERD tree
map <C-n> :NERDTreeToggle<CR>
imap <C-n> <ESC> :NERDTreeToggle<CR>
EOF
git clone https://github.com/gmarik/Vundle.vim.git $vimdir/bundle/Vundle.vim
vim +PluginInstall +qall
cd ${vimdir}/bundle/YouCompleteMe
./install.sh --clang-completer
echo "Over"
