{ config, pkgs, ... }:

{
  # Disable PulseAudio (using PipeWire instead)
  hardware.pulseaudio.enable = false;

  # Enable rtkit for real-time scheduling
  security.rtkit.enable = true;

  # PipeWire
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;

    # Low-latency configuration
    extraConfig.pipewire."92-low-latency" = {
      "context.properties" = {
        "default.clock.rate" = 48000;
        "default.clock.quantum" = 512;
        "default.clock.min-quantum" = 32;
        "default.clock.max-quantum" = 1024;
      };
    };
  };
}
