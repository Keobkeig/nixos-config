{ config, pkgs, lib, ... }:

let
  isLinux = pkgs.stdenv.isLinux;
  isDarwin = pkgs.stdenv.isDarwin;
in
{
  programs.git = {
    enable = true;

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

    settings = {
      user = {
        name = "Richie Xue";
        email = "angela.xue3@gmail.com";
      };

      init.defaultBranch = "main";
      pull.rebase = true;
      push.autoSetupRemote = true;
      merge.conflictstyle = "diff3";
      diff.colorMoved = "default";
      core.editor = "nvim";
      core.autocrlf = "input";
      http.postBuffer = 524288000;

      credential.helper =
        if isDarwin then "osxkeychain"
        else "${pkgs.gitFull}/bin/git-credential-libsecret";

      alias = {
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
    } // lib.optionalAttrs isDarwin {
      "credential \"https://dev.azure.com\"".useHttpPath = true;
    };
  };

  # Delta (git pager)
  programs.delta = {
    enable = true;
    enableGitIntegration = true;
    options = {
      navigate = true;
      light = false;
      side-by-side = true;
      line-numbers = true;
      syntax-theme = "Catppuccin Macchiato";
    };
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
          activeBorderColor = [ "#c6a0f6" "bold" ];
          inactiveBorderColor = [ "#6e738d" ];
          selectedLineBgColor = [ "#363a4f" ];
          cherryPickedCommitBgColor = [ "#494d64" ];
          cherryPickedCommitFgColor = [ "#c6a0f6" ];
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
