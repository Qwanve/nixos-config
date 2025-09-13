{ config, pkgs, catppuccin, ... }:
{
  stylix.enable = true;
  stylix.image = pkgs.fetchurl {
    url = "https://cdna.artstation.com/p/assets/images/images/002/446/988/large/alena-aenami-mountains1k.jpg?1461838329";
    sha256 = "sha256-Kcul1brR4vmuOgEZV7ON69RjF2+BWV6zutqUgBzvGus=";
  };
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
