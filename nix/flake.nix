{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    hyprland = {
      url = "github:hyprwm/Hyprland";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    wallpaper = {
      url = "https://wallpapers.hector.me/wavey/2.1/desktop/Wavey%20Rainbow.jpg";
      flake = false;
    };
  };

  outputs = {
    self,
    nixpkgs,
    hyprland,
    home-manager,
    wallpaper,
  }: let
    system = "x86_64-linux";
    lib = nixpkgs.lib;
  in {
    nixosConfigurations = {
      linus = lib.nixosSystem {
        inherit system;
        modules = [
          ./configuration.nix
          {
            nixpkgs.config.allowUnfree = true;
          }
          hyprland.nixosModules.default
          {
            programs.hyprland.enable = true;
          }
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.linus = {
              imports = [./home.nix];
            };
            home-manager.extraSpecialArgs = {
              inherit wallpaper;
            };
          }
        ];
      };
    };
  };
}
