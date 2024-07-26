# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, inputs, ... }:
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware.nix
      inputs.chromebook-ucm-conf.nixosModules.default
    ];

  # hardware.opengl.enable = true;
  hardware.opengl = {
    enable = true;
    ## radv: an open-source Vulkan driver from freedesktop
    driSupport = true;
    driSupport32Bit = true;

    ## amdvlk: an open-source Vulkan driver from AMD
    extraPackages = [ pkgs.amdvlk ];
    extraPackages32 = [ pkgs.driversi686Linux.amdvlk ];
  };

  hardware.sensor.iio.enable = true;
  hardware.firmware = [
    pkgs.sof-firmware
  ];

  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;

  # Enable nix2 commands and flake features
  nix.settings.experimental-features = ["nix-command flakes"];
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_6_1;
  boot.kernelParams = [
    "mem_sleep_default=deep"
  ];

  networking.hostName = "nyx"; # Define your hostname.

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
    hashedPasswordFile = "/etc/nixos/passwd.hashed";
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
  programs.hyprland = {
    enable = true;
  };
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
  
  services.tlp.enable = true;

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
          "j" = "down";
          "k" = "up";
          "h" = "left";
          "l" = "right";
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

  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --remember --asterisks --sessions ${pkgs.hyprland}/share/wayland-sessions --cmd ${pkgs.hyprland}/bin/.Hyprland-wrapped";
        user = "greeter";
      };
    };
  };

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
    wireplumber.enable = true;
  };

  # services.blueman.enable = true;

  xdg.portal = {
    enable = true;
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
                echo 'Tablet mode enabled' ;;
              00000000)
                echo 'Tablet mode disabled' ;;
              *)
                echo "ACPI action undefined: $1" ;;
              esac
            ;;
          *)
            echo "ACPI action undefined: $1" ;;
          esac
      '';
    };
  };

  services.upower.enable = true;
  powerManagement.enable = true;


  services.logind = {
    suspendKey = "ignore";
    suspendKeyLongPress = "hibernate";
    powerKey = "suspend";
    powerKeyLongPress = "poweroff";
    lidSwitch = "suspend-then-hibernate";
    lidSwitchDocked = "ignore";
    lidSwitchExternalPower = "suspend";
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?

}
