{ config, pkgs, ... }:
{
  imports =
[ # Include the results of the hardware scan.
	./apps/internet.nix
	./apps/utils.nix
	./apps/system.nix
];

#system.stateVersion = "23.11"; # Did you read the comment?
}

