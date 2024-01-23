{
  description = "PapalPenguin's NixOS Flake";

  inputs = {
    kde2nix.url = "github:nix-community/kde2nix";

    nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";
    # The nixpkgs entry in the flake registry.
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable-small";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = {
    nixpkgs,
    home-manager,
    kde2nix,
    ...
  }: {
    nixosConfigurations = {
      "nixos-mulder" = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./configuration.nix
          kde2nix.nixosModules.default
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              users.dgraham = import ./home.nix;
              useUserPackages = true;
            };
          }
        ];
      };
    };
  };
}
