# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./mysql.nix
    ./vscode.nix
    ./nginx.nix
  ];
  nix = {
    settings.experimental-features = ["nix-command" "flakes"];
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };
    optimise = {
      automatic = true;
      dates = ["03:45"]; # Optional; allows customizing optimisation schedule
    };
  };
  vscode = {
    user = "dgraham";
    homeDir = "/home/dgraham";
    extensions = with pkgs.vscode-extensions; [ms-vscode.cpptools];
  };
  # Home Manager
  programs = {
    neovim = {
      enable = true;
      defaultEditor = true;
    };
    git = {
      enable = true;
      #  userName = "derekagraham78";
      #  userEmail = "derekagraham78@icloud.com";
    };
    zsh = {
      enable = true;
      # Your zsh config
      ohMyZsh = {
        enable = true;
        plugins = ["git" "python" "man" "1password"];
        theme = "aussiegeek";
      };
    };
    dconf.enable = true;
    mtr.enable = true;
    xfconf.enable = true;
    nm-applet.enable = true;
  };
  # Bootloader.
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };
  boot.kernelModules = ["drivetemp"];
  boot.kernelParams = ["reboot=acpi" "coretemp"];
  networking = {
    hostName = "Mulder"; # Define your hostname.
    nameservers = ["100.100.100.100" "8.8.8.8" "1.1.1.1"];
    search = ["tail20553.ts.net"];
    firewall = {
      enable = true;
      allowedTCPPorts = [21 57796 80 443 8181 3306 8000 8095 8123 1220 6969 8081 26648 9090 8080 3389 51820 51827 32400 5901 5938 8581 43148 8888 23421 50707 51578 5580];
      allowedTCPPortRanges = [
        {
          from = 20000;
          to = 28000;
        }
        {
          from = 51000;
          to = 59000;
        }
      ];
      allowedUDPPorts = [1900 1901 137 136 138 41641 3478 21063 5353];
      trustedInterfaces = ["tailscale0"];
    };
    networkmanager.enable = true;
    enableIPv6 = true;
  };
  #networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  # Printer
  services = {
    emacs = {
      enable = true;
      package = pkgs.emacs;
    };
    resolved = {
      enable = true;
      dnssec = "true";
      domains = ["~."];
      fallbackDns = ["1.1.1.1#one.one.one.one" "1.0.0.1#one.one.one.one"];
      dnsovertls = "true";
    };
    tailscale = {
      enable = true;
    };
    vsftpd = {
      enable = true;
      writeEnable = true;
      localUsers = true;
      userlist = ["dgraham" "root" "nginx"];
      userlistEnable = true;
      virtualUseLocalPrivs = true;
    };
    memcached.enable = true;
    avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };

    certmgr.renewInterval = "30m";
    displayManager = {
      defaultSession = "plasmax11";
      sddm = {
        enable = true;
        wayland.enable = true;
        autoNumlock = true;
      };
      autoLogin = {
        enable = true;
        user = "dgraham";
      };
    };
    cockpit = {
      enable = true;
      port = 9090;
      settings = {
        WebService = {
          Origins = "https://www.papalpenguin.com:9090 https://papalpenguin.com:9090 http://www.papalpenguin.com:9090 http://papalpenguin.com:9090 https://192.168.4.60:9090 http://192.168.4.60:9090 ws://192.168.4.60:9090 ws://papalpenguin.com:9090 ws://www.papalpenguin.com:9090 http://mulder.tail20553.ts.net:9090 https://mulder.tail20553.ts.net:9090";
          ProtocolHeader = "X-Forwarded-Proto";
          ForwardedForHeader = "X-Forwarded-For";
          AllowUnencrypted = true;
        };
      };
    };
    desktopManager.plasma6.enable = true;
    openssh = {
      enable = true;
      openFirewall = false;
      settings = {
        PermitRootLogin = "yes";
        AllowGroups = ["wheel" "root"];
      };
      allowSFTP = true;
    };
    flatpak.enable = true;
    printing.enable = true;
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = false;
      # If you want to use JACK applications, uncomment this
      jack.enable = true;
    };
    fwupd.enable = true;
    xrdp.enable = true;
    printing.drivers = [pkgs.brlaser];
    plex = {
      enable = true;
      openFirewall = true;
    };
    libinput.enable = true;

    xserver = {
      xkb.model = "Lo	gitech K270";
      enable = true;
    };
  };
  # List services that you want to enable:
  systemd = {
    extraConfig = "DefaultTimeoutStopSec=10s";
  };
  security = {
    rtkit.enable = true;
    acme = {
      acceptTerms = true;
      defaults.email = "derek@papalpenguin.com";
      defaults.renewInterval = "daily";
    };
    doas = {
      enable = true;
      wheelNeedsPassword = false;
    };
    sudo = {
      enable = true;
      wheelNeedsPassword = false;
    };
  };
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
  xdg.portal.enable = true;
  xdg.portal.config.common.default = ["kde" "gtk"];
  systemd.services.ownership = {
    path = [pkgs.zsh];
    serviceConfig = {
      ExecStart = "/root/bin/ownership-update";
      wantedBy = ["default.target"];
      Type = "oneshot";
      User = "root";
    };
  };
  systemd.timers.ownership = {
    timerConfig = {
      OnBootSec = "15m";
      OnUnitActiveSec = "15m";
      Unit = "ownership.service";
    };
  };

  systemd.services.backupmyconfs = {
    path = [pkgs.zsh];
    serviceConfig = {
      ExecStart = "/home/dgraham/bin/check4update";
      wantedBy = ["default.target"];
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
  # Configure keymap in X11
  # Enable CUPS to print documents.
  # Enable sound with pipewire.
  sound.enable = true;
  hardware = {
    pulseaudio = {
      package = pkgs.pulseaudio;
      enable = false;
      extraConfig = "load-module module-equalizer-sink";
    };
  };

  fonts.packages = with pkgs; [
    rPackages.trekfont
    noto-fonts
    noto-fonts-cjk
    (nerdfonts.override {fonts = ["JetBrainsMono"];})
    terminus-nerdfont
    udev-gothic-nf
    powerline-fonts
    noto-fonts-emoji
    liberation_ttf
    fira-code
    nginx
    fira-code-symbols
    mplus-outline-fonts.githubRelease
    dina-font
    proggyfonts
  ];
  console = {
    earlySetup = true;
    packages = with pkgs; [
      nerdfonts
      terminus_font
      (nerdfonts.override {fonts = ["JetBrainsMono"];})
      terminus-nerdfont
    ];
    keyMap = "us";
  };
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
    users.dgraham = {
      description = "Derek Graham";
      extraGroups = ["plex" "networkmanager" "rslsync" "docker" "wheel" "video"];
      isNormalUser = true;
      home = "/home/dgraham";
    };
    users.nginx = {
      description = "nginx";
      extraGroups = ["nginx" "networkmanager" "docker" "wheel"];
      isSystemUser = true;
      password = "098825";
      home = "/var/www/papalpenguin.com";
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
    wineWowPackages.stable
    wine
    (wine.override {wineBuild = "wine64";})
    wine64
    wineWowPackages.staging
    winetricks
    wineWowPackages.waylandFull
    emacs
    helix
    micro
    filezilla
    microsoft-edge
    altserver-linux
    vivaldi
    vivaldi-ffmpeg-codecs
    imagemagick
    cockpit
    gnome.gnome-disk-utility
    gparted
    whois
    docker-compose
    zammad
    eza
    deadnix
    slack
    cachix
    statix
    wev
    w3m
    ox
    floorp
    deluge-gtk
    gnome.nautilus
    nautilus-open-any-terminal
    gnome.sushi
    gwenview
    clipmenu
    emojipick
    wev
    killall
    grim #screes capture
    slurp
    pavucontrol
    pasystray
    paprefs
    patray
    noisetorch
    volctl
    vscode
    git
    wget
    gh
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
    jq # A lightweight and flexible command-li>
    # networking tools
    nm-tray
    networkmanager
    networkmanagerapplet
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
    webp-pixbuf-loader
    poppler
    ffmpegthumbnailer
    evince
    stacer
    digikam
    _1password-gui
    cpu-x
    wireshark
    variety
    vim
    fmt
    telegram-desktop
    discord
    vlc
    nodejs_latest
    kitty
    kitty-img
    kitty-themes
    yarn2nix
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
    resilio-sync
    fmt
    pciutils
    geekbench
    inxi
    rPackages.trekfont
  ];

  system.stateVersion = "unstable-small"; # Did you read the comment?
}
