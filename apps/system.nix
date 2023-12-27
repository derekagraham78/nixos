{pkgs, ... }:
{
environment.systemPackages = with pkgs; [
	nodejs_latest
	xscreensaver
	kitty
	kitty-img
	kitty-themes
	yarn2nix
	yarn
	moc
	qt6.qt5compat
	qt6.qtsvg
	pkgs.qt6.full
	python3Full
	pkgs.nodePackages_latest.pnpm
	libuvc
	pkgs.usbutils
	freetype
	libmediainfo
	fontconfig
	gnumake
	gcc13
	pkgs.python311Packages.ninja
	pkgs.python311Packages.pip
	xorg.libxcb
	perl538Packages.X11XCB
	pkgs.python311Packages.pillow
	pkgs.python311Packages.dbus-python
	pkgs.python311Packages.meson-python
];

system.stateVersion = "23.11"; # Did you read the comment?
}
