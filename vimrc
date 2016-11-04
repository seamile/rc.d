if has("syntax")
  syntax on
endif

" Uncomment the following to have Vim jump to the last position when
" reopening a file
if has("autocmd")
  au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif

" Uncomment the following to have Vim load indentation rules and plugins
" according to the detected filetype.
if has("autocmd")
  filetype plugin indent on
endif

" The following are commented out as they cause vim to behave a lot
" differently from regular Vi. They are highly recommended though.
set showcmd         " Show (partial) command in status line.
set showmatch       " Show matching brackets.
set ignorecase      " Do case insensitive matching
set smartcase       " Do smart case matching
set incsearch       " Incremental search

" Source a global configuration file if available
if filereadable("/etc/vim/vimrc.local")
  source /etc/vim/vimrc.local
endif

"自定义
color desert
set background=dark     "背景色
set nu
set hlsearch
set nocompatible        "非兼容模式
set ruler               "在左下角显示当前文件所在行
set report=0            "显示修改次数
set nobackup            "无备份
set cursorline          "高亮当前行背景
set fileencodings=ucs-bom,UTF-8,GBK,BIG5,latin1
set fileencoding=UTF-8
set fileformat=unix     "换行使用unix方式
set ambiwidth=double
set noerrorbells        "不显示响铃
set visualbell          "可视化铃声
set foldmarker={,}      "缩进符号
set foldmethod=indent   "缩进作为折叠标识
set foldlevel=100       "不自动折叠
set foldopen-=search    "搜索时不打开折叠
set foldopen-=undo      "撤销时不打开折叠
set updatecount=0       "不使用交换文件
set magic               "使用正则时，除了$ . * ^以外的元字符都要加反斜线
"缩进定义
set shiftwidth=4
set tabstop=4
set softtabstop=4
set expandtab
set smarttab
set backspace=2     "退格键可以删除任何东西

auto BufWritePre * sil %s/\s\+$//ge "保存时删除行尾空白
"映射常用操作
map [r :! python % <CR>
map [o :! python -i % <CR>
map <C-j> :He<CR>
map <C-l> :Ve!<CR>
