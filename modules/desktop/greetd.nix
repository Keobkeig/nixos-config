{
  config,
  pkgs,
  inputs,
  userConfig,
  ...
}:

{
  imports = [ inputs.dms.nixosModules.greeter ];

  # greetd running DankMaterialShell's own greeter, replacing SDDM.
  #
  # SDDM was the only Qt/KDE dependency in an otherwise GTK + Wayland +
  # quickshell system, pulling kdePackages in purely for a login screen. The DMS
  # greeter runs the same shell that runs the desktop, inside niri, so login
  # looks like the session it leads to -- without reintroducing KDE.
  services.greetd.enable = true;

  programs.dank-material-shell.greeter = {
    enable = true;
    compositor.name = "niri";

    # Copies this user's DMS settings, session state and generated colours into
    # the greeter's cache at boot, so the login screen picks up the same theme
    # and wallpaper as the desktop instead of DMS defaults.
    configHome = "/home/${userConfig.username}";
  };

  # Stylix supplies the interface fonts and the DMS greeter module adds its own
  # (fira-code, inter, material-symbols); CJK coverage is neither, so it stays
  # declared here.
  fonts.packages = with pkgs; [
    noto-fonts-cjk-sans
  ];
}
