#!/bin/bash
echo 'Start Installing Vim, it will takes about 2 hours! Please wait...'
sleep 3
yum install gcc gcc-c++ -y
yum install wget curl git python-devel -y
yum install vim -y
wget http://www.cmake.org/files/v3.2/cmake-3.2.2.tar.gz
tar zxvf cmake-3.2.2.tar.gz
cd cmake-3.2.2
./bootstrap
gmake && gmake install
cd ..
rm -rf cmake-3.2.2
rm -rf cmake-3.2.2.tar.gz
vimrc="/root/.vimrc"
vimdir="/root/.vim"
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
let NERDTreeWinSize=20
"YouCompleteMe
let g:ycm_global_ycm_extra_conf="~/.vim/bundle/YouCompleteMe/third_party/ycmd/cpp/ycm/.ycm_extra_conf.py"
let g:ycm_collect_identifiers_from_tags_files=1
let g:ycm_seed_identifiers_with_syntax=1
let g:ycm_confirm_extra_conf=0
let g:ycm_min_num_of_chars_for_completion=2
nnoremap <C-g> :YcmCompleter GoToDefinitionElseDeclaration<CR>
EOF
git clone https://github.com/gmarik/Vundle.vim.git $vimdir/bundle/Vundle.vim
vim +PluginInstall +qall
cd ${vimdir}/bundle/YouCompleteMe
./install.sh --clang-completer
echo "Over"
echo "Tips: if you want to use the c++ sdt lib,you must modify the .ycm_confirm_extra_conf file."
echo "file path:/root/.vim/bundle/YouCompleteMe/third_party/ycmd/cpp/ycm/.ycm_extra_conf.py"
echo "comment the following scentences,add # before each line."
echo "try:"
echo "	final_flags.remove( '-stdlib=libc++' )"
echo "except ValueError:"
echo "  pass"

