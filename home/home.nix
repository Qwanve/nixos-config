{config, pkgs, ...} : 
{
  home.username = "chrx";
  home.homeDirectory = "/home/chrx";

  nixpkgs.config.allowUnfree = true;
  programs.home-manager.enable = true;
  home.stateVersion = "23.11";


  _module.args.catppuccin = rec {
    caps = {
      theme = "Frappe";
      accent = "Dark";
    };
    lower = {
      theme = pkgs.lib.strings.toLower caps.theme;
      accent = pkgs.lib.strings.toLower caps.accent;
    };
  };
  
  imports = [
    ./hypr.nix
    ./gui.nix
    ./cli.nix
  ];
}
