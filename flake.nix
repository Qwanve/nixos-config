{
  description = "A simple NixOS flake";

  inputs = {
    # NixOS official package source, using the nixos-23.11 branch here
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";

    home-manager.url = "github:nix-community/home-manager/release-23.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    catppuccin-foot-theme.url = "github:catppuccin/foot";
    catppuccin-foot-theme.flake = false;

    catppuccin-mako-theme.url = "github:catppuccin/mako";
    catppuccin-mako-theme.flake = false;

    chromebook-ucm-conf.url = "github:Qwanve/chromebook-ucm-conf";
    chromebook-ucm-conf.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, home-manager, ... } @ inputs: {
    nixosConfigurations.nyx = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs.inputs = inputs;
      modules = [
        ./nyx/system.nix
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.chrx = import ./nyx/home.nix;
          home-manager.extraSpecialArgs.inputs = inputs;
        }

        # remove in 24.05
        (import ./disable-channels.nix {lib=nixpkgs.lib; nixpkgs=nixpkgs;})
      ];
    };
  };
}
