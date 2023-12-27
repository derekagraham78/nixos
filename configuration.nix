# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
	./hardware-configuration.nix
    ];
# Home Manager
users.users.dgraham.isNormalUser = true;
	users.defaultUserShell = pkgs.zsh;
	programs.zsh.enable = true; 
	programs.zsh = {
	  # Your zsh config
	 ohMyZsh = {
	    enable = true;
	    plugins = [ "git" "python" "man" "1password" ];
	    theme = "agnoster";
	  };
	}; 
 nix.settings.experimental-features = [ "nix-command" "flakes" ];
  # Bootloader.
	boot.loader.systemd-boot.enable = true;
	boot.loader.efi.canTouchEfiVariables = true;
	boot.kernelPackages = pkgs.linuxPackages_zen;
	boot.kernelModules = [ "drivetemp" "
	boot.kernelParams = [ "reboot=acpi" "coretemp" ];
	#systemd.watchdog.rebootTime = "15s";
	systemd.extraConfig = "DefaultTImeoutStopSec=10s";
	networking.hostName = "Mulder"; # Define your hostname.
	#networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
	# Printer
  	services.printing.drivers = [pkgs.brlaser ]; 
	services.dbus.packages = with pkgs; [
  	xfce.xfconf
  	];
  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";
    virtualisation.docker.enable = true;
  # Enable networking
    networking.networkmanager.enable = true;
	
  # Set your time zone.
    time.timeZone = "America/Chicago";
systemd.services.backupmyconfs = {
   path = [ pkgs.zsh  ];
   serviceConfig = {
       ExecStart = "/home/dgraham/bin/backup-confs";
       wantedBy = [ "default.target" ];
       Type = "oneshot";
       User = "dgraham";
       };
};
systemd.timers.backupmyconfs = {
    timerConfig = {
        OnBootSec = "60m";
        OnUnitActiveSec = "60m";
        Unit = "backupmyconfs.service";
        };
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
  };
    services.xserver.desktopManager.plasma6.enable = true;
  # Enable the X11 windowing system.
    services.xserver.enable = true;
    services.flatpak.enable = true;
    xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    xdg.portal.config.common.default = "gtk";
  # Enable the KDE Plasma Desktop Environment.
    services.xserver.displayManager.sddm.enable = true;

  # Configure keymap in X11
    services.xserver = {
      layout = "us";
      xkbVariant = "";
    };

  # Enable CUPS to print documents.
    services.printing.enable = true;
    services.fwupd.enable = true;
    services.avahi.nssmdns4  = {
    enable = true;
    nssmdns = true;
    openFirewall = true;
  };
    nixpkgs.config.permittedInsecurePackages = [
      "python-2.7.18.7"
              ];
  # Enable sound with pipewire.
    sound.enable = true;
    hardware.pulseaudio.package = pkgs.pulseaudioFull;
    hardware.pulseaudio.enable = true;
    hardware.pulseaudio.extraConfig = "load-module module-equalizer-sink";
    nixpkgs.config.pulseaudio = true;
    programs.dconf.enable = true;
    security.rtkit.enable = true;
    services.pipewire = {
      enable = false;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
  # If you want to use JACK applications, uncomment this
    jack.enable = true;
    };

  # Enable touchpad support (enabled default in most desktopManager).
   services.xserver.libinput.enable = true;
 hardware.opengl = {
    enable = true;
# Enable 32-bit dri support for steam
    driSupport32Bit = true;
    extraPackages32 = with pkgs.intel-vaapi-driver; [ ];
    setLdLibraryPath = true;
  };

# Define a user account. Don't forget to set a password with ‘passwd’.
	users.users.dgraham = {
#   isNormalUser = true;
 	description = "Derek Graham";
 	extraGroups = [ "networkmanager" "rslsync" "docker" "wheel"  "video" ];
 	packages = with pkgs; [
 	kate
      ];
  };
# Auto Upgrade
system.autoUpgrade = {
  enable = true;
  flake = "/etc/nixos#papalpenguin";
  flags = [
    "--update-input"
    "nixpkgs"
    "-L" # print build logs
  ];
  dates = "02:00";
  randomizedDelaySec = "45min";
};

# Enable automatic login for the user.
  services.xserver.displayManager.autoLogin.enable = true;
  services.xserver.displayManager.autoLogin.user = "dgraham";
  services.xserver.displayManager.defaultSession = "plasma";
# Allow unfree packages
  nixpkgs.config.allowUnfree = true;

# List packages installed in system profile. To search, run:
# $ nix search wget
  environment.systemPackages = with pkgs; [
# Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
	git
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
	sysvinit
	lmsensors
	smartmontools
	tree
	glxinfo
	wmctrl
	xorg.xdpyinfo

	xwayland
	usbutils
	paprefs
	pasystray
	pavucontrol
	pciutils
	geekbench
	inxi
];
# Some programs need SUID wrappers, can be configured further or are
# started in user sessions.
  programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    #enableSSHSupport = true;
  };

# List services that you want to enable:
  #services.httpd.enable = true;

# Enable the OpenSSH daemon.
  services.openssh.enable = true;
  services.teamviewer.enable = true;
# Open ports in the firewall.
  #networking.firewall.allowedTCPPorts = [ 8581 ];
  #networking.firewall.allowedUDPPorts = [ 8581 ];
# Or disable the firewall altogether.
  networking.firewall.enable = false;

# This value determines the NixOS release from which the default
# settings for stateful data, like file locations and database versions
# on your system were taken. It‘s perfectly fine and recommended to leave
# this value at the release version of the first install of this system.
# Before changing this value read the documentation for this option
# (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
 
system.stateVersion = "23.11"; # Did you read the comment?
}
