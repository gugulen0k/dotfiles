# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

export EDITOR='nvim'
export THOR_MERGE='nvim -d'

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
  tmux
  zsh-autosuggestions
)

bindkey '^ ' autosuggest-accept

# Open tmux on startup, requires tmux plugin
ZSH_TMUX_AUTOSTART=true
ZSH_THEME="gugulenok-light-rose-pine"

# Different aliases
alias c="clear"
alias mux="tmuxinator"

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

source $ZSH/oh-my-zsh.sh
source $HOME/.cargo/env

if command -v tmux &> /dev/null && [ -z "$TMUX" ]; then
        tmux attach -t default || tmux new -s default
fi

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

eval "$(rbenv init - zsh)"

