{
  description = "PapalPenguin's NixOS Flake";

  inputs = {
    hyprland.url = "github:hyprwm/Hyprland";
    hyprbars = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland"; # IMPORTANT
    };
    nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";
    # The nixpkgs entry in the flake registry.
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = {
    nixpkgs,
    home-manager,
    hyprland,
    ...
  }: {
    nixosConfigurations = {
      "nixos-mulder" = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./configuration.nix
          home-manager.nixosModules.home-manager
          hyprland.homeManagerModules.default

          # ...

          {
            home-manager.useGlobalPkgs = true;
            home-manager.users.dgraham = import ./home.nix;
            home-manager.useUserPackages = true;
          }
        ];
      };
    };
  };
}
