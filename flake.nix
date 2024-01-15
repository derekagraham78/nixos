{
  description = "PapalPenguin's NixOS Flake";

  inputs = {
    nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";
    # The nixpkgs entry in the flake registry.
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
   kde2nix.url = kde2nix.url = "github:nix-community/kde2nix";

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
            home-manager.useGlobalPkgs = true;
            home-manager.users.dgraham = import ./home.nix;
            home-manager.useUserPackages = true;
          }
        ];
      };
    };
  };
}
