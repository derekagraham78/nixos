{
  description = "PapalPenguin's NixOS Flake for Mulder";

  inputs = {
    nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05-small";
    # The nixpkgs entry in the flake registry.
  };
  outputs = {nixpkgs, ...}: {
    nixosConfigurations = {
      "Mulder.papalpenguin.com" = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./configuration.nix
        ];
      };
    };
  };
}
