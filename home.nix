{ config, pkgs, inputs, ...}:
{
    home.username = "chrx";
    home.homeDirectory = "/home/chrx";

    nixpkgs.config = import ./home/nixpkgs.nix;
    programs.home-manager.enable = true;
    home.stateVersion = "24.05";

    imports = [
      ./home/niri.nix
      ./home/gui.nix
      ./home/cli.nix
      ./home/stylix.nix
    ];
}
