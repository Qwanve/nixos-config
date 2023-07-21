{config, pkgs, inputs, catppuccin, ...} :
{
  home.packages = [
    (pkgs.wrapFirefox (pkgs.firefox-unwrapped.override { pipewireSupport = true; }) {})
    pkgs.prismlauncher
    pkgs.steam
    pkgs.imv
    pkgs.signal-desktop
    pkgs.bolt-launcher
    pkgs.vesktop
  ];

  home.sessionVariables = {
    MOZ_USE_XINPUT2 = "1";
  };

  nixpkgs.overlays = [
    (final: prev: {
      steam = prev.steam.override {
        extraArgs = "-system-composer";
      };
    })
  ];
  
  fonts.fontconfig.enable = true;

  programs.foot = {
    enable = true;
    # server.enable = true;
    settings = {
      main = {
        # include = "${inputs.catppuccin-foot-theme}/themes/catppuccin-${catppuccin.lower.theme}.ini";
        shell = "${pkgs.fish}/bin/fish";
        # dpi-aware = true;
        
      };
    };

  };

  services.gammastep = {
    enable = true;

    # Denver
    # latitude = 40.0;
    # longitude = -105.0;

    # Austin
    # latitude = 30;
    # longitude = 98;

    # Haughton
    latitude = 32.5;
    longitude = -93.5;
  };

  gtk.enable = true;
  gtk.iconTheme = {
    name = "Pop";
    package = pkgs.pop-icon-theme;
  };


  services.easyeffects = {
    enable = false;
    extraPresets = {
      Noise = {
        input = {
          blocklist = [];
          plugins_order = [
            "rnnoise#0"
          ];
          "rnnoise#0" = {
              bypass = false;
              enable-vad = false;
              input-gain = 0.0;
              model-name = "";
              output-gain = 5.7;
              release = 20.0;
              vad-thres = 53.0;
              wet = 0.0;
          };
        };
      };
    };
    preset = "Noise";
  };

}
