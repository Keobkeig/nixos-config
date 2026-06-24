{ config, pkgs, lib, userConfig, ... }:

let
  isLinux = pkgs.stdenv.isLinux;
  isDarwin = pkgs.stdenv.isDarwin;
  repoPath = "${config.home.homeDirectory}/nixos-config";
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
        email = if userConfig.isWork then "rxue@anduril.com" else "angela.xue3@gmail.com";
      } // lib.optionalAttrs userConfig.isWork {
        # SSH commit signing (GitHub Signing Key on GHE).
        signingkey = "${config.home.homeDirectory}/.ssh/id_ed25519.pub";
      };

      init.defaultBranch = "main";
      pull.rebase = true;
      push.autoSetupRemote = true;
      rebase.updateRefs = true;
      merge.conflictstyle = "diff3";
      diff.colorMoved = "default";
      core.editor = "nvim";
      core.autocrlf = "input";
      http.postBuffer = 524288000;

      credential.helper =
        if isDarwin then "osxkeychain"
        else "${pkgs.git-credential-libsecret}/bin/git-credential-libsecret";

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

      # Machine-local overrides (work email, signing key, etc.) — not managed by Nix.
      # Keys in ~/.gitconfig.local win any conflict with settings above.
      include.path = "~/.gitconfig.local";
    } // lib.optionalAttrs isDarwin {
      "credential \"https://dev.azure.com\"".useHttpPath = true;
    } // lib.optionalAttrs userConfig.isWork {
      # Anduril: rewrite https GHE URLs to ssh so go-mod / cargo / etc. work.
      "url \"git@ghe.anduril.dev:\"".insteadOf = "https://ghe.anduril.dev";
      gpg.format = "ssh";
      commit.gpgsign = true;
      tag.gpgsign = true;
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

  # gh CLI is installed via modules/packages/cli.nix.
  # Config is managed as a writable out-of-store symlink so `gh config set`,
  # `gh alias set`, etc. work at runtime. (programs.gh would write a read-only
  # store path, breaking those commands.)
  home.file.".config/gh/config.yml".source =
    config.lib.file.mkOutOfStoreSymlink "${repoPath}/dotfiles/gh/config.yml";

  programs.lazygit = {
    enable = true;
  };

  # Lazygit config symlink (macOS uses ~/Library/Application Support/lazygit/).
  # The programs.lazygit module also manages this same file, but disables it
  # (enable = settings != {}) since we set no `settings`, and would write a
  # read-only store path. mkForce on both source and enable makes our writable
  # out-of-store symlink win (runtime `o` edits work). Same rationale as gh above.
  home.file."${if isDarwin then "Library/Application Support/lazygit/config.yml" else ".config/lazygit/config.yml"}" = {
    enable = lib.mkForce true;
    source = lib.mkForce (config.lib.file.mkOutOfStoreSymlink "${repoPath}/dotfiles/lazygit/config.yml");
  };
}
