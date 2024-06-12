{config, pkgs, inputs, catppuccin, ...} :
{

  home.packages = [
    # pkgs.tofi
    pkgs.libnotify
    pkgs.nerdfonts

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

  home.pointerCursor = {
    gtk.enable = true;
    x11.enable = true;
    package = pkgs.catppuccin-cursors."${catppuccin.lower.theme}${catppuccin.caps.accent}";
    name = "Catppuccin-${catppuccin.caps.theme}-${catppuccin.caps.accent}-Cursors";
    size = 64;
  };


  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      monitor = [
        "eDP-1,2256x1504@60,0x0,1.566667"
      ];
      xwayland.force_zero_scaling = true;
      misc.disable_hyprland_logo = true;
      bindr = [
        "SUPER, return, exec, foot"
        "SUPER, s, exec, systemctl suspend"
        "SUPER, d, exec, pkill ${pkgs.tofi}/bin/tofi-drun || ${pkgs.tofi}/bin/tofi-drun --width 80% --height 80% | xargs hyprctl dispatch exec --"
        "SUPER, f, exec, firefox"
        "SUPER, q, killactive,"
        "CTRL + SHIFT + SUPER, q, exit,"
        "CTRL + SHIFT + SUPER, r, exec, hyperctl reload"

        ", XF86AudioMute, exec, pactl set-sink-mute @DEFAULT_SINK@ toggle"

        "CTRL,1,workspace,1"
        "CTRL,2,workspace,2"
        "CTRL,3,workspace,3"
        "CTRL,4,workspace,4"
        "CTRL,5,workspace,5"
        "CTRL+SHIFT,1,movetoworkspace,1"
        "CTRL+SHIFT,2,movetoworkspace,2"
        "CTRL+SHIFT,3,movetoworkspace,3"
        "CTRL+SHIFT,4,movetoworkspace,4"
        "CTRL+SHIFT,5,movetoworkspace,5"

        "SUPER, tab, changegroupactive,f"

        "SUPER, space, fullscreen, 0"
        "SUPER+SHIFT, space, fakefullscreen,"
        "SUPER, backslash, togglefloating,"
        
      ];

      bindm = [
        # Super + Left Mouse = Move window
        "SUPER,mouse:272,movewindow"
      ];

      binde = [
        ", XF86MonBrightnessUp, exec, brightnessctl set -e1.5 5%+ -d intel_backlight"
        ", XF86MonBrightnessDown, exec, brightnessctl set -e1.5 5%- -d intel_backlight"
        ", XF86KbdBrightnessUp, exec, brightnessctl set 5%+ -d chromeos::kbd_backlight"
        ", XF86KbdBrightnessDown, exec, brightnessctl set 5%- -d chromeos::kbd_backlight"

        ", XF86AudioRaiseVolume, exec, pactl set-sink-volume @DEFAULT_SINK@ +5%"
        ", XF86AudioLowerVolume, exec, pactl set-sink-volume @DEFAULT_SINK@ -5%"
      ];

      exec-once = [
        "${pkgs.polkit-kde-agent}/usr/lib/polkit-kde-authentication-agent-1"
        "${pkgs.eww}/bin/eww daemon && ${pkgs.eww}/bin/eww open bar"
        "${pkgs.wpaperd}/bin/wpaperd"
        "${pkgs.rot8}/bin/rot8 -n1e4 -ZX --invert-xy xz --hooks 'sleep 0.15 && ${pkgs.eww}/bin/eww reload' & pkill -x -STOP rot8"
        "rm /home/chrx/.cache/tofi-drun"
        "${pkgs.batsignal}/bin/batsignal -n BAT0 -d4 -D 'notify-send \"Battery critical\" \"Battery at 3%\" -u critical && sleep 15 && systemctl hibernate'"
      ];

      input = {
        touchpad = {
          clickfinger_behavior = true;
        };
        tablet = {
          output = "eDP-1";
        };
      };

      "input:touchdevice" = {
        output = "eDP-1";
      };
        

      windowrulev2 = [
        "group new,class:(org.prismlauncher.PrismLauncher),title:(Prism Launcher 8.0)"
        "group set, class:(org.prismlauncher.PrismLauncher)"
        "float, title:^(Extension: .* — Mozilla Firefox)$"
      ];
      decoration = {
        rounding = 4;
      };

      gestures = {
        workspace_swipe = true;
        workspace_swipe_create_new = false;
      };

    };

  };

  programs.eww = {
    enable = true;
    package = pkgs.eww;
    configDir = ./eww-config;
  };
  programs.wpaperd = {
    enable = true;
    package = pkgs.wpaperd;
    settings = {
      eDP-1 = {
        path = ./wallpaper.png;
      };
    };
  };

  services.mako = {
    enable = true;
    extraConfig = pkgs.lib.readFile "${inputs.catppuccin-mako-theme}/src/${catppuccin.lower.theme}";
  };
  # programs.clipman.enable = true;
  
}
