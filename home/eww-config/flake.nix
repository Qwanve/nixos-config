{
  description = "Qwanve's EWW config";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }:
    let

      version = "0.1";

      # System types to support.
      supportedSystems = [ "x86_64-linux" "aarch64-linux" ];

      # Helper function to generate an attrset '{ x86_64-linux = f "x86_64-linux"; ... }'.
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;

      # Nixpkgs instantiated for supported system types.
      nixpkgsFor = forAllSystems (system: import nixpkgs { inherit system; overlays = [ self.overlays.default ]; });

    in

    {
      overlays.default = final: prev: {
        qwanve-eww = final.stdenv.mkDerivation {
          name = "qwanve-eww-${version}";

          src = ./.;

          buildInputs = [
            final.makeWrapper
          ];

          installPhase =
            ''
              runHook preInstall
    
              mkdir -p $out/eww-config
              cp -rf $src/* $out/eww-config

              runHook postInstall
            '';

          postInstall =
            ''
              mkdir -p $out/bin
              makeWrapper ${final.eww}/bin/eww "$out/bin/qwanve-eww" \
                --prefix PATH : ${nixpkgs.lib.makeBinPath [final.playerctl]}
            '';

          meta.mainProgram = "qwanve-eww";
        };
      };
      packages = forAllSystems (system: {
        default = self.packages.${system}.qwanve-eww;
        inherit (nixpkgsFor.${system}) qwanve-eww;
      });
      homeModules = {
        default = self.homeModules.qwanve-eww;
        qwanve-eww = {pkgs, ...}: {
          nixpkgs.overlays = [self.overlays.default];
        };
      };

    };
}
