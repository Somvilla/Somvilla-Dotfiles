#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'
PS1='[\u@\h \W]\$ '
export LANG=en_GB.UTF-8
export LC_ALL=en_GB.UTF-8
eval "$(starship init bash)"
export PATH=~/.npm-global/bin:$PATH
export PATH="$HOME/dotfiles/scripts:$PATH"
export PATH="$HOME/flutter/bin:$PATH"
export CHROME_EXECUTABLE=chromium

# opencode
export PATH=/home/gary/.opencode/bin:$PATH

# History
HISTTIMEFORMAT="%F %T "
HISTCONTROL=ignoredups

# Reload bashrc quickly
alias reload='source ~/.bashrc'

# NPM project helpers
alias npmi='npm install'
alias nrd='npm run dev'
alias nrb='npm run build'
alias nrt='npm run test'

# Git shortcuts
alias gi='git init'
alias gs='git status'
alias ga='git add .'
alias gc='git commit -m'
alias gcf='git commit -m "Initial commit"'
alias gp='git push'
alias gl='git log --oneline --graph --decorate --all'

# OpenCode helpers
alias ai="opencode"
alias op="opencode --project $(basename $PWD)"
# IP, network info
alias myip='ip -br a'
alias ports='sudo lsof -i -P -n | grep LISTEN'
alias pingg='ping 1.1.1.1'

# Docker helpers
alias dps='docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"'
alias dcu='docker-compose up -d'
alias dcd='docker-compose down'
alias dexec='docker exec -it'

# Safer file operations
alias cp='cp -iv'
alias mv='mv -iv'
alias rm='rm -iv'

# Common typos
alias cls='clear'
alias ..='cd ..'
alias ...='cd ../..'
