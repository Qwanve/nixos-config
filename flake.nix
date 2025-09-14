{
  description = "A simple NixOS flake";

  inputs = {
    # NixOS official package source, using the nixos-24.05 branch here
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    # lix-module = {
    #   url = "https://git.lix.systems/lix-project/nixos-module/archive/2.90.0.tar.gz";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };

    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nix-index-database.url = "github:nix-community/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";

    stylix.url = "github:danth/stylix";
    stylix.inputs.nixpkgs.follows = "nixpkgs";

    catppuccin-foot-theme.url = "github:catppuccin/foot";
    catppuccin-foot-theme.flake = false;

    catppuccin-mako-theme.url = "github:catppuccin/mako";
    catppuccin-mako-theme.flake = false;

    chromebook-ucm-conf.url = "github:Qwanve/chromebook-ucm-conf";
    chromebook-ucm-conf.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, home-manager, ... } @ inputs:
  let config = hostname:
    nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs.inputs = inputs;
      specialArgs.hostname = hostname;
      modules = [
        ./system.nix
        home-manager.nixosModules.home-manager
        {
          # home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.sharedModules = [
            inputs.nix-index-database.homeModules.nix-index
            inputs.stylix.homeModules.stylix
          ];
          home-manager.users.chrx = import ./home.nix;
          home-manager.extraSpecialArgs = {
            inputs = inputs;
            hostname = hostname;
          };
        }

        # inputs.lix-module.nixosModules.default

        {
          nix.channel.enable = false;
        }
      ];
  }; in {
    nixosConfigurations.nyx = config "nyx";
    nixosConfigurations.void = config "void";
  };
}
