{config, pkgs, inputs, catppuccin, ...} :
{
  home.packages = [
    (pkgs.wrapFirefox (pkgs.firefox-unwrapped.override { pipewireSupport = true; }) {})
    pkgs.prismlauncher
    pkgs.steam
    pkgs.imv
    pkgs.signal-desktop
    # pkgs.overskride
  ];
  
  fonts.fontconfig.enable = true;

  programs.foot = {
    enable = true;
    # server.enable = true;
    settings = {
      main = {
        include = "${inputs.catppuccin-foot-theme}/catppuccin-${catppuccin.lower.theme}.ini";
        shell = "${pkgs.fish}/bin/fish";
        dpi-aware = true;
        
      };
    };

  };

  services.gammastep = {
    enable = true;

    # Denver
    # latitude = 40;
    # longitude = 105;

    # Austin
    # latitude = 30;
    # longitude = 98;

    # Haughton
    latitude = 32.5;
    longitude = -93.5;
  };

}
