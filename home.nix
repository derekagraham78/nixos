{
  inputs,
  pkgs,
  ...
}: {
  wayland.windowManager.hyprland = {
    # Whether to enable Hyprland wayland compositor
    enable = true;
    # The hyprland package to use
    package = pkgs.hyprland;
    # Whether to enable XWayland
    xwayland.enable = true;

    # Optional
    # Whether to enable hyprland-session.target on hyprland startup
    systemd.enable = true;
    # Whether to enable patching wlroots for better Nvidia support
    enableNvidiaPatches = true;
  };
  wayland.windowManager.hyprland = {
    plugins = [
      inputs.hyprbars.packages.${pkgs.system}.hyprbars
    ];
  };

  # basic configuration of git, please change to your own
  programs.git = {
    enable = true;
    userName = "derekagraham78";
    userEmail = "derekagraham78@icloud.com";
  };
  # Packages that should be installed to the user profile.
  home.packages = with pkgs; [];

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
