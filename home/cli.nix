{config, pkgs, catppuccin, ...}:
{
  home.packages = [
    pkgs.fd
    pkgs.xdg-utils
    pkgs.zip
    pkgs.unzip
    pkgs.du-dust
    pkgs.file
    pkgs.bottom
  ];
  
  programs.command-not-found.enable = false;
  programs.nix-index = {
    enable = true;
    enableFishIntegration = true;
  };

  programs.fish = {
    enable = true;
    package = pkgs.fish;
    interactiveShellInit = ''
      set fish_greeting # disable greeting
      in_nix_shell
    '';
    functions = {
      in_nix_shell = {
        body = ''
          if set -q IN_NIX_SHELL
            set -g __fish_machine "<nix-shell>"
          else if echo $PATH | grep -q "/nix/store"
            set -g __fish_machine "<nix shell>"
          end
        '';
      };
    };
    shellAliases = {
      nix-shell = "nix-shell --run fish";
      cat = "bat -p";
    };
    shellAbbrs = {
      nrsf = "sudo nixos-rebuild switch --flake ~/nixos-config";
      mp = "mount /dev/disk/by-id/usb-RPI_RP2_E0C9125B0D9B-0:0-part1";
    };
  };

  programs.git = {
    enable = true;
    userEmail = "strohdaniel624@gmail.com";
    userName = "Daniel Stroh";
    extraConfig = {
      init = {
        defaultBranch = "main";
      };
    };
    difftastic.enable = true;
  };

  programs.helix = {
    enable = true;
    defaultEditor = true;
    settings = {
      theme = "catppuccin_${catppuccin.lower.theme}";
    };
  };
  programs.bat.enable = true;
  programs.ripgrep.enable = true;
  programs.eza = {
    enable = true;
    enableFishIntegration = true;
    git = true;
    extraOptions = [ "--header" ];
  };
  programs.nnn.enable = true;
  programs.zellij = {
    enable = true;
    settings = {
      default_layout = "compact";
      theme = "catppuccin-${catppuccin.lower.theme}";
    };
  };
  programs.zoxide = {
    enable = true;
    enableFishIntegration = true;
  };
}
