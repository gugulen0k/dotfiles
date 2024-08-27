ZSH_THEME="gugulenok-base16-default-dark"

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
  git
  bundler
  ruby
  rake
  web-search          # Adds aliases for searching with Google, Wiki, Bing, YouTube and other popular services
  copypath            # Copies the path of given directory or file to the system clipboard.
  colored-man-pages
  colorize
  zsh-autosuggestions
)

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

export EDITOR='nvim'
export THOR_MERGE='nvim -d'

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Different aliases
alias c="clear"

# Docker aliases
alias dup="docker compose up"
alias ddown="docker compose down"
alias dexec="docker exec -it"
alias dbuild="docker compose build"
alias drun="docker compose run"
alias dps="docker compose ps"

# Git aliases
alias gaa="git add ."
alias gs="git status"

# Configuration files aliases
alias nvimrc="nvim ~/.config/nvim"
alias zshrc="nvim ~/.zshrc"
alias tmuxrc="nvim ~/.tmux.conf"
alias alacrittyrc="nvim ~/.config/alacritty"
alias kittyrc="nvim ~/.config/kitty"
alias dots="nvim ~/Documents/DotFiles"
alias awesomerc="nvim ~/.config/awesome/rc.lua"

source $ZSH/oh-my-zsh.sh
source $HOME/.cargo/env

source <(fzf --zsh)
