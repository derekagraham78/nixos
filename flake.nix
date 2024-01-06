{
  description = "PapalPenguin's NixOS Flake";

  inputs = {
    hyprland.url = "github:hyprwm/Hyprland";
    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
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
    ...
  } @ inputs: {
    nixosConfigurations = {
      "nixos-mulder" = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = inputs;
        modules = [
          ./configuration.nix

          home-manager.nixosModules.home-manager
          {pkgs, ... }: {
            
              # ...
              plugins = [
                inputs.hyprland-plugins.packages.${pkgs.system}.hyprload
                inputs.hyprland-plugins.packages.${pkgs.system}.split-monitor-workspaces
                inputs.hyprland-plugins.packages.${pkgs.system}.hyprNStack
                inputs.hyprland-plugins.packages.${pkgs.system}.hyprRiver
                inputs.hyprland-plugins.packages.${pkgs.system}.hyprfocus
                inputs.hyprland-plugins.packages.${pkgs.system}.hyprland-dwindle-autogroup
                inputs.hyprland-plugins.packages.${pkgs.system}.hyprland-virtual-desktops
                inputs.hyprland-plugins.packages.${pkgs.system}.Hypr-DarkWindow
                inputs.hyprland-plugins.packages.${pkgs.system}.hyprtrails

                inputs.hyprland-plugins.packages.${pkgs.system}.hyprbars
                # ...
              ];
            };
            home-manager.useGlobalPkgs = true;
            home-manager.users.dgraham = import ./home.nix;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = {inherit inputs;};
          }
        ];
      };
    };
  };
}
