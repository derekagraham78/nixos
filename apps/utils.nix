{pkgs, ... }:
{
environment.systemPackages = with pkgs; [
	neofetch
	xfce.thunar
	xfce.thunar-volman
	xfce.thunar-archive-plugin
	xfce.thunar-media-tags-plugin
	stacer
	digikam
	_1password-gui
	cpu-x
	inxi
	wireshark
	variety
	teamviewer
	libreoffice-qt
	vim
	vscode-with-extensions
];

system.stateVersion = "23.11"; # Did you read the comment?
}
