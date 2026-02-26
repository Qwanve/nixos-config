# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, lib, pkgs, inputs, hostname, ... }:
{
  imports =
    [ # Include the results of the hardware scan.
      ./${hostname}/hardware.nix
    ] ++ (if hostname == "nyx" then [inputs.chromebook-ucm-conf.nixosModules.default] else []);

  # hardware.opengl.enable = true;
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  hardware.sensor.iio.enable = hostname == "nyx";
  hardware.firmware = [
    pkgs.sof-firmware
  ];

  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;

  # Enable nix2 commands and flake features
  nix.settings.experimental-features = ["nix-command flakes"];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  # boot.kernelPackages = pkgs.linuxPackages_6_1;
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.kernelParams = [
    "mem_sleep_default=deep"
  ];

  networking.hostName = hostname; # Define your hostname.

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/Chicago";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };


  services.libinput.enable = true;

  users.mutableUsers = false;
  users.users.chrx = {
    isNormalUser = true;
    description = "Daniel Stroh";
    extraGroups = [ "networkmanager" "wheel" "input" ];
    hashedPassword = "$y$j9T$tRGSqIPv4NpMMYGZ1ZyC11$ieJa3XPzdkApzolCiknR7tLuugS4Q0i4JNBJTQiLMT7";
  };

  environment.systemPackages = with pkgs; [
  ];

  # This fixes the path pollution but requires a rebuild of Hyprland
  # Boo
  # nixpkgs.config.packageOverrides = pkgs: {
  #   hyprland = pkgs.hyprland.override {
  #     wrapRuntimeDeps = false;
  #   };
  # };
  # programs.sway.enable = true;
  programs.niri.enable = true;
  programs.fish.enable = true;
  # programs.bash = {
  #   interactiveShellInit = ''
  #     if [[ $(${pkgs.procps}/bin/ps --no-header --pid=$PPID --format=comm) != "fish" && -z ''${BASH_EXECUTION_STRING} ]]
  #     then
  #       shopt -q login_shell && LOGIN_OPTION='--login' || LOGIN_OPTION=""
  #       exec ${pkgs.fish}/bin/fish $LOGIN_OPTION
  #     fi
  #   '';
  # };

  programs.nano.enable = false;

  # List services that you want to enable:
  
  services.tlp.enable = hostname == false;

  services.keyd = {
    enable = true;
    keyboards.all = {
      ids = ["*"];
      settings = {
        "main" = {
          "capslock" = "leftmeta";
          "rightalt" = "layer(rightalt)";
        };
        "meta" = {
          # "j" = "down";
          # "k" = "up";
          # "h" = "left";
          # "l" = "right";
          "1" = "f1";
          "2" = "f2";
          "3" = "f3";
          "4" = "f4";
          "5" = "f5";
          "6" = "f6";
          "7" = "f7";
          "8" = "f8";
          "9" = "f9";
          "0" = "f10";
          "-" = "f11";
          "equal" = "f12";
          "backspace" = "delete";
        };
        "alt" = {
          "brightnessup" = "kbdillumup";
          "brightnessdown" = "kbdillumdown";
        };
        "rightalt" = {
          "brightnessup" = "kbdillumup";
          "brightnessdown" = "kbdillumdown";
        };
      };
    };
  };
  systemd.services.keyd.serviceConfig.RestartPreventExitStatus = 255;

  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.tuigreet}/bin/tuigreet --time --remember --asterisks --sessions ${pkgs.fish}/share/applications:${pkgs.niri}/share/wayland-sessions";
        user = "greeter";
      };
    };
  };

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
    wireplumber.enable = true;

            # default.clock.quantum = 512
            # default.clock.min-quantum = 256
            # default.clock.max-quantum = 512
    configPackages = [
      (pkgs.writeTextDir "share/pipewire/pipewire.conf.d/99-min-quantum.conf"
        ''
          context.properties = {
            default.clock.force-quantum = 512;
          }
        ''
      )
    ];
  };

  # services.blueman.enable = true;

  xdg.portal = {
    enable = true;
    wlr.enable = true;
    config = {
      common = {
        default = [
          "gtk"
        ];
        "org.freedesktop.impl.portal.Screencast" = [
          "wlr"
        ];
        "org.freedesktop.impl.portal.Screenshot" = [
          "wlr"
        ];
      };
    };
    # extraPortals = [ pkgs.xdg-desktop-portal-gtk pkgs.xdg-desktop-portal-wlr ];
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  security.polkit.enable = true;
  security.rtkit.enable = true;

  services.acpid = {
    enable = true;
    handlers.TBLT = {
      event = "video/tabletmode";
      action = ''
        vals=($1)
        case ''${vals[2]} in
          0000008A)
            case ''${vals[3]} in
              00000001)
                echo "Tablet mode enabled"
                echo "activated" >> /var/run/user/1000/tablet
                disabled=1
                ;;
              00000000)
                echo "Tablet mode disabled"
                echo "deactivated" >> /var/run/user/1000/tablet
                disabled=0
                ;;
              *)
                echo "ACPI action undefined: $1" ;;
              esac
            ;;
          *)
            echo "ACPI action undefined: $1" ;;
          esac
          find /sys/class/input/input* -prune | while read inputnumber; do
            if grep -q -i -e "keyboard" -e "touchpad" $inputnumber/name; then
              echo "found $(cat $inputnumber/name)";
              echo $disabled > $inputnumber/inhibited;
            fi
          done
      '';
    };
  };

  services.upower.enable = true;
  powerManagement.enable = true;


  services.logind.settings.Login = {
    HandleSuspendKey = "ignore";
    HandleSuspendKeyLongPress = "suspend";
    HandlePowerKey = "suspend";
    HandlePowerKeyLongPress = "poweroff";
    HandleLidSwitch = "suspend";
    HandleLidSwitchDocked = "ignore";
    HandleLidSwitchExternalPower = "suspend";
  };

  services.udev.extraRules = ''
    ATTRS{idVendor}=="2e8a", ATTRS{idProduct}=="0003", MODE:="0666"
  '';

  fileSystems."/home/chrx/pico" = {
    device = "/dev/disk/by-id/usb-RPI_RP2_E0C9125B0D9B-0:0-part1";
    fsType = "vfat";
    options = [
      "users"
      "sync"
      "nofail"
      "noauto"
      "noatime"
    ];
  };

  networking.firewall.enable = false;

  security.shadow.enable = false;
  security.sudo.enable = false;
  security.sudo-rs.enable = true;

  security.wrappers = {
    su = {
      setuid = true;
      owner = "root";
      group = "root";
      source = "${pkgs.sudo-rs}/bin/su";
    };
  };

  security.pam.services = {
    su = {
      rootOK = true;
      forwardXAuth = true;
      logFailures = true;
    };
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?

}
