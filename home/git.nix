{ config, pkgs, ... }:

{
  programs.git = {
    enable = true;
    userName = "Richie Xue";
    userEmail = "angela.xue3@gmail.com";

    delta = {
      enable = true;
      options = {
        navigate = true;
        light = false;
        side-by-side = true;
        line-numbers = true;
        syntax-theme = "Catppuccin Mocha";
      };
    };

    extraConfig = {
      init.defaultBranch = "main";
      pull.rebase = true;
      push.autoSetupRemote = true;
      merge.conflictstyle = "diff3";
      diff.colorMoved = "default";
      core.editor = "nvim";

      # Credential helper using gnome-keyring
      credential.helper = "${pkgs.gitFull}/bin/git-credential-libsecret";
    };

    aliases = {
      co = "checkout";
      br = "branch";
      ci = "commit";
      st = "status";
      unstage = "reset HEAD --";
      last = "log -1 HEAD";
      lg = "log --oneline --graph --decorate";
      amend = "commit --amend --no-edit";
      pushf = "push --force-with-lease";
    };

    ignores = [
      ".DS_Store"
      "*.swp"
      "*.swo"
      "*~"
      ".direnv/"
      ".envrc"
      "node_modules/"
      "__pycache__/"
      "*.pyc"
      ".venv/"
      "venv/"
      "target/"
      "result"
      "result-*"
    ];
  };

  programs.gh = {
    enable = true;
    settings = {
      git_protocol = "ssh";
      prompt = "enabled";
    };
  };

  programs.lazygit = {
    enable = true;
    settings = {
      gui = {
        theme = {
          activeBorderColor = [ "#cba6f7" "bold" ];
          inactiveBorderColor = [ "#6c7086" ];
          selectedLineBgColor = [ "#313244" ];
          cherryPickedCommitBgColor = [ "#45475a" ];
          cherryPickedCommitFgColor = [ "#cba6f7" ];
        };
        showIcons = true;
      };
      git = {
        paging = {
          colorArg = "always";
          pager = "delta --dark --paging=never";
        };
      };
    };
  };
}
