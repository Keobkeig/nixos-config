{ config, pkgs, lib, ... }:

{
  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    enableCompletion = true;

    history = {
      size = 10000;
      save = 10000;
      ignoreDups = true;
      share = true;
      path = "${config.xdg.dataHome}/zsh/history";
    };

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

      # CTF/Security tools (macOS paths)
      potfile = "cat /opt/homebrew/Cellar/hashcat/6.2.6_1/share/hashcat/hashcat.potfile";
      stegsolve = "cd ~/Documents/stegsolve-macos/ && java -jar stegsolve.jar";
      unshadow = "/opt/homebrew/Cellar/john-jumbo/1.9.0_1/share/john/unshadow";
      zip2john = "/opt/homebrew/Cellar/john-jumbo/1.9.0_1/share/john/zip2john";
      rar2john = "/opt/homebrew/Cellar/john-jumbo/1.9.0_1/share/john/rar2john";
      ssh2john = "/opt/homebrew/Cellar/john-jumbo/1.9.0_1/share/john/ssh2john.py";

      # Project-specific
      auv = "~/cuauv/workspaces/repo/docker/auv-docker.py";
      rv = "docker run -i --init -e NETID=rx77 --rm -v \"$PWD\":/root ghcr.io/sampsyo/cs3410-infra";
    };

    initExtra = ''
      # Sessionizer keybind (Ctrl+F)
      bindkey -s ^f "tmux-sessionizer\n"

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
        export OPENSSL_ROOT_DIR="/opt/homebrew/opt/openssl@3"
      fi

      # Google Cloud SDK
      [ -f "$HOME/Downloads/google-cloud-sdk/path.zsh.inc" ] && source "$HOME/Downloads/google-cloud-sdk/path.zsh.inc"
      [ -f "$HOME/Downloads/google-cloud-sdk/completion.zsh.inc" ] && source "$HOME/Downloads/google-cloud-sdk/completion.zsh.inc"

      # Additional PATH entries
      export PATH="$HOME/.local/scripts:$PATH"
      export PATH="$HOME/.local/bin:$PATH"
      export PATH="$HOME/.cargo/bin:$PATH"

      # Terminal
      export TERM=xterm-256color
    '';
  };
}
