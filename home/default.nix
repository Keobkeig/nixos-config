{
  lib,
  profile,
  userConfig,
  ...
}:

{
  assertions = [
    {
      assertion = builtins.elem profile [
        "darwin"
        "nixos-desktop"
        "wsl"
      ];
      message = "Unknown Home Manager profile '${profile}'.";
    }
  ];

  imports = [
    ./profiles/core.nix
  ]
  ++ lib.optionals (profile == "darwin") [
    ./profiles/darwin.nix
  ]
  ++ lib.optionals (profile == "nixos-desktop") [
    ./profiles/nixos-desktop.nix
  ]
  ++ lib.optionals (profile == "wsl") [
    ./profiles/wsl.nix
  ];

  home.username = userConfig.username;
  home.homeDirectory =
    if profile == "darwin" then "/Users/${userConfig.username}" else "/home/${userConfig.username}";
  home.stateVersion = "24.11";
}
