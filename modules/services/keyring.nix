{ config, pkgs, ... }:

{
  # GNOME Keyring
  services.gnome.gnome-keyring.enable = true;

  # PAM integration
  security.pam.services.sddm.enableGnomeKeyring = true;
  security.pam.services.login.enableGnomeKeyring = true;

  # Seahorse for GUI management
  environment.systemPackages = with pkgs; [
    gnome-keyring
    seahorse
    libsecret
  ];

  # Environment for SSH agent
  environment.sessionVariables = {
    SSH_AUTH_SOCK = "$XDG_RUNTIME_DIR/keyring/ssh";
  };
}
