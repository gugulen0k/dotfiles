# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="gugulenok-dark"

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
)

source $ZSH/oh-my-zsh.sh

# Open tmux on startup, requires tmux plugin
ZSH_TMUX_AUTOSTART=true

# Different aliases
alias c="clear"

# Git aliases
alias gaa="git add ."
alias gcm="git commit -m"
alias gs="git status"
alias gp="git push" 

# Configuration files aliases
alias nvimrc="nvim ~/.config/nvim/init.lua"
alias zshrc="nvim ~/.zshrc"
alias tmuxrc="nvim ~/.tmux.conf"
alias alacrittyrc="nvim ~/.config/alacritty/alacritty.yml"

if command -v tmux &> /dev/null && [ -z "$TMUX" ]; then
        tmux attach -t default || tmux new -s default
fi

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

eval "$(rbenv init - zsh)"
