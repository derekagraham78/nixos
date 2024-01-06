{
  inputs,
  config,
  pkgs,
  ...
}: {
  # hyprland
  inputs = {
    # ...
    hyprland.url = "github:hyprwm/Hyprland";
    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
    };

    # ...
  };

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
