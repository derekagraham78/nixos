{
description = "PapalPenguin's NixOS Flake";

# Inputs
# https://nixos.org/manual/nix/unstable/command-ref/new-cli/nix3-flake.html#flake-inputs
inputs = {
hyprland.url = "github:hyprwm/Hyprland";
    hyprpaper = {
        url = "github:hyprwm/hyprpaper";
        inputs.hyprland.follows = "hyprland"; # IMPORTANT
    };
	hyprload = {
 		url = "github:duckonaut/hyprload";
 		inputs.hyprland.follows = "hyprland"; # IMPORTANT
	};
	kde2nix.url = "github:nix-community/kde2nix";
helix.url = "github:helix-editor/helix/23.10";
# The nixpkgs entry in the flake registry.
nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
home-manager = {
url = "github:nix-community/home-manager";
inputs.nixpkgs.follows = "nixpkgs";
wayland.windowManager.hyprland = {
    plugins = [
	inputs.hyprpaper
    ];
  };
}                                                                                ;
#home-manager.users.dgraham.service
}                                                                                ;
inputs.nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";
outputs = { self, nixpkgs, home-manager, kde2nix, ... }@inputs: {
# Used with `nixos-rebuild --flake .#<hostname>`
# nixosConfigurations."<hostname>".config.system.build.toplevel must be>
nixosConfigurations = {
"nixos-mulder" = nixpkgs.lib.nixosSystem {
system = "x86_64-linux";
specialArgs = inputs                                                             ;
modules = [
./configuration.nix
kde2nix.nixosModules.default
	# make home-manager as a module of nixos
	# so that home-manager configuration will be deployed automatically when executing `nixos-rebuild switch`
home-manager.nixosModules.home-manager
{
home-manager.useGlobalPkgs = true                                                ;
home-manager.useUserPackages = true                                              ;
home-manager.users.dgraham = import ./home.nix                                   ;
# Optionally, use home-manager.extraSpecialArgs to pass arguments to home.nix
}
]                                                                                ;
}                                                                                ;
}                                                                                ;
}                                                                                ;
}
