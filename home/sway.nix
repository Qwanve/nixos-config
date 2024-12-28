{config, pkgs, inputs, catppuccin, ...}:
{
  home.packages = [
    # pkgs.tofi
    pkgs.libnotify
    pkgs.nerd-fonts.symbols-only

    # eww widgets
    # pactl
    pkgs.pulseaudio
    pkgs.brightnessctl
    pkgs.playerctl
    pkgs.socat
    pkgs.jq
    pkgs.acpi
    pkgs.jc
    pkgs.inotify-tools
  ];

  wayland.windowManager.sway = {
    enable = true;
    package = pkgs.swayfx;
    config = {
      output = {
        eDP-1 = {
          scale = 1.566667;
        };
      };
      input = {
        "1267:191:Elan_Touchpad" = {
          click_method = "clickfinger";
          clickfinger_button_map = "lrm";
          drag = "enabled";
        };
      };
      modifier = "Mod4";
      bars = [];
      startup = [
        # Launch Firefox on start
        {command = "foot";}
        {command = "eww open bar";}
      ];
      gaps = {
        outer = 5;
        inner = 5;
      };
    };
    # Bug: https://github.com/nix-community/home-manager/issues/5379
    checkConfig = false;
    extraConfig = "
      corner_radius 5
    ";
  };
  programs.eww = {
    enable = true;
    package = pkgs.eww;
    configDir = ./eww-config;
  };
  services.mako = {
    enable = true;
  };
}
