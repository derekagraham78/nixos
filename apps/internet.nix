{ pkgs, ... }:
{
 environment.systemPackages = with pkgs; [
	vivaldi
	telegram-desktop
	betterdiscordctl
	discord
	betterdiscord-installer
	vlc
	signal-desktop
];

system.stateVersion = "23.11"; # Did you read the comment?
}
