{
  config,
  pkgs,
  lib,
  inputs,
  profile,
  userConfig,
  ...
}:

let
  packageSets = import ../../lib/package-sets.nix { inherit pkgs; };
  palette = import ../../lib/palette.nix;
in
{
  imports = [
    inputs.nix-index-database.homeModules.nix-index

    ../neovim.nix
    ../git.nix
    ../zsh.nix
    ../herdr.nix
  ];

  home.packages =
    packageSets.sharedUnix
    ++ lib.optionals pkgs.stdenv.isLinux packageSets.linux
    ++ lib.optionals pkgs.stdenv.isDarwin packageSets.darwin
    ++ lib.optionals userConfig.isWork [
      pkgs.amazon-ecr-credential-helper
    ];

  programs.bat = {
    enable = true;
  }
  // lib.optionalAttrs (profile != "nixos-desktop") {
    config.theme = "Catppuccin Macchiato";
    themes."Catppuccin Macchiato" = {
      src = inputs.catppuccin-bat;
      file = "themes/Catppuccin Macchiato.tmTheme";
    };
  };

  programs.nix-index-database.comma.enable = true;

  home.sessionVariables = {
    GOPATH = "$HOME/go";
    CARGO_HOME = "$HOME/.cargo";
    RUSTUP_HOME = "$HOME/.rustup";
    EDITOR = "nvim";
    _ZO_DOCTOR = "0";
  };

  programs.home-manager.enable = true;

  programs.readline = {
    enable = true;
    extraConfig = ''
      $include /etc/inputrc
      "\e[A":history-search-backward
      "\e[B":history-search-forward
    '';
  };

  programs.btop = {
    enable = true;
    settings = {
      theme_background = false;
      vim_keys = true;
    }
    // lib.optionalAttrs (profile != "nixos-desktop") {
      color_theme = "catppuccin_macchiato.theme";
    };
  };

  xdg.configFile."btop/themes/catppuccin_macchiato.theme" = lib.mkIf (profile != "nixos-desktop") {
    source = "${inputs.catppuccin-btop}/themes/catppuccin_macchiato.theme";
  };

  programs.fastfetch.enable = true;

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
      set -g default-command "${pkgs.zsh}/bin/zsh"
      source-file ${config.home.homeDirectory}/nixos-config/dotfiles/tmux/tmux.local.conf
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

      printf '\e]1;%s\a' "$selected_name"

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

  programs.fzf = {
    enable = true;
    enableFishIntegration = false;
    enableZshIntegration = true;
    defaultCommand = "fd --type f --hidden --follow --exclude .git";
    defaultOptions = [
      "--height 40%"
      "--layout=reverse"
      "--border"
      "--color=bg+:${palette.surface0},bg:${palette.base},spinner:${palette.rosewater},hl:${palette.red}"
      "--color=fg:${palette.text},header:${palette.red},info:${palette.mauve},pointer:${palette.rosewater}"
      "--color=marker:${palette.rosewater},fg+:${palette.text},prompt:${palette.mauve},hl+:${palette.red}"
    ];
    fileWidgetCommand = "fd --type f --hidden --follow --exclude .git";
    changeDirWidgetCommand = "fd --type d --hidden --follow --exclude .git";
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  programs.zoxide = {
    enable = true;
    enableFishIntegration = false;
    enableZshIntegration = false;
    options = [
      "--cmd"
      "cd"
    ];
  };
}
