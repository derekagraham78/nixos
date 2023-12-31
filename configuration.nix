# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{ config, lib, pkgs, ... }:

{
imports =
[                                                                       # Include the results of the hardware scan.
	./hardware-configuration.nix
]                                                                       ;
# Home Manager
users.users.dgraham.isNormalUser = true                                 ;
	users.defaultUserShell = pkgs.zsh                                      ;
	programs.zsh.enable = true                                             ;
	programs.zsh = {
# Your zsh config
	ohMyZsh = {
		enable = true                                                         ;
		plugins = [ "git" "python" "man" "1password" ]                        ;
	 	theme = "agnoster";
	 	}                                                                    ;
	}                                                                      ;
	nix.settings.experimental-features = [ "nix-command" "flakes" ]        ;
# Bootloader.
	boot.loader.systemd-boot.enable = true                                 ;
	boot.loader.efi.canTouchEfiVariables = true                            ;
	boot.kernelPackages = pkgs.linuxPackages_zen                           ;
	boot.kernelModules = [ "drivetemp" ]                                   ;
	boot.kernelParams = [ "reboot=acpi" "coretemp" ]                       ;
#systemd.watchdog.rebootTime = "15s";
	systemd.extraConfig = "DefaultTImeoutStopSec=10s";
	networking.hostName = "Mulder";                                        # Define your hostname.
#networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
# Printer
	services.printing.drivers = [pkgs.brlaser ]                            ;
	services.dbus.packages = with pkgs                                     ; [
	xfce.xfconf
	]                                                                      ;
# Configure network proxy if necessary
# networking.proxy.default = "http://user:password@proxy:port/";
# networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";
	virtualisation.docker.enable = true                                    ;
# Enable networking
	networking.networkmanager.enable = true                                ;
	networking. enableIPv6 = false; 
# Set your time zone.
	time.timeZone = "America/Chicago";
	systemd.services.backupmyconfs = {
		path = [ pkgs.zsh ]                                                   ;
		serviceConfig = {
		ExecStart = "/home/dgraham/bin/backup-confs";
		wantedBy = [ "default.target" ]                                       ;
		Type = "oneshot";
		User = "dgraham";
		}                                                                     ;
	}                                                                      ;
	systemd.timers.backupmyconfs = {
	timerConfig = {
	OnBootSec = "60m";
	OnUnitActiveSec = "60m";
	Unit = "backupmyconfs.service";
}	                                                                      ;
}                                                                       ;
services.nginx = {
  enable = true;
  virtualHosts."papalpenguin.com" = {
    enableACME = false;
    forceSSL = false;
    root = "/var/www/papalpenguin.com";
    locations."~ \\.php$".extraConfig = ''
      fastcgi_pass  unix:${config.services.phpfpm.pools.mypool.socket};
      fastcgi_index index.php;
    '';
  };
};
services.mysql = {
  enable = true;
  package = pkgs.mariadb;
};
services.phpfpm.pools.mypool = {                                                                                                                                                                                                             
  user = "nobody";                                                                                                                                                                                                                           
  settings = {                                                                                                                                                                                                                               
    "pm" = "dynamic";            
    "listen.owner" = config.services.nginx.user;                                                                                                                                                                                                              
    "pm.max_children" = 5;                                                                                                                                                                                                                   
    "pm.start_servers" = 2;                                                                                                                                                                                                                  
    "pm.min_spare_servers" = 1;                                                                                                                                                                                                              
    "pm.max_spare_servers" = 3;                                                                                                                                                                                                              
    "pm.max_requests" = 500;                                                                                                                                                                                                                 
  };                    
# Select internationalisation properties.
	i18n.defaultLocale = "en_US.UTF-8";
	i18n.extraLocaleSettings = {
	LC_ADDRESS = "en_US.UTF-8";
	LC_IDENTIFICATION = "en_US.UTF-8";
	LC_MEASUREMENT = "en_US.UTF-8";
	LC_MONETARY = "en_US.UTF-8";
	LC_NAME = "en_US.UTF-8";
	LC_NUMERIC = "en_US.UTF-8";
	LC_PAPER = "en_US.UTF-8";
	LC_TELEPHONE = "en_US.UTF-8";
	LC_TIME = "en_US.UTF-8";
	}                                                                      ;
# Enable the X11 windowing system.
	services.xserver.desktopManager.plasma6.enable = true                  ;
	services.xserver.enable = true                                         ;
	services.flatpak.enable = true                                         ;
	xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ]              ;
	xdg.portal.config.common.default = "gtk";
# Enable the KDE Plasma Desktop Environment.
	services.xserver.displayManager.lightdm.enable = true                  ;

# Configure keymap in X11
	services.xserver = {
		layout = "us";
	 	}                                                                    ;
# Enable CUPS to print documents.
	services.printing.enable = true                                        ;
	services.fwupd.enable = true                                           ;
	services.avahi.nssmdns4 = {
		enable = true                                                         ;
		nssmdns = true                                                        ;
		openFirewall = true                                                   ;
		}                                                                     ;
	nixpkgs.config.permittedInsecurePackages = [ "python-2.7.18.7" ]       ;
# Enable sound with pipewire.
	sound.enable = true                                                    ;
	hardware.pulseaudio.package = pkgs.pulseaudioFull                      ;
	hardware.pulseaudio.enable = true                                      ;
	hardware.pulseaudio.extraConfig = "load-module module-equalizer-sink";
	nixpkgs.config.pulseaudio = true                                       ;
	programs.dconf.enable = true                                           ;
	security.rtkit.enable = true                                           ;
	services.pipewire = {
		enable = false                                                        ;
		alsa.enable = true                                                    ;
		alsa.support32Bit = true                                              ;
		pulse.enable = true                                                   ;
# If you want to use JACK applications, uncomment this
		jack.enable = true                                                    ;
	}                                                                      ;
fonts.packages = with pkgs; [
  rPackages.trekfont
  noto-fonts
  noto-fonts-cjk
  noto-fonts-emoji
  liberation_ttf
  fira-code
  nginx
  fira-code-symbols
  mplus-outline-fonts.githubRelease
  dina-font
  proggyfonts
];
# Enable touchpad support (enabled default in most desktopManager).
	services.xserver.libinput.enable = true                                ;
	hardware.opengl = {
		enable = true                                                         ;
# Enable 32-bit dri support for steam
		driSupport32Bit = true                                                ;
		extraPackages32 = with pkgs.intel-vaapi-driver                        ; [ ];
		setLdLibraryPath = true                                               ;
	}                                                                      ;
# Define a user account. Don't forget to set a password with ‘passwd’.
	users.users.dgraham = {
	description = "Derek Graham";
	extraGroups = [ "networkmanager" "rslsync" "docker" "wheel" "video" ]  ;
	packages = with pkgs                                                   ; [
	kate
]                                                                       ;
}                                                                       ;
# Auto Upgrade
	system.autoUpgrade = {
		enable = true                                                         ;
		flake = "/etc/nixos#papalpenguin";
		flags = [
			"--update-input"
			"nixpkgs"
			"-L"                                                                 # print build logs
		]                                                                     ;
		dates = "02:00";
		randomizedDelaySec = "45min";
	}                                                                      ;
# Enable automatic login for the user.
	services.xserver.displayManager.autoLogin.enable = true                ;
	services.xserver.displayManager.autoLogin.user = "dgraham";
	services.xserver.displayManager.defaultSession = "plasmax11";
# Allow unfree packages
	nixpkgs.config.allowUnfree = true                                      ;
# List packages installed in system profile. To search, run:
# $ nix search wget
	environment.systemPackages = with pkgs                                 ; [
# Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
		git
		wget
		php-fpm
		gh
		xscreensaver
		neofetch
		bluez-tools
		dmidecode
		doas
		file
		bluez
		hddtemp
		ipmitool
		mdadm
		lm_sensors
		smartmontools
		tree
		anydesk
		glxinfo
		wmctrl
		xorg.xdpyinfo
		xwayland
		usbutils
		zip
		xz
		unzip
		p7zip
# utils
		ripgrep                                                                # recursively searches directories>
		jq                                                                     # A lightweight and flexible command-li>
		yq-go                                                                  # yaml processer https://github.com/>
	 	fzf                                                                   # A command-line fuzzy finde
# networking tools
		mtr                                                                    # A network diagnostic tool
		iperf3
		dnsutils                                                               # `dig` + `nslookup`
		ldns                                                                   # replacement of `dig`, it provide th>
		aria2                                                                  # A lightweight multi-protocol & mul>
		socat                                                                  # replacement of openbsd-netcat
	nmap                                                                   # A utility for network discovery and>
	 ipcalc                                                                # it is a calculator for the IPv4/>
# misc
	 cowsay
	file
	which
	tree
	 gnused
	gnutar
	 gawk
	zstd
	 gnupg
# nix related
#
# it provides the command `nom` works just lik>
# with more details log output
	 nix-output-monitor
# productivity
	hugo                                                                   # static site generator
	glow                                                                   # markdown previewer in terminal
	btop                                                                   # replacement of htop/nmon
	 iotop                                                                 # io monitoring
	 iftop                                                                 # network monitoring		
# system call monitoring
	 strace                                                                # system call monitoring
	ltrace                                                                 # library call monitoring
	 lsof                                                                  # list open files
# system tools
	 sysstat
	lm_sensors                                                             # for `sensors` command
	ethtool
	 pciutils                                                              # lspci
	 usbutils                                                              # lsusb
	 gh
	vivaldi-ffmpeg-codecs
	 xfce.thunar
	xfce.thunar-volman
	 xfce.thunar-archive-plugin
	xfce.thunar-media-tags-plugin
	 stacer
	digikam
	 _1password-gui
	cpu-x
		wireshark
	 variety
	 libreoffice-qt
	libsForQt5.qt5.qtwayland
	 vim
		vscode
		fmt
	 telegram-desktop
	betterdiscordctl
	 discord
	betterdiscord-installer
	 vlc
	nodejs_latest
	 xscreensaver
	 kitty
	 kitty-img
	 kitty-themes
	 yarn2nix
	 yarn
		moc
	qt6.qt5compat
	qt6.wrapQtAppsHook
	 qt6.qttools
	pkgs.qt6.full
	 qt6.qtwayland
	pkgs.nodePackages_latest.pnpm
	 libuvc
	pkgs.usbutils
	 freetype
	libmediainfo
	 fontconfig
	gnumake
	 gcc13
	resilio-sync
	 xorg.libxcb
		python311Packages.qpageview
	libsForQt5.qt5.wrapQtAppsHook
		paprefs
		pasystray
		pavucontrol
		fmt
		pciutils
		geekbench
		inxi
		rPackages.trekfont
	]                                                                      ;
# Some programs need SUID wrappers, can be configured further or are
# started in user sessions.
	programs.mtr.enable = true                                             ;
	programs.gnupg.agent = {
		enable = true                                                         ;
	}                                                                      ;
# List services that you want to enable:
# services.httpd.enable = true;
# Enable the OpenSSH daemon.
	services.openssh.enable = true                                         ;
	services.openssh.settings.PermitRootLogin = "yes";
# Open ports in the firewall.
# networking.firewall.allowedTCPPorts = [ 8581 ];
# networking.firewall.allowedUDPPorts = [ 8581 ];
# Or disable the firewall altogether.
	networking.firewall.enable = false                                     ;
# This value determines the NixOS release from which the default
# settings for stateful data, like file locations and database versions
# on your system were taken. It‘s perfectly fine and recommended to leave
# this value at the release version of the first install of this system.
# Before changing this value read the documentation for this option
# (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).

system.stateVersion = "23.11"; # Did you read the comment?
}
