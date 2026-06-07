# Path to your oh-my-zsh installation
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load (Default robust theme)
ZSH_THEME="robbyrussell"

# Standard Oh My Zsh plugins list (git and sudo are built-in)
# Pressing ESC twice automatically prepends 'sudo' to the current command
plugins=(
    git 
    sudo 
    zsh-autosuggestions
    zsh-syntax-highlighting
)

source "$ZSH/oh-my-zsh.sh"

# --- Modern CLI Tool Aliases -------------------------------------------------
# Map standard coreutils commands to the modern alternatives installed in your base layer
if command -v eza &>/dev/null; then
    alias ls="eza --icons --group-directories-first"
    alias ll="eza -la --icons --group-directories-first"
fi

if command -v bat &>/dev/null; then
    alias cat="bat --style=plain"
fi

if command -v fd &>/dev/null; then
    alias find="fd"
fi

if command -v rg &>/dev/null; then
    alias grep="rg"
fi

# Handy alias to refresh current shell configurations instantly
alias src="source ~/.zshrc"
