{ config, lib, pkgs, inputs, hostname, ... }:
{
  imports = [
    ./${hostname}/hardware.nix
    (if hostname == "nyx" then inputs.chromebook-ucm-conf.nixosModules.default else {})

    ./system/sudo.nix
    ./system/laptop.nix
    ./system/pico.nix
  ];

  nix.package = pkgs.lixPackageSets.stable.lix;
  nix.settings.experimental-features = ["nix-command flakes"];

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;

  services.greetd = {
    enable = true;
    useTextGreeter = true;
    settings = {
      default_session = {
        command = "${pkgs.tuigreet}/bin/tuigreet --time --remember --asterisks --sessions ${pkgs.fish}/share/applications:${pkgs.niri}/share/wayland-sessions";
        user = "greeter";
      };
    };
  };
  
  networking.hostName = hostname;
  networking.networkmanager.enable = true;
  networking.firewall.enable = false;

  time.timeZone = "America/Chicago";

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

  environment.systemPackages = with pkgs; [
  ];

  programs.niri.enable = true;
  programs.fish.enable = true;

  programs.nano.enable = false;

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


  services.logind.settings.Login = {
    HandleSuspendKey = "ignore";
    HandleSuspendKeyLongPress = "suspend";
    HandlePowerKey = "suspend";
    HandlePowerKeyLongPress = "poweroff";
    HandleLidSwitch = "suspend";
    HandleLidSwitchDocked = "ignore";
    HandleLidSwitchExternalPower = "suspend";
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
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  security.polkit.enable = true;
  security.rtkit.enable = true;


  services.upower.enable = true;
  powerManagement.enable = true;

  system.stateVersion = "23.11";
}
