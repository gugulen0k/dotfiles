# If you come from bash you might have to change your $PATH.
export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to homebrew
export PATH=$HOME/homebrew/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Path for ruby version so autocomplete could work
# export PATH="/Users/chirilterzi/homebrew/opt/ruby/bin:$PATH"
PATH=$PATH:$HOME/.rvm/gems/ruby-3.0.0/bin

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="gugulenok-dark"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

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

alias c="clear"
alias gaa="git add ."
alias gcm="git commit -m"
alias gs="git status"
alias gp="git push" 
alias rc="rails console"
alias rs="rails server"
alias nvimrc="nvim ~/.config/nvim/init.vim"
alias zshrc="nvim ~/.zshrc"
alias tmuxrc="nvim ~/.tmux.conf"
alias ctags="`brew --prefix`/bin/ctags"

if command -v tmux &> /dev/null && [ -z "$TMUX" ]; then
        tmux attach -t default || tmux new -s default
fi

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
[[ -s "$HOME/.rvm/scripts/rvm" ]] && . "$HOME/.rvm/scripts/rvm" 

