# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./mysql.nix
    ./wordpress.nix
    ./vscode.nix
    ./cachix.nix
  ];
  vscode = { 
    user = "dgraham";
    homeDir = "/home/dgraham";
    extensions = with pkgs.vscode-extensions; [ ms-vscode.cpptools ];
    };
  # Home Manager
  programs = {
    zsh = { 
      enable = true;
    # Your zsh config
    ohMyZsh = {
      enable = true;
      plugins = ["git" "python" "man" "1password"];
      theme = "agnoster";
    };
  };
  sway.enable = true;
  dconf.enable = true;
  mtr.enable = true;
  xfconf.enable = true;
  gnupg.agent = {
    enable = true;
  };
  nm-applet.enable = true;

};
  nix.settings.experimental-features = ["nix-command" "flakes"];
  # Bootloader.
  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    kernelPackages = pkgs.linuxPackages_zen;
    kernelModules = ["drivetemp"];
    kernelParams = ["reboot=acpi" "coretemp"];
  };
  systemd = {
    extraConfig = "DefaultTimeoutStopSec=10s";
  services.backupmyconfs = {
    path = [pkgs.zsh];
    serviceConfig = {
      ExecStart = "/home/dgraham/bin/check4update";
      wantedBy = ["default.target"];
  Type = "oneshot";
  User = "dgraham";
    };
  };
  timers.backupmyconfs = {
    timerConfig = {
      OnBootSec = "60m";
      OnUnitActiveSec = "60m";
      Unit = "backupmyconfs.service";
    };
  };

  };
  networking = {
    hostName = "Mulder"; # Define your hostname.
    firewall.enable = false;
  networkmanager.enable = true;
  enableIPv6 = false;

};
  #networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  # Printer
  services = {
  fwupd.enable = true;
  avahi.nssmdns4 = {
    enable = true;
    nssmdns = true;
    openFirewall = true;
    };
    xrdp.enable = true;
    printing.drivers = [pkgs.brlaser];
    dbus.packages = with pkgs; [
    xfce.xfconf
  ];
  plex = {
    enable = true;
    openFirewall = true;
    #dataDir = "/var/plex";
  };
  gvfs.enable = true; # Mount, trash, and other functionalities
  tumbler.enable = true; # Thumbnail support for images
  security = {
    pam.services.swaylock.fprintAuth = false;
    acme = {
      acceptTerms = true;
      defaults.email = "derek@papalpenguin.com";
    };
  rtkit.enable = true;
  };
  nginx = {
    enable = true;
    defaultSSLListenPort = 443;
    virtualHosts."papalpenguin.com" = {
      enableACME = true;
      forceSSL = true;
      serverAliases = ["www.papalpenguin.com"];
    };
  };  
  phpfpm.pools.mypool = {
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
   };
   flatpak.enable = true;
     layout = "us";
   };
  printing.enable = true;
 pipewire = {
    enable = false;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
 # If you want to use JACK applications, uncomment this
    jack.enable = true;
  };
  xserver = { 
   xkb.model = "Logitech K270";
   xserver = {
     layout = "us";
     };
    enable = true;
    libinput.enable = true;
    displayManager = { 
      defaultSession = "plasmax11";
      sddm = {
        enable = true;
        wayland.enable = true;
        autoNumlock = true;
      autoLogin = { 
        enable = true;
        user = "dgraham";
        };
      };
    };
    desktopManager.plasma6.enable = true;
  };
# List services that you want to enable:
  # services.httpd.enable = true;
  # Enable the OpenSSH daemon.
  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";
  virtualisation.docker.enable = true;
  # Enable networking
  # Set your time zone.
  time.timeZone = "America/Chicago";
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
  # Enable the X11 windowing system.
  #  xdg.portal.enable = true;
  #  xdg.portal.config.common.default = ["kde" "gtk"];

  # Configure keymap in X11
  # Enable CUPS to print documents.
  # Enable sound with pipewire.
  sound.enable = true;
  hardware = {
    pulseaudio = {
      package = pkgs.pulseaudio;
      enable = true;
      extraConfig = "load-module module-equalizer-sink";
    };
  };
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
  hardware.opengl = {
    enable = true;
    # Enable 32-bit dri support for steam
    driSupport32Bit = true;
    extraPackages32 = with pkgs.intel-vaapi-driver; [];
    setLdLibraryPath = true;
  };
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users = { 
    dgraham = {
      description = "Derek Graham";
      extraGroups = ["plex" "networkmanager" "rslsync" "docker" "wheel" "video"];
      isNormalUser = true;
      packages = with pkgs; [
        kate
        ];
      };
    defaultUserShell = pkgs.zsh;
  };
  # Auto Upgrade
  system.autoUpgrade = {
    enable = true;
    flake = "github:derekagraham78/nixos/flake.nix";
    flags = [
      "--update-input"
      "nixpkgs"
      "-L" # print build logs
    ];
    dates = "02:00";
    randomizedDelaySec = "45min";
  };
  # Bluetooth Enabled
  hardware.bluetooth.enable = true;
  # Enable automatic login for the user.
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  # List packages installed in system profile. To search, run:
  # $ nix search wget

  environment.systemPackages = with pkgs; [
    # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    slack
    cachix
    nix-linter
    statix
    wev
    imagemagick
    w3m
    ox
    floorp
    deluge-gtk
    gnome.nautilus
    nautilus-open-any-terminal
    gnome.sushi
    gwenview
    dmenu-rs
    clipmenu
    emojipick
    wev
    killall
    grim #screes capture
    slurp
    swaylock-effects
    swayidle
    pavucontrol
    pasystray
    paprefs
    patray
    noisetorch
    volctl
    rofi-pulse-select
    rofi-wayland
    element-desktop
    vscode
    git
    wget
    gh
    neofetch
    fastfetch
    libsixel
    anydesk
    file
    hddtemp
    ipmitool
    mdadm
    smartmontools
    tree
    glxinfo
    wmctrl
    xorg.xdpyinfo
    wayland
    usbutils
    zip
    xz
    unzip
    p7zip
    # utils
    ripgrep # recursively searches directories>
    wp4nix
    swaybg
    gimp-with-plugins
    jq # A lightweight and flexible command-li>
    dunst
    # networking tools
    nm-tray
    networkmanager
    networkmanagerapplet
    networkmanager_dmenu
    mtr # A network diagnostic tool
    iperf3
    dnsutils # `dig` + `nslookup`
    ldns # replacement of `dig`, it provide th>
    aria2 # A lightweight multi-protocol & mul>
    socat # replacement of openbsd-netcat
    nmap # A utility for network discovery and>
    ipcalc # it is a calculator for the IPv4/>
    # misc
    alejandra
    php
    phpPackages.composer
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
    hugo # static site generator
    glow # markdown previewer in terminal
    btop # replacement of htop/nmon
    iotop # io monitoring
    iftop # network monitoring
    # system call monitoring
    strace # system call monitoring
    ltrace # library call monitoring
    lsof # list open files
    # system tools
    inotify-tools
    sysstat
    lm_sensors # for `sensors` command
    ethtool
    pciutils # lspci
    usbutils # lsusb
    gh
    vivaldi
    vivaldi-ffmpeg-codecs
    webp-pixbuf-loader
    poppler
    ffmpegthumbnailer
    evince
    mcomix
    xfce.tumbler
    stacer
    digikam
    _1password-gui
    cpu-x
    wireshark
    variety
    vim
    fmt
    telegram-desktop
    grimblast
    discord
    vlc
    nodejs_latest
    kitty
    kitty-img
    kitty-themes
    yarn2nix
    rustdesk
    rustdesk-server
    yarn
    moc
    qt6.qt5compat
    pkgs.qt6.full
    libsForQt5.full
    xorg.xcbutil
    pkgs.nodePackages_latest.pnpm
    pkgs.usbutils
    freetype
    fontconfig
    gnumake
    gcc13
    waybar
    resilio-sync
    #    python311Packages.qpageview
    fmt
    pciutils
    geekbench
    inxi
    rPackages.trekfont
  ];
  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ 8581 ];
  # networking.firewall.allowedUDPPorts = [ 8581 ];
  # Or disable the firewall altogether.
  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).

  system.stateVersion = "23.11"; # Did you read the comment?
}
