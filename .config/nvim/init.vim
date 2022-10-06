source ~/.config/nvim/plugins.vim
luafile ~/.config/nvim/lsp-config.lua
luafile ~/.config/nvim/compe-config.lua

" There are certain files that we would never want to edit with Vim.
" Wildmenu will ignore files with these extensions.
set wildmode=list:longest " Make wildmenu behave like similar to Bash completion.
set wildignore=*.docx,*.jpg,*.png,*.gif,*.pdf,*.pyc,*.exe,*.flv,*.img,*.xlsx 

" Setting custom theme for vim
" true colors are required for vim in terminal
set termguicolors
colorscheme dracula

set mouse=a 		    " Allow to use the mouse in the editor
set number 		      " Shows the line numbers
set title 		      " Show file title
set ttyfast  		    " Speed up scrolling in Vim 
set cursorline	  	" Highlights the current line in the editor
set spell		        " Enable spell check
set relativenumber  
set tabstop=2
set shiftwidth=2
set expandtab
set ignorecase
set smartcase
set nowrap
set noswapfile
set showmatch
set incsearch
set hlsearch
set termguicolors
set clipboard=unnamedplus
set encoding=utf8

filetype plugin indent on " Allow auto-indenting depending on file type
syntax on

let mapleader = " "
set tags+=.git/tags,.git/rubytags
set tagcase=match
noremap ,gt :!gentags<CR>

" Setting ripgrep for vim
set grepprg=rg\ --vimgrep\ --no-heading\ --smart-case
set grepformat=%f:%l:%c:%m,%f:%l:%m

nnoremap <F5> :NERDTreeToggle<CR>
nnoremap <C-p> :Files<CR>
nnoremap <silent> \ :ArgWrap<CR>
nnoremap <leader>f :Rg<CR>
nnoremap <leader>b :Buffers<CR>
nnoremap <leader>d :BTags<CR>
nnoremap <leader><leader> :e #<CR>
nnoremap '%%', expand('%:h').'/'
nnoremap <leader>c :CopyPath<CR>
nnoremap <C-m> :CodeActionMenu<CR>

