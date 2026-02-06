# Enable Powerlevel10k instant prompt
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# opam init (if exists)
[[ ! -r ~/.opam/opam-init/init.zsh ]] || source ~/.opam/opam-init/init.zsh > /dev/null 2> /dev/null

# Conda init (if exists on macOS)
if [ -f "/opt/miniconda3/etc/profile.d/conda.sh" ]; then
  . "/opt/miniconda3/etc/profile.d/conda.sh"
fi

# Bun
if [ -d "$HOME/.bun" ]; then
  export BUN_INSTALL="$HOME/.bun"
  export PATH="$BUN_INSTALL/bin:$PATH"
  [ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"
fi

# pnpm
if [ -d "$HOME/Library/pnpm" ]; then
  export PNPM_HOME="$HOME/Library/pnpm"
  export PATH="$PNPM_HOME:$PATH"
fi

# Homebrew paths (macOS)
if [ -d "/opt/homebrew" ]; then
  export PATH="/opt/homebrew/opt/openjdk/bin:$PATH"
  export PATH="/opt/homebrew/opt/postgresql@17/bin:$PATH"
  export PATH="/opt/homebrew/Cellar/openvpn/2.6.10/sbin:$PATH"
  export OPENSSL_ROOT_DIR="/opt/homebrew/opt/openssl@3"

  # Terraform completion
  if command -v terraform &> /dev/null; then
    autoload -U +X bashcompinit && bashcompinit
    complete -o nospace -C /opt/homebrew/bin/terraform terraform
  fi
fi

# Spicetify
[ -d "$HOME/.spicetify" ] && export PATH="$HOME/.spicetify:$PATH"

# opencode
[ -d "$HOME/.opencode/bin" ] && export PATH="$HOME/.opencode/bin:$PATH"

# Google Cloud SDK
[ -f "$HOME/Downloads/google-cloud-sdk/path.zsh.inc" ] && source "$HOME/Downloads/google-cloud-sdk/path.zsh.inc"
[ -f "$HOME/Downloads/google-cloud-sdk/completion.zsh.inc" ] && source "$HOME/Downloads/google-cloud-sdk/completion.zsh.inc"

# Additional PATH entries
export PATH="$HOME/.local/scripts:$PATH"
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"

# Terminal
export TERM=xterm-256color

# Load Powerlevel10k config
[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh

# zsh-autocomplete (Homebrew - matches old working config)
if [ -f "/opt/homebrew/share/zsh-autocomplete/zsh-autocomplete.plugin.zsh" ]; then
  source /opt/homebrew/share/zsh-autocomplete/zsh-autocomplete.plugin.zsh
fi

# Sessionizer keybind (Ctrl+F) - after p10k loads
bindkey -s '^f' 'tmux-sessionizer\n'
