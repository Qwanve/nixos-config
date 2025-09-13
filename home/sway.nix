{config, pkgs, inputs, catppuccin, ...}:
{
  home.packages = [
    # pkgs.tofi
    pkgs.libnotify
    pkgs.nerd-fonts.symbols-only
    pkgs.tofi

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
    config = rec {
      defaultWorkspace = "1";
      output = {
        "eDP-1" = {
          scale = "1.566667";
        };
      };
      input = {
        "1267:191:Elan_Touchpad" = {
          click_method = "clickfinger";
          tap = "enabled";
          tap_button_map = "lrm";
          drag = "enabled";
        };
        "1267:11635:ELAN90FC:00_04F3:2D73" = {
          map_to_output = "eDP-1";
        };
      };
      terminal = "${pkgs.foot}/bin/foot";
      modifier = "Mod4";
      bars = [];
      startup = [
        {command = "${pkgs.kdePackages.polkit-kde-agent-1}/usr/lib/polkit-kde-authentication-agent-1";}
        {command = "${pkgs.eww}/bin/eww daemon && ${pkgs.eww}/bin/eww open bar";}
        {command = "${pkgs.rot8}/bin/rot8 -n1e4 -X -k & pkill -x -STOP rot8";}
        {command = "rm /home/chrx/.cache/tofi-drun";}
        {command = "${pkgs.batsignal}/bin/batsignal -n BAT0 -d4 -D 'notify-send \"Battery critical\" \"Battery at 3%\" -u critical'";}
        {command = "${pkgs.autotiling}/bin/autotiling";}
      ];
      gaps = {
        outer = 5;
        inner = 5;
      };

      keybindings = {
        "${modifier}+Return" = "exec ${terminal}";
        "${modifier}+q" = "kill";
        "${modifier}+d" = "exec 'pkill ${pkgs.tofi}/bin/tofi-drun || ${pkgs.tofi}/bin/tofi-drun --width 80% --height 80% | xargs swaymsg exec --'";

        "${modifier}+f" = "exec firefox";
        "${modifier}+backslash" = "floating toggle";
        "${modifier}+space" = "fullscreen toggle";
        "CTRL+1" = "workspace 1";
        "CTRL+2" = "workspace 2";
        "CTRL+3" = "workspace 3";
        "CTRL+4" = "workspace 4";
        "CTRL+5" = "workspace 5";
        "CTRL+SHIFT+1" = "move window to workspace 1";
        "CTRL+SHIFT+2" = "move window to workspace 2";
        "CTRL+SHIFT+3" = "move window to workspace 3";
        "CTRL+SHIFT+4" = "move window to workspace 4";
        "CTRL+SHIFT+5" = "move window to workspace 5";


        "XF86MonBrightnessUp" = "exec brightnessctl set -e1.5 5%+ -d intel_backlight";
        "XF86MonBrightnessDown" = "exec brightnessctl set -e1.5 5%- -d intel_backlight";
        "XF86KbdBrightnessUp" = "exec brightnessctl set 5%+ -d chromeos::kbd_backlight";
        "XF86KbdBrightnessDown" = "exec brightnessctl set 5%- -d chromeos::kbd_backlight";
        "XF86AudioRaiseVolume" = "exec pactl set-sink-volume @DEFAULT_SINK@ +5%";
        "XF86AudioLowerVolume" = "exec pactl set-sink-volume @DEFAULT_SINK@ -5%";
        "XF86AudioMute" = "exec pactl set-sink-mute @DEFAULT_SINK@ toggle";
      };
    };
    # Bug: https://github.com/nix-community/home-manager/issues/5379
    checkConfig = false;
    extraConfig = "
      corner_radius 5
      floating_modifier Mod4 normal
    ";
    xwayland = true;
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
