{ config, pkgs, lib, ... }:

{
  # Powerlevel10k config file (symlink for edit-without-rebuild)
  home.file.".p10k.zsh".source = config.lib.file.mkOutOfStoreSymlink
    "${config.home.homeDirectory}/nixos-config/dotfiles/zsh/p10k.zsh";

  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    enableCompletion = true;

    # Source nix-daemon.sh to set up PATH for nix profile binaries (zoxide, etc.)
    # /etc/zshenv only does this for SSH connections, so we need it for local terminals
    envExtra = ''
      if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
        . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
      fi
    '';

    # Oh My Zsh
    oh-my-zsh = {
      enable = true;
      plugins = [ "git" ];
      theme = "";  # Disable oh-my-zsh theme - using powerlevel10k via plugins
    };

    plugins = [
      # Powerlevel10k prompt
      {
        name = "powerlevel10k";
        src = pkgs.zsh-powerlevel10k;
        file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
      }
    ];

    history = {
      size = 10000;
      save = 10000;
      ignoreDups = true;
      share = true;
      path = "${config.xdg.dataHome}/zsh/history";
    };

    initContent = lib.mkMerge [
      (lib.mkOrder 1000 ''
        # Load aliases and init from dotfiles (editable without rebuild)
        source ~/nixos-config/dotfiles/zsh/aliases.zsh
        source ~/nixos-config/dotfiles/zsh/init.zsh
      '')
      (lib.mkOrder 99999 ''
        # Zoxide MUST be initialized last - other plugins (direnv, syntax-highlighting)
        # can clobber its shell functions if loaded after it
        eval "$(${pkgs.zoxide}/bin/zoxide init zsh --cmd cd)"
      '')
    ];
  };
}
