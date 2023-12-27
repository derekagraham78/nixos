{
  description = "PapalPenguin's NixOS Flake";

  # Inputs
  # https://nixos.org/manual/nix/unstable/command-ref/new-cli/nix3-flake.html#flake-inputs
 inputs = {
 	kde2nix.url = "github:nix-community/kde2nix";
  # The flake in the current directory.
  # inputs.currentDir.url = ".";
helix.url = "github:helix-editor/helix/23.10";
#inputs.home-manager.nixosModules.home-manager
  # A flake in some other directory.
  # inputs.otherDir.url = "/home/alice/src/patchelf";

  # A flake in some absolute path
  # inputs.otherDir.url = "path:/home/alice/src/patchelf";

  # The nixpkgs entry in the flake registry.
  nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  #inputs.nixos-channel.url = "https://nixos.org/channels/nixos-unstable/nixexprs.tar.xz";
home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
}; 

  # A GitHub repository.
#  inputs.import-cargo = {
#    type = "github";
#    owner = "edolstra";
#    repo = "import-cargo";
#  };

  # Inputs as attrsets.
  # An indirection through the flake registry.
#  inputs.nixpkgsIndirect = {
#    type = "indirect";
#    id = "nixpkgs";
#  };


  # Transitive inputs can be overridden from a flake.nix file. For example, the following overrides the nixpkgs input of the nixops input:
 # inputs.nixops.inputs.nixpkgs = {
 #   type = "github";
 #   owner = "NixOS";
 #   repo = "nixpkgs";
 # };

  # It is also possible to "inherit" an input from another input. This is useful to minimize
  # flake dependencies. For example, the following sets the nixpkgs input of the top-level flake
  # to be equal to the nixpkgs input of the nixops input of the top-level flake:
 # inputs.nixpkgs.url = "nixpkgs";
 # inputs.nixpkgs.follows = "nixops/nixpkgs";

  # The value of the follows attribute is a sequence of input names denoting the path
  # of inputs to be followed from the root flake. Overrides and follows can be combined, e.g.
  #inputs.nixops.url = "nixops";
 # inputs.dwarffs.url = "dwarffs";
 # inputs.dwarffs.inputs.nixpkgs.follows = "nixpkgs";

  outputs = { self, nixpkgs, home-manager, kde2nix, ... }@inputs: {
 # Used with `nixos-rebuild --flake .#<hostname>`
 # nixosConfigurations."<hostname>".config.system.build.toplevel must be>
    nixosConfigurations = {
    "nixos-mulder" = nixpkgs.lib.nixosSystem {
 system = "x86_64-linux";
 specialArgs = inputs;
 modules = [
./configuration.nix
kde2nix.nixosModules.default
# make home-manager as a module of nixos
          # so that home-manager configuration will be deployed automatically when executing `nixos-rebuild switch`
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            # TODO replace ryan with your own username
            home-manager.users.dgraham = import ./home.nix;

            # Optionally, use home-manager.extraSpecialArgs to pass arguments to home.nix
          }
        ];
};
};
};
}
