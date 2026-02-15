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

# CTF/Security tools
# John utilities: use PATH version (Nix), fallback to Homebrew (version-independent)
_john_brew="/opt/homebrew/opt/john-jumbo/share/john"
if ! command -v unshadow &>/dev/null && [ -f "$_john_brew/unshadow" ]; then alias unshadow="$_john_brew/unshadow"; fi
if ! command -v zip2john &>/dev/null && [ -f "$_john_brew/zip2john" ]; then alias zip2john="$_john_brew/zip2john"; fi
if ! command -v rar2john &>/dev/null && [ -f "$_john_brew/rar2john" ]; then alias rar2john="$_john_brew/rar2john"; fi
if ! command -v ssh2john &>/dev/null && [ -f "$_john_brew/ssh2john.py" ]; then alias ssh2john="$_john_brew/ssh2john.py"; fi
unset _john_brew
[ -d /opt/homebrew/opt/hashcat ] && alias potfile='cat /opt/homebrew/opt/hashcat/share/hashcat/hashcat.potfile'
[ -d ~/Documents/stegsolve-macos ] && alias stegsolve='cd ~/Documents/stegsolve-macos/ && java -jar stegsolve.jar'

# Project-specific (only defined if paths exist)
[ -f ~/cuauv/workspaces/repo/docker/auv-docker.py ] && alias auv='~/cuauv/workspaces/repo/docker/auv-docker.py'

# Config shortcuts
alias nvimconfig='$EDITOR ~/.config/nvim/'
