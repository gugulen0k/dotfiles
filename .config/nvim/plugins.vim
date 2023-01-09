call plug#begin()
  " Plug 'dracula/vim', { 'as': 'dracula' } " Dracula theme
  Plug 'nocksock/bloop-vim'
  Plug 'christoomey/vim-tmux-navigator'   " Extension for easier navigation between tmux and vim
  Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
  Plug 'junegunn/fzf.vim'
  Plug 'BurntSushi/ripgrep'
  Plug 'airblade/vim-gitgutter'
  Plug 'preservim/nerdtree'     " Shows directories & files
  Plug 'ryanoasis/vim-devicons' " Icons for NerdTree

  " Autocompletion plugins
  Plug 'weilbith/nvim-code-action-menu'
  Plug 'neovim/nvim-lspconfig'
  Plug 'hrsh7th/nvim-compe'
  Plug 'hrsh7th/vim-vsnip'
  Plug 'nvim-treesitter/nvim-treesitter'

  " Languages support
  Plug 'vim-ruby/vim-ruby'
  Plug 'kchmck/vim-coffee-script'
  Plug 'iamcco/markdown-preview.nvim'
  Plug 'tpope/vim-rails'
  Plug 'tpope/vim-haml'

  Plug 'tpope/vim-commentary'
  Plug 'tpope/vim-surround'
  Plug 'tpope/vim-fugitive'
  Plug 'tpope/vim-endwise'
  Plug 'tpope/vim-repeat'
call plug#end()
