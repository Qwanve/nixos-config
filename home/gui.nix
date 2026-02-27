{config, pkgs, inputs, ...} :
{
  home.packages = [
    # (pkgs.wrapFirefox (pkgs.firefox-unwrapped.override { pipewireSupport = true; }) {})
    pkgs.firefox
    pkgs.prismlauncher
    pkgs.steam
    pkgs.gamescope
    pkgs.imv
    pkgs.signal-desktop
    pkgs.bolt-launcher
    pkgs.vesktop
  ];

  home.sessionVariables = {
    MOZ_USE_XINPUT2 = "1";
  };

  # https://github.com/Supreeeme/xwayland-satellite/issues/225
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
    settings = {
      main = {
        shell = "${pkgs.fish}/bin/fish";
      };
    };

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
