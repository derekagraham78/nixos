{
  inputs,
  config,
  pkgs,
  ...
}: {
  # hyprland
  wayland.windowManager.hyprland.settings = {
    bind =
      [ ]
  (
        # workspaces
        # binds $mod + [shift +] {1..10} to [move to] workspace {1..10}
        builtins.concatLists (builtins.genList (
            x: let
              ws = let
                c = (x + 1) / 10;
              in
                builtins.toString (x + 1 - (c * 10));
            in [
              "$mod, ${ws}, workspace, ${toString (x + 1)}"
              "$mod SHIFT, ${ws}, movetoworkspace, ${toString (x + 1)}"
            ]
          )
          10)
      );
  };
  }
  home.file."~/.config/hypr/hyprland.conf".text = ''
    decoration {
    	shadow_offset = 0 5
    	col.shadow = rgba(00000099)
    	}
    $mod = SUPER
    bindm = $mod, mouse:272, movewindow
    bindm = $mod, mouse:273, resizewindow
    bindm = $mod ALT, mouse:272, resizewindow
  '';
  # TODO please change the username & home direcotry to your own
  home.username = "dgraham";
  home.homeDirectory = "/home/dgraham";
  # basic configuration of git, please change to your own
  programs.git = {
    enable = true;
    userName = "derekagraham78";
    userEmail = "derekagraham78@icloud.com";
  };
  # Packages that should be installed to the user profile.
  home.packages = with pkgs; [
    # here is some command line tools I use frequently
    # feel free to add your own or remove some of them
    # archives
    zip
    xz
    unzip
    p7zip
    grimblast
    # utils
    ripgrep # recursively searches directories for a regex pattern
    jq # A lightweight and flexible command-line JSON processor
    yq-go # yaml processer https://github.com/mikefarah/yq
    fzf # A command-line fuzzy finder

    # networking tools
    mtr # A network diagnostic tool
    iperf3
    dnsutils # `dig` + `nslookup`
    ldns # replacement of `dig`, it provide the command `drill`
    aria2 # A lightweight multi-protocol & multi-source command-line download utility
    socat # replacement of openbsd-netcat
    nmap # A utility for network discovery and security auditing
    ipcalc # it is a calculator for the IPv4/v6 addresses

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
    # it provides the command `nom` works just like `nix`
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
    sysstat
    lm_sensors # for `sensors` command
    ethtool
    pciutils # lspci
    usbutils # lsusb
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
    inxi
    wireshark
    variety
    libreoffice-qt
    libsForQt5.qt5.qtwayland
    vim
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
    neofetch
  ];

  # This value determines the home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update home Manager without changing this value. See
  # the home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "23.11";

  # Let home Manager install and manage itself.
  programs.home-manager.enable = true;
}
