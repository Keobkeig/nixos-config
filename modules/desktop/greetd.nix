{ config, pkgs, ... }:

{
  # greetd + tuigreet, replacing SDDM.
  #
  # SDDM was the only Qt/KDE dependency in an otherwise GTK + Wayland +
  # quickshell system, and pulled kdePackages in for a login screen. tuigreet is
  # a TTY greeter: no Qt, no display-server-before-the-display-server, and it is
  # trivially declarative. The trade-off is a text login prompt rather than a
  # graphical themed one.
  services.greetd = {
    enable = true;
    settings.default_session = {
      command = "${pkgs.tuigreet}/bin/tuigreet --time --remember --remember-session --cmd niri-session";
      user = "greeter";
    };
  };

  # Keep the TTY readable while greetd owns it.
  systemd.services.greetd.serviceConfig = {
    Type = "idle";
    StandardInput = "tty";
    StandardOutput = "tty";
    StandardError = "journal";
    TTYReset = true;
    TTYVHangup = true;
    TTYVTDisallocate = true;
  };

  # Stylix supplies the interface fonts; CJK coverage is not part of that, so it
  # stays declared here.
  fonts.packages = with pkgs; [
    noto-fonts-cjk-sans
  ];
}
