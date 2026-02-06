# Navigation
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

# eza aliases
alias ls='eza --icons'
alias ll='eza -l --icons'
alias la='eza -la --icons'
alias lt='eza --tree --icons'
alias l='eza -l --icons'

# Git
alias g='git'
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gl='git pull'
alias gd='git diff'
alias gco='git checkout'
alias gb='git branch'
alias glog='git log --oneline --graph'

# Docker
alias d='docker'
alias dc='docker compose'
alias dps='docker ps'

# Misc
alias cat='bat'
alias vim='nvim'
alias vi='nvim'
alias c='clear'
alias tree='eza --tree --icons'

# NixOS
alias nrs='sudo nixos-rebuild switch --flake ~/nixos-config#workstation'
alias nrt='sudo nixos-rebuild test --flake ~/nixos-config#workstation'
alias nfu='nix flake update'

# Home Manager (macOS)
alias hms='home-manager switch --flake ~/nixos-config#rxue@macbook'

# CTF/Security tools (macOS paths)
alias potfile='cat /opt/homebrew/Cellar/hashcat/6.2.6_1/share/hashcat/hashcat.potfile'
alias stegsolve='cd ~/Documents/stegsolve-macos/ && java -jar stegsolve.jar'
alias unshadow='/opt/homebrew/Cellar/john-jumbo/1.9.0_1/share/john/unshadow'
alias zip2john='/opt/homebrew/Cellar/john-jumbo/1.9.0_1/share/john/zip2john'
alias rar2john='/opt/homebrew/Cellar/john-jumbo/1.9.0_1/share/john/rar2john'
alias ssh2john='/opt/homebrew/Cellar/john-jumbo/1.9.0_1/share/john/ssh2john.py'

# Project-specific
alias auv='~/cuauv/workspaces/repo/docker/auv-docker.py'
alias rv='docker run -i --init -e NETID=rx77 --rm -v "$PWD":/root ghcr.io/sampsyo/cs3410-infra'

# Config shortcuts
alias nvimconfig='code ~/.config/nvim/'
