{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    # Performance overlay
    mangohud

    # Proton management
    protonup-qt

    # Wine
    wineWowPackages.stable
    winetricks

    # Vulkan tools
    vulkan-tools
    vulkan-loader
  ];

  # MangoHud configuration
  xdg.configFile."MangoHud/MangoHud.conf".text = ''
    ### Display settings ###
    gpu_stats
    gpu_temp
    gpu_core_clock
    gpu_mem_clock
    gpu_power
    gpu_load_change
    gpu_load_value=50,90
    gpu_load_color=FFFFFF,FFAA7F,CC0000
    gpu_text=GPU
    cpu_stats
    cpu_temp
    cpu_power
    cpu_mhz
    cpu_load_change
    core_load_change
    cpu_load_value=50,90
    cpu_load_color=FFFFFF,FFAA7F,CC0000
    cpu_color=2e97cb
    cpu_text=CPU
    io_color=a491d3
    vram
    vram_color=ad64c1
    ram
    ram_color=c26693
    fps
    engine_color=eb5b5b
    gpu_color=2e9762
    wine_color=eb5b5b
    frame_timing=1
    frametime_color=00ff00
    media_player_color=ffffff
    background_alpha=0.4
    font_size=24
    background_color=020202
    position=top-left
    text_color=ffffff
    round_corners=5
    toggle_hud=Shift_R+F12
    toggle_fps_limit=Shift_L+F1
    fps_limit_method=late
    fps_limit=0,60
    vsync=0
    gl_vsync=0
  '';

  # Gamemode configuration
  xdg.configFile."gamemode/gamemode.ini".text = ''
    [general]
    renice = 10
    ioprio = 0
    softrealtime = auto
    reaper_freq = 5

    [gpu]
    apply_gpu_optimisations = accept-responsibility
    gpu_device = 0
    nv_powermizer_mode = 1

    [custom]
    start = notify-send "GameMode started"
    end = notify-send "GameMode ended"
  '';
}
