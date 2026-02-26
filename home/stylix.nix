{ config, pkgs, ... }:
{
  stylix.enable = true;
  stylix.image = ./wallpaper.jpg;
  stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/dracula.yaml";
  stylix.polarity = "dark";
  stylix.cursor = {
    package = pkgs.graphite-cursors;
    name = "graphite-dark";
  };
  stylix.targets.helix.enable = false;
  stylix.cursor.size = 32;
  programs.helix.settings.theme = "dracula";
}
