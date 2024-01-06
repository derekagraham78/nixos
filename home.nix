{pkgs, ...}: let
  flake-compat = builtins.fetchTarball {
    url = "https://github.com/edolstra/flake-compat/archive/master.tar.gz";
    sha256 = "sha256-kvjfFW7WAETZlt09AgDn1MrtKzP7t90Vf7vypd3OL1U=";
  };

  hyprland =
    (import flake-compat {
      src = builtins.fetchTarball {
        url = "https://github.com/hyprwm/Hyprland/archive/master.tar.gz";
        sha256 = "sha256-isiBkAsjXIvb/6McVK42/iBbC4h+UL3JRkkLqTSPE48=";
      };
    })
    .defaultNix;
in {
  imports = [hyprland.homeManagerModules.default];

  wayland.windowManager.hyprland.enable = true;

  # hyprland
  inputs = {
    # ...
    hyprland.url = "github:hyprwm/Hyprland";
    #    hyprland-plugins = {
    #      url = "github:hyprwm/hyprland-plugins";
    #      inputs.hyprland.follows = "hyprland";
  };
  # ...
  #  };
  wayland.windowManager.hyprland = {
    plugins = [
      #     inputs.hyprland-plugins.packages.${pkgs.system}.hyprload
      #     inputs.hyprland-plugins.packages.${pkgs.system}.split-monitor-workspaces
      #     inputs.hyprland-plugins.packages.${pkgs.system}.hyprNStack
      #     inputs.hyprland-plugins.packages.${pkgs.system}.hyprRiver
      #     inputs.hyprland-plugins.packages.${pkgs.system}.hyprfocus
      #     inputs.hyprland-plugins.packages.${pkgs.system}.hyprland-dwindle-autogroup
      #     inputs.hyprland-plugins.packages.${pkgs.system}.hyprland-virtual-desktops
      #     inputs.hyprland-plugins.packages.${pkgs.system}.Hypr-DarkWindow
      #     inputs.hyprland-plugins.packages.${pkgs.system}.hyprtrails
      inputs.hyprland-plugins.packages.${pkgs.system}.hyprbars
      # ...
    ];
    settings = {
      "$mod" = "SUPER";
      bind =
        [
          "$mod, F, exec, firefox"
          ", Print, exec, grimblast copy area"
        ]
        ++ (
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
