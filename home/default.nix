{ config, pkgs, lib, inputs, isNixOS, userConfig, ... }:

let
  isLinux = pkgs.stdenv.isLinux;
  isDarwin = pkgs.stdenv.isDarwin;
in
{
  imports = [
    inputs.catppuccin.homeModules.catppuccin

    ./kitty.nix
    ./neovim.nix
    ./git.nix
    ./zsh.nix
  ] ++ lib.optionals isNixOS [
    # NixOS-only modules (these inputs aren't available on macOS)
    inputs.spicetify-nix.homeManagerModules.default
    inputs.dms.homeManagerModules.default
    ./dms.nix
    ./spicetify.nix
    ./zathura.nix
    ./gaming.nix
  ];

  home.username = userConfig.username;
  home.homeDirectory = if isDarwin then "/Users/${userConfig.username}" else "/home/${userConfig.username}";
  home.stateVersion = "24.11";

  # Common CLI packages (installed system-wide on NixOS, via HM on macOS)
  home.packages = with pkgs; [
    # Shell utilities
    eza
    bat
    ripgrep
    fd
    jq
    yq
    tree

    # System monitoring
    htop

    # Network utilities
    wget
    curl
    httpie

    # Build tools
    cmake
    gnumake
    pkg-config

    # Archive tools
    unzip
    zip
    p7zip

    # Container tools
    docker-compose
    lazydocker
    lazygit

    # Cloud
    awscli2
    google-cloud-sdk

    # Misc
    file
    watch
  ] ++ lib.optionals isDarwin [
    # macOS-specific (Linux has these system-wide)
    coreutils
    findutils
    gnugrep
    gnused

    # Languages (on NixOS these are system-wide)
    python3
    uv
    nodejs
    bun
    go
    lua
    luarocks
    zig

    # LSPs and formatters for neovim
    nodePackages.typescript-language-server
    nodePackages.vscode-langservers-extracted
    lua-language-server
    nil  # Nix LSP
    nixpkgs-fmt
    pyright
    ruff
    gopls
  ];

  # Environment variables
  home.sessionVariables = {
    GOPATH = "$HOME/go";
    CARGO_HOME = "$HOME/.cargo";
    RUSTUP_HOME = "$HOME/.rustup";
    EDITOR = "nvim";
  };

  # Let Home Manager manage itself
  programs.home-manager.enable = true;

  # Nix garbage collection (macOS only — NixOS handles it system-wide)
  nix.gc = lib.mkIf isDarwin {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 14d";
  };

  # Catppuccin theme (Macchiato flavor)
  catppuccin = {
    enable = true;
    flavor = "macchiato";
    accent = "mauve";
  };

  # Readline (arrow key history search)
  programs.readline = {
    enable = true;
    extraConfig = ''
      $include /etc/inputrc
      "\e[A":history-search-backward
      "\e[B":history-search-forward
    '';
  };

  # Btop system monitor
  programs.btop = {
    enable = true;
    settings = {
      theme_background = false;
      vim_keys = true;
    };
  };
  catppuccin.btop.enable = true;

  # Fastfetch (system info)
  programs.fastfetch = {
    enable = true;
  };

  # Fish shell (disabled - using zsh with p10k)
  programs.fish = {
    enable = false;
    interactiveShellInit = ''
      set fish_greeting  # Disable greeting

      # Conda init (if exists on macOS)
      if test -f /opt/miniconda3/bin/conda
        eval /opt/miniconda3/bin/conda "shell.fish" "hook" $argv | source
      else if test -f "/opt/miniconda3/etc/fish/conf.d/conda.fish"
        source "/opt/miniconda3/etc/fish/conf.d/conda.fish"
      end

      # Catppuccin Macchiato colors
      set -gx fish_color_normal cad3f5
      set -gx fish_color_command 8aadf4
      set -gx fish_color_param f0c6c6
      set -gx fish_color_keyword ed8796
      set -gx fish_color_quote a6da95
      set -gx fish_color_redirection f5bde6
      set -gx fish_color_end f5a97f
      set -gx fish_color_error ed8796
      set -gx fish_color_gray 6e738d
      set -gx fish_color_selection --background=363a4f
      set -gx fish_color_search_match --background=363a4f
      set -gx fish_color_operator f5bde6
      set -gx fish_color_escape f0c6c6
      set -gx fish_color_autosuggestion 6e738d
      set -gx fish_color_cancel ed8796
      set -gx fish_pager_color_progress 6e738d
      set -gx fish_pager_color_prefix f5bde6
      set -gx fish_pager_color_completion cad3f5
      set -gx fish_pager_color_description 6e738d
    '';

    shellAliases = {
      # Navigation
      ".." = "cd ..";
      "..." = "cd ../..";
      "...." = "cd ../../..";

      # eza aliases
      ls = "eza --icons";
      ll = "eza -l --icons";
      la = "eza -la --icons";
      lt = "eza --tree --icons";
      l = "eza -l --icons";

      # Git
      g = "git";
      gs = "git status";
      ga = "git add";
      gc = "git commit";
      gp = "git push";
      gl = "git pull";
      gd = "git diff";
      gco = "git checkout";
      gb = "git branch";
      glog = "git log --oneline --graph";

      # Docker
      d = "docker";
      dc = "docker compose";
      dps = "docker ps";

      # Misc
      cat = "bat";
      vim = "nvim";
      vi = "nvim";
      c = "clear";
      tree = "eza --tree --icons";

      # NixOS
      nrs = "sudo nixos-rebuild switch --flake ~/nixos-config#workstation";
      nrt = "sudo nixos-rebuild test --flake ~/nixos-config#workstation";
      nfu = "nix flake update";

      # Home Manager (macOS)
      hms = "home-manager switch --flake ~/nixos-config#rxue@macbook";

      # Security tools
      unshadow = "john --show";
      zip2john = "zip2john";
      rar2john = "rar2john";
      ssh2john = "ssh2john";
    };

    plugins = [
      {
        name = "fzf.fish";
        src = pkgs.fishPlugins.fzf-fish.src;
      }
      {
        name = "done";
        src = pkgs.fishPlugins.done.src;
      }
    ];
  };

  # Starship prompt
  # Tmux
  programs.tmux = {
    enable = true;
    shell = "${pkgs.zsh}/bin/zsh";
    terminal = "tmux-256color";
    prefix = "C-a";
    baseIndex = 1;
    escapeTime = 0;
    historyLimit = 10000;
    mouse = true;
    keyMode = "vi";

    extraConfig = ''
      # Override sensible plugin's default-command to use zsh directly
      set -g default-command "${pkgs.zsh}/bin/zsh"

      # Load keybinds, theme, and statusline from dotfiles
      source-file ~/nixos-config/dotfiles/tmux/tmux.local.conf
    '';

    plugins = with pkgs.tmuxPlugins; [
      sensible
      vim-tmux-navigator
      {
        plugin = resurrect;
        extraConfig = "set -g @resurrect-strategy-nvim 'session'";
      }
      {
        plugin = continuum;
        extraConfig = ''
          set -g @continuum-restore 'on'
          set -g @continuum-save-interval '10'
        '';
      }
    ];
  };

  # Sessionizer script (generated from userConfig.sessionizerPaths)
  home.file.".local/scripts/tmux-sessionizer" = {
    executable = true;
    text = ''
      #!/usr/bin/env bash

      if [[ $# -eq 1 ]]; then
          selected=$1
      else
          selected=$(find ${lib.concatStringsSep " " userConfig.sessionizerPaths} -mindepth 1 -maxdepth 1 -type d 2>/dev/null | fzf)
      fi

      if [[ -z $selected ]]; then
          exit 0
      fi

      selected_name=$(basename "$selected" | tr '. ' '_')
      tmux_running=$(pgrep tmux)

      if [[ -z $TMUX ]] && [[ -z $tmux_running ]]; then
          tmux new-session -s "$selected_name" -c "$selected"
          exit 0
      fi

      if ! tmux has-session -t="$selected_name" 2> /dev/null; then
          tmux new-session -ds "$selected_name" -c "$selected"
      fi

      if [[ -z $TMUX ]]; then
          tmux attach -t "$selected_name"
      else
          tmux switch-client -t "$selected_name"
      fi
    '';
  };

  # fzf
  programs.fzf = {
    enable = true;
    enableFishIntegration = false;
    enableZshIntegration = true;
    defaultCommand = "fd --type f --hidden --follow --exclude .git";
    defaultOptions = [
      "--height 40%"
      "--layout=reverse"
      "--border"
      "--color=bg+:#363a4f,bg:#24273a,spinner:#f4dbd6,hl:#ed8796"
      "--color=fg:#cad3f5,header:#ed8796,info:#c6a0f6,pointer:#f4dbd6"
      "--color=marker:#f4dbd6,fg+:#cad3f5,prompt:#c6a0f6,hl+:#ed8796"
    ];
    fileWidgetCommand = "fd --type f --hidden --follow --exclude .git";
    changeDirWidgetCommand = "fd --type d --hidden --follow --exclude .git";
  };

  # Direnv
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  # Zoxide (smart cd replacement)
  programs.zoxide = {
    enable = true;
    enableFishIntegration = false;
    enableZshIntegration = false;  # Manually initialized at end of zsh.nix initContent
    options = [ "--cmd" "cd" ];  # Replace cd with zoxide
  };

  # GTK theme (Linux only)
  gtk = lib.mkIf isLinux {
    enable = true;
    theme = {
      name = "catppuccin-macchiato-mauve-standard";
      package = pkgs.catppuccin-gtk.override {
        accents = [ "mauve" ];
        variant = "macchiato";
      };
    };
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
    cursorTheme = {
      name = "catppuccin-macchiato-dark-cursors";
      package = pkgs.catppuccin-cursors.macchiatoDark;
      size = 24;
    };
    font = {
      name = "Noto Sans";
      size = 11;
    };
  };

  # Qt theme (Linux only)
  qt = lib.mkIf isLinux {
    enable = true;
    platformTheme.name = "gtk";
    style.name = "gtk2";
  };

  # Niri config symlink (Linux only)
  xdg.configFile."niri/config.kdl" = lib.mkIf isLinux {
    source = config.lib.file.mkOutOfStoreSymlink
      "${config.home.homeDirectory}/nixos-config/dotfiles/niri/config.kdl";
  };

  # Zed config symlink
  xdg.configFile."zed/settings.json".source = config.lib.file.mkOutOfStoreSymlink
    "${config.home.homeDirectory}/nixos-config/dotfiles/zed/settings.json";

  # Aerospace config symlink (macOS only)
  xdg.configFile."aerospace/aerospace.toml" = lib.mkIf isDarwin {
    source = config.lib.file.mkOutOfStoreSymlink
      "${config.home.homeDirectory}/nixos-config/dotfiles/aerospace/aerospace.toml";
  };
}
