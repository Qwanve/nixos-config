{config, pkgs, lib, inputs, catppuccin, ...}:
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
      window.commands = [
        {
          command = "floating enable; sticky enable";
          criteria = {
            title = "Picture-in-Picture";
            app_id = "firefox";
          };
        }
        {
          command = "inhibit_idle fullscreen";
          criteria = {
            app_id = "firefox";
          };
        }
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
        "${modifier}+XF86Sleep" = "exec ${pkgs.swaylock-effects}/bin/swaylock --fade 0.5 --grace 3";

        "${modifier}+u" = "seat - pointer_constraint escape";
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

  programs.swaylock = {
    enable = true;
    package = pkgs.swaylock-effects;
    settings = {
      daemonize = true;
      ignore-empty-password = true;
      grace = 0;
      fade-in = 0;
      grace-no-mouse = true;
      grace-no-touch = true;
      screenshots = true;
      effect-blur = "16x4";
      effect-greyscale = true;
      clock = true;
      ring-clear-color = lib.mkForce "282a36DD";
      text-clear-color = lib.mkForce "f0f1f4AA";
      inside-clear-color = lib.mkForce "000000FF";
      ring-color = lib.mkForce "282a36DD";
      inside-color = lib.mkForce "000000FF";
      text-color = lib.mkForce "f0f1f4AA";
      key-hl-color = lib.mkForce "50fa7bAA";
      bs-hl-color = lib.mkForce "fa507bAA";
      ring-ver-color = lib.mkForce "507bfaAA";
      inside-ver-color = lib.mkForce "000000FF";
      text-ver-color = lib.mkForce "f0f1f4AA";
      ring-wrong-color = lib.mkForce "ff507bFF";
      inside-wrong-color = lib.mkForce "200000FF";
      text-wrong-color = lib.mkForce "f0f1f4AA";
    };
  };

  services.swayidle = {
    enable = true;
    events = [
      { event = "before-sleep"; command = "${pkgs.swaylock-effects}/bin/swaylock"; }
      { event = "lock"; command = "${pkgs.swaylock-effects}/bin/swaylock --fade-in 3 --grace 5"; }
    ];
    timeouts = [
      { timeout = 120; command = "${pkgs.swaylock-effects}/bin/swaylock --fade-in 3 --grace 5"; }
      { timeout = 180; command = "${pkgs.swayfx}/bin/swaymsg 'output * power off'"; resumeCommand = "${pkgs.swayfx}/bin/swaymsg 'output * power on'"; }
      { timeout = 300; command = "${pkgs.systemd}/bin/systemctl suspend"; }
    ];
  };
}
