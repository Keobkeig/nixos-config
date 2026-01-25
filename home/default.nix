{ config, pkgs, lib, inputs, userConfig, ... }:

{
  imports = [
    inputs.catppuccin.homeManagerModules.catppuccin
    inputs.spicetify-nix.homeManagerModules.default
    inputs.dms.homeManagerModules.default

    ./kitty.nix
    ./neovim.nix
    ./spicetify.nix
    ./git.nix
    ./zathura.nix
    ./gaming.nix
  ];

  home.username = "rxue";
  home.homeDirectory = "/home/rxue";
  home.stateVersion = "24.11";

  # Let Home Manager manage itself
  programs.home-manager.enable = true;

  # Catppuccin theme (Mocha flavor)
  catppuccin = {
    enable = true;
    flavor = "mocha";
    accent = "mauve";
  };

  # DankMaterialShell
  programs.dms = {
    enable = true;
    # DMS replaces: waybar, mako, fuzzel, swaylock, swayidle
  };

  # Fish shell
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set fish_greeting  # Disable greeting

      # Catppuccin Mocha colors
      set -gx fish_color_normal cdd6f4
      set -gx fish_color_command 89b4fa
      set -gx fish_color_param f2cdcd
      set -gx fish_color_keyword f38ba8
      set -gx fish_color_quote a6e3a1
      set -gx fish_color_redirection f5c2e7
      set -gx fish_color_end fab387
      set -gx fish_color_error f38ba8
      set -gx fish_color_gray 6c7086
      set -gx fish_color_selection --background=313244
      set -gx fish_color_search_match --background=313244
      set -gx fish_color_operator f5c2e7
      set -gx fish_color_escape f2cdcd
      set -gx fish_color_autosuggestion 6c7086
      set -gx fish_color_cancel f38ba8
      set -gx fish_pager_color_progress 6c7086
      set -gx fish_pager_color_prefix f5c2e7
      set -gx fish_pager_color_completion cdd6f4
      set -gx fish_pager_color_description 6c7086
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
  programs.starship = {
    enable = true;
    enableFishIntegration = true;
    settings = {
      format = lib.concatStrings [
        "$directory"
        "$git_branch"
        "$git_status"
        "$python"
        "$rust"
        "$nodejs"
        "$golang"
        "$lua"
        "$nix_shell"
        "$cmd_duration"
        "$line_break"
        "$character"
      ];

      directory = {
        style = "bold mauve";
        truncation_length = 3;
        truncate_to_repo = true;
      };

      git_branch = {
        format = "[$symbol$branch]($style) ";
        symbol = " ";
        style = "bold pink";
      };

      git_status = {
        format = "[$all_status$ahead_behind]($style) ";
        style = "bold red";
      };

      python = {
        format = "[$symbol($version )]($style)";
        symbol = " ";
        style = "bold yellow";
      };

      rust = {
        format = "[$symbol($version )]($style)";
        symbol = " ";
        style = "bold peach";
      };

      nodejs = {
        format = "[$symbol($version )]($style)";
        symbol = " ";
        style = "bold green";
      };

      golang = {
        format = "[$symbol($version )]($style)";
        symbol = " ";
        style = "bold sky";
      };

      lua = {
        format = "[$symbol($version )]($style)";
        symbol = " ";
        style = "bold blue";
      };

      nix_shell = {
        format = "[$symbol$state]($style) ";
        symbol = " ";
        style = "bold lavender";
      };

      cmd_duration = {
        format = "[$duration]($style) ";
        style = "bold subtext0";
        min_time = 2000;
      };

      character = {
        success_symbol = "[❯](bold green)";
        error_symbol = "[❯](bold red)";
      };

      palette = "catppuccin_mocha";
      palettes.catppuccin_mocha = {
        rosewater = "#f5e0dc";
        flamingo = "#f2cdcd";
        pink = "#f5c2e7";
        mauve = "#cba6f7";
        red = "#f38ba8";
        maroon = "#eba0ac";
        peach = "#fab387";
        yellow = "#f9e2af";
        green = "#a6e3a1";
        teal = "#94e2d5";
        sky = "#89dceb";
        sapphire = "#74c7ec";
        blue = "#89b4fa";
        lavender = "#b4befe";
        text = "#cdd6f4";
        subtext1 = "#bac2de";
        subtext0 = "#a6adc8";
        overlay2 = "#9399b2";
        overlay1 = "#7f849c";
        overlay0 = "#6c7086";
        surface2 = "#585b70";
        surface1 = "#45475a";
        surface0 = "#313244";
        base = "#1e1e2e";
        mantle = "#181825";
        crust = "#11111b";
      };
    };
  };

  # Tmux
  programs.tmux = {
    enable = true;
    shell = "${pkgs.fish}/bin/fish";
    terminal = "tmux-256color";
    prefix = "C-a";
    baseIndex = 1;
    escapeTime = 0;
    historyLimit = 10000;
    mouse = true;
    keyMode = "vi";

    extraConfig = ''
      # True color and clipboard
      set -ga terminal-overrides ",*:RGB"
      set -g set-clipboard on

      # Vim like pane selection
      bind h select-pane -L
      bind j select-pane -D
      bind k select-pane -U
      bind l select-pane -R

      # Split panes with | and -
      unbind %
      bind | split-window -h -c "#{pane_current_path}"
      unbind '"'
      bind - split-window -v -c "#{pane_current_path}"

      # Reload config
      unbind r
      bind r source-file ~/.config/tmux/tmux.conf

      # Window/pane indexing
      set -g pane-base-index 1
      set-window-option -g pane-base-index 1
      set-option -g renumber-windows on

      # Vim-like copy/paste
      set-window-option -g mode-keys vi
      bind-key -T copy-mode-vi v send-keys -X begin-selection
      bind-key -T copy-mode-vi C-v send-keys -X rectangle-toggle
      bind-key -T copy-mode-vi y send-keys -X copy-selection-and-cancel
      unbind -T copy-mode-vi MouseDragEnd1Pane

      # Alt+hjkl to switch panes (vim-style)
      bind -n M-h select-pane -L
      bind -n M-j select-pane -D
      bind -n M-k select-pane -U
      bind -n M-l select-pane -R

      # Alt+number to select window
      bind -n M-1 select-window -t 1
      bind -n M-2 select-window -t 2
      bind -n M-3 select-window -t 3
      bind -n M-4 select-window -t 4
      bind -n M-5 select-window -t 5
      bind -n M-6 select-window -t 6
      bind -n M-7 select-window -t 7
      bind -n M-8 select-window -t 8
      bind -n M-9 select-window -t 9

      # Catppuccin Macchiato theme colors
      thm_bg="#24273a"
      thm_fg="#cad3f5"
      thm_cyan="#91d7e3"
      thm_black="#181926"
      thm_gray="#363a4f"
      thm_magenta="#c6a0f6"
      thm_pink="#f5bde6"
      thm_red="#ed8796"
      thm_green="#a6da95"
      thm_yellow="#eed49f"
      thm_blue="#8aadf4"
      thm_orange="#f5a97f"
      thm_black4="#494d64"

      # Status bar
      set -g status "on"
      set -g status-bg "''${thm_bg}"
      set -g status-justify "left"
      set -g status-left-length "100"
      set -g status-right-length "100"
      set-option -g status-position top

      # Messages
      set -g message-style "fg=''${thm_cyan},bg=''${thm_gray},align=centre"
      set -g message-command-style "fg=''${thm_cyan},bg=''${thm_gray},align=centre"

      # Panes
      set -g pane-border-style "fg=''${thm_gray}"
      set -g pane-active-border-style "fg=''${thm_blue}"

      # Windows
      set -g window-status-activity-style "fg=''${thm_fg},bg=''${thm_bg},none"
      set -g window-status-separator ""
      set -g window-status-style "fg=''${thm_fg},bg=''${thm_bg},none"

      # Statusline - current window
      set -g window-status-current-format "#[fg=''${thm_blue},bg=''${thm_bg}] #I: #[fg=''${thm_magenta},bg=''${thm_bg}](✓) #[fg=''${thm_cyan},bg=''${thm_bg}]#(echo '#{pane_current_path}' | rev | cut -d'/' -f-2 | rev) #[fg=''${thm_magenta},bg=''${thm_bg}]"

      # Statusline - other windows
      set -g window-status-format "#[fg=''${thm_blue},bg=''${thm_bg}] #I: #[fg=''${thm_fg},bg=''${thm_bg}]#W"

      # Statusline - right side
      set -g status-right "#[fg=''${thm_blue},bg=''${thm_bg},nobold,nounderscore,noitalics]#[fg=''${thm_bg},bg=''${thm_blue},nobold,nounderscore,noitalics] #[fg=''${thm_fg},bg=''${thm_gray}] #W #{?client_prefix,#[fg=''${thm_magenta}],#[fg=''${thm_cyan}]}#[bg=''${thm_gray}]#{?client_prefix,#[bg=''${thm_magenta}],#[bg=''${thm_cyan}]}#[fg=''${thm_bg}] #[fg=''${thm_fg},bg=''${thm_gray}] #S "

      # Statusline - left side (empty)
      set -g status-left ""

      # Modes
      set -g clock-mode-colour "''${thm_blue}"
      set -g mode-style "fg=''${thm_blue} bg=''${thm_black4} bold"

      # Sessionizer
      bind-key -r f run-shell "tmux neww ~/.local/scripts/tmux-sessionizer"
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

  # Sessionizer script
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
    enableFishIntegration = true;
    defaultCommand = "fd --type f --hidden --follow --exclude .git";
    defaultOptions = [
      "--height 40%"
      "--layout=reverse"
      "--border"
      "--color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8"
      "--color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc"
      "--color=marker:#f5e0dc,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8"
    ];
    fileWidgetCommand = "fd --type f --hidden --follow --exclude .git";
    changeDirWidgetCommand = "fd --type d --hidden --follow --exclude .git";
  };

  # Direnv
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  # Zoxide
  programs.zoxide = {
    enable = true;
    enableFishIntegration = true;
  };

  # GTK theme
  gtk = {
    enable = true;
    theme = {
      name = "catppuccin-mocha-mauve-standard";
      package = pkgs.catppuccin-gtk.override {
        accents = [ "mauve" ];
        variant = "mocha";
      };
    };
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
    cursorTheme = {
      name = "catppuccin-mocha-dark-cursors";
      package = pkgs.catppuccin-cursors.mochaDark;
      size = 24;
    };
    font = {
      name = "Noto Sans";
      size = 11;
    };
  };

  # Qt theme
  qt = {
    enable = true;
    platformTheme.name = "gtk";
    style.name = "gtk2";
  };

  # Niri config symlink
  xdg.configFile."niri/config.kdl".source = config.lib.file.mkOutOfStoreSymlink
    "${config.home.homeDirectory}/nixos-config/dotfiles/niri/config.kdl";

  # Zed config symlink
  xdg.configFile."zed/settings.json".source = config.lib.file.mkOutOfStoreSymlink
    "${config.home.homeDirectory}/nixos-config/dotfiles/zed/settings.json";
}
