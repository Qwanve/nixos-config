{ config, pkgs, inputs, ...}:
{
    home.username = "chrx";
    home.homeDirectory = "/home/chrx";

    nixpkgs.config = import ../home/nixpkgs.nix;
    # xdg.configFile."nixpkgs/config.nix".source = ../home/nixpkgs.nix;
    programs.home-manager.enable = true;
    home.stateVersion = "24.05";

    _module.args.catppuccin = rec {
      caps = {
        theme = "Frappe";
        accent = "Blue";
      };
      lower = {
        theme = pkgs.lib.strings.toLower caps.theme;
        accent = pkgs.lib.strings.toLower caps.accent;
      };
    };

    imports = [
      # ../home/hypr.nix
      ../home/sway.nix
      ../home/gui.nix
      ../home/cli.nix
      ../home/stylix.nix
    ];
}
