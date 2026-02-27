{ config, lib, pkgs, inputs, home-manager, hostname, ...}:
{
  home-manager.useUserPackages = true;
  home-manager.sharedModules = [
    inputs.nix-index-database.homeModules.nix-index
    inputs.stylix.homeModules.stylix
    inputs.dms.homeModules.dank-material-shell
  ];
  home-manager.extraSpecialArgs = { inherit inputs hostname; };

  home-manager.users.chrx = {
    home.username = "chrx";
    home.homeDirectory = "/home/chrx";

    nixpkgs.config.allowUnfree = true;
    programs.home-manager.enable = true;
    home.stateVersion = "24.05";

    imports = [
      ./home/niri.nix
      ./home/gui.nix
      ./home/cli.nix
      ./home/stylix.nix
    ];
  };

  users.mutableUsers = false;
  users.users.chrx = {
    isNormalUser = true;
    description = "Daniel Stroh";
    extraGroups = [ "networkmanager" "wheel" "input" ];
    hashedPassword = "$y$j9T$tRGSqIPv4NpMMYGZ1ZyC11$ieJa3XPzdkApzolCiknR7tLuugS4Q0i4JNBJTQiLMT7";
  };

}
