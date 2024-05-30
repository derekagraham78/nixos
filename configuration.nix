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
    ./wordpress.nix
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
    zsh = {
      enable = true;
      # Your zsh config
      ohMyZsh = {
        enable = true;
        plugins = ["git" "python" "man" "1password"];
        theme = "agnoster";
      };
    };
    dconf.enable = true;
    mtr.enable = true;
    xfconf.enable = true;
    nm-applet.enable = true;
  };
  # Bootloader.
  boot.kernelPackages = pkgs.linuxPackages_zen;
  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };
  boot.kernelModules = ["drivetemp"];
  boot.kernelParams = ["reboot=acpi" "coretemp"];
  networking = {
    hostName = "Mulder"; # Define your hostname.
    firewall.enable = false;
    networkmanager.enable = true;
    enableIPv6 = false;
  };
  #networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  # Printer
  services = {
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
          AllowUnencrypted = true;
        };
      };
    };
    desktopManager.plasma6.enable = true;
    tailscale.enable = true;
    openssh = {
      enable = true;
      settings.PermitRootLogin = "yes";
      allowSFTP = true;
    };
    flatpak.enable = true;
    printing.enable = true;
    pipewire = {
      enable = false;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
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
      xkb.model = "Logitech K270";
      enable = true;
    };
    # List services that you want to enable:
  };
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
    users.dgraham = {
      description = "Derek Graham";
      extraGroups = ["plex" "networkmanager" "rslsync" "docker" "wheel" "video"];
      isNormalUser = true;
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
    idevicerestore
    microsoft-edge
    altserver-linux
    element-desktop
    element-desktop-wayland
    element-web
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
