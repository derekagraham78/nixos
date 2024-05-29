# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{pkgs, ...}: let
  wordpress-plugin-wp-user-manager = pkgs.stdenv.mkDerivation rec {
    name = "wp-user-manager";
    version = "2.9.10";
    src = pkgs.fetchzip {
      url = "https://downloads.wordpress.org/plugin/wp-user-manager.2.9.10.zip";
      hash = "sha256-pKTLu3WtNwHwd6hu1MfUDs2gIA/H92gAusBC3u4ovR8=";
    };
    installPhase = "mkdir -p $out; cp -R * $out/";
  };
  wordpress-plugin-jetpack-protect = pkgs.stdenv.mkDerivation rec {
    name = "jetpack-protect";
    version = "2.2.0";
    src = pkgs.fetchzip {
      url = "https://downloads.wordpress.org/plugin/jetpack-protect.2.2.0.zip";
      hash = "sha256-gATMvhkTilCTEFIw4fJM1EZ5MvxuY1St2qYhGjiny7M=";
    };
    installPhase = "mkdir -p $out; cp -R * $out/";
  };
  wordpress-plugin-jetpack-social = pkgs.stdenv.mkDerivation rec {
    name = "jetpack-social";
    version = "4.2.0";
    src = pkgs.fetchzip {
      url = "https://downloads.wordpress.org/plugin/jetpack-social.4.2.0.zip";
      hash = "sha256-hwlx421pCTfBdQyCPW0hrsFVLuQahpOkEL7/V0S0/AA=";
    };
    installPhase = "mkdir -p $out; cp -R * $out/";
  };
  wordpress-plugin-jetpack-search = pkgs.stdenv.mkDerivation rec {
    name = "jetpack-search";
    version = "2.1.0";
    src = pkgs.fetchzip {
      url = "https://downloads.wordpress.org/plugin/jetpack-search.2.1.0.zip";
      hash = "sha256-z6BHzZZG6sJIV+ZN/9Nn+cHDHjkDYco1pKyxUtgDEqw=";
    };
    installPhase = "mkdir -p $out; cp -R * $out/";
  };

  wordpress-plugin-jetpack-boost = pkgs.stdenv.mkDerivation rec {
    name = "jetpack-boost";
    version = "3.3.1";
    src = pkgs.fetchzip {
      url = "https://downloads.wordpress.org/plugin/jetpack-boost.3.3.1.zip";
      hash = "sha256-hWDdnq78a2UvjHTfXAGWNHMprxY0k/6FVwGekwbutLQ=";
    };
    installPhase = "mkdir -p $out; cp -R * $out/";
  };
  wordpress-plugin-akismet = pkgs.stdenv.mkDerivation rec {
    name = "akismet";
    version = "5.3.2";
    src = pkgs.fetchzip {
      url = "https://downloads.wordpress.org/plugin/akismet.5.3.2.zip";
      hash = "sha256-HB8gfMz0VH+8obpdPvgkID9GmgGW6vp+9M2SjSvJKIk=";
    };
    installPhase = "mkdir -p $out; cp -R * $out/";
  };
  wordpress-plugin-wpforms-lite = pkgs.stdenv.mkDerivation rec {
    name = "wpforms-lite";
    version = "1.8.8.3";
    src = pkgs.fetchzip {
      url = "https://downloads.wordpress.org/plugin/wpforms-lite.1.8.8.3.zip";
      hash = "sha256-2VRoDMELXDHckV/URFdYp5Fo9Pox94kJQtbwrLuE9A0=";
    };
    installPhase = "mkdir -p $out; cp -R * $out/";
  };

  wordpress-plugin-safe-redirect-manager = pkgs.stdenv.mkDerivation rec {
    name = "safe-redirect-manager";
    version = "2.1.1";
    src = pkgs.fetchzip {
      url = "https://downloads.wordpress.org/plugin/safe-redirect-manager.2.1.1.zip";
      hash = "sha256-PRhzcx/G5HffgcVkE13I4uVmpozLME8cduqButyM1kk=";
    };
    installPhase = "mkdir -p $out; cp -R * $out/";
  };
  wordpress-plugin-jetpack = pkgs.stdenv.mkDerivation rec {
    name = "jetpack";
    version = "13.4.3";
    src = pkgs.fetchzip {
      url = "https://downloads.wordpress.org/plugin/jetpack.13.4.3.zip";
      hash = "sha256-Jvr7ZZ1dWjTP2ulfsQ9eUw1Z0uxlJyGfSn0E6m0iiLU=";
    };
    installPhase = "mkdir -p $out; cp -R * $out/";
  };
  wordpress-plugin-wp-mail-smtp = pkgs.stdenv.mkDerivation rec {
    name = "wp-mail-smtp";
    version = "4.0.1";
    src = pkgs.fetchzip {
      url = "https://downloads.wordpress.org/plugin/wp-mail-smtp.4.0.1.zip";
      hash = "sha256-iWMQ2aEacnDbqGekkctUvkOf7JD5GwXPtvJxWvWLbEM=";
    };
    installPhase = "mkdir -p $out; cp -R * $out/";
  };
  wordpress-plugin-mailpoet = pkgs.stdenv.mkDerivation rec {
    name = "mailpoet";
    version = "4.51.0";
    src = pkgs.fetchzip {
      url = "https://downloads.wordpress.org/plugin/mailpoet.4.51.0.zip";
      hash = "sha256-Q2nSKnJvpF7nY3yxO/xco6yYTIFjtWy4g/N4O/pVnQE=";
    };
    installPhase = "mkdir -p $out; cp -R * $out/";
  };

  wordpress-plugin-social-feed-for-threads = pkgs.stdenv.mkDerivation rec {
    name = "social-feed-for-threads";
    version = "0.0.5";
    src = pkgs.fetchzip {
      url = "https://downloads.wordpress.org/plugin/better-social-feeds.0.0.5.zip";
      hash = "sha256-oEEKjHpjjo8B8OZv5ClqCjrsYuK/ULnCV5eJh+i0o0U=";
    };
    installPhase = "mkdir -p $out; cp -R * $out/";
  };
  wordpress-plugin-include-mastodon-feed = pkgs.stdenv.mkDerivation rec {
    name = "include-mastodon-feed";
    version = "1.9.3";
    src = pkgs.fetchzip {
      url = "https://downloads.wordpress.org/plugin/include-mastodon-feed.1.9.3.zip";
      hash = "sha256-C10h/lNwa3zl22fQxejQYTgYUyasMQP438HHyiPAAtY=";
    };
    installPhase = "mkdir -p $out; cp -R * $out/";
  };

  wordpress-theme-ollie = pkgs.stdenv.mkDerivation rec {
    name = "ollie";
    version = "1.1.0";
    src = pkgs.fetchzip {
      url = "https://downloads.wordpress.org/theme/ollie.1.1.0.zip";
      hash = "sha256-ZS0uXVcQNsTK+1bULclrGN/vYogIynDbOsOxXLI2V2w=";
    };
    installPhase = "mkdir -p $out; cp -R * $out/";
  };
  wordpress-theme-astra = pkgs.stdenv.mkDerivation rec {
    name = "astra";
    version = "4.5.2";
    src = pkgs.fetchzip {
      url = "https://downloads.wordpress.org/theme/astra.${version}.zip";
      hash = "sha256-0o68hv9gagu3TXCP2BGReAPO8ePuG2PKCuxIh4qzOK8=";
    };
    installPhase = "mkdir -p $out; cp -R * $out/";
  };
  wordpress-theme-responsive = pkgs.stdenv.mkDerivation rec {
    name = "responsive";
    version = "4.9.5";
    src = pkgs.fetchzip {
      url = "https://downloads.wordpress.org/theme/responsive.${version}.zip";
      hash = "sha256-ltJLyPPL18dF7YMm+6M47K8TseIgsoWrA9LaQdJPV9o=";
    };
    installPhase = "mkdir -p $out; cp -R * $out/";
  };
in {
  services = {
    wordpress = {
      sites = {
        "papalpenguin.com".themes = {
          inherit wordpress-theme-ollie;
          inherit wordpress-theme-responsive;
          inherit wordpress-theme-astra;
        };
        "papalpenguin.com".plugins = {
          inherit wordpress-plugin-safe-redirect-manager;
          inherit wordpress-plugin-akismet;
          inherit wordpress-plugin-cache-enabler;
          inherit wordpress-plugin-jetpack;
          inherit wordpress-plugin-jetpack-social;
          inherit wordpress-plugin-jetpack-search;
          inherit wordpress-plugin-jetpack-protect;
          inherit wordpress-plugin-jetpack-boost;
          inherit wordpress-plugin-include-mastodon-feed;
          inherit wordpress-plugin-social-feed-for-threads;
          inherit wordpress-plugin-mailpoet;
          inherit wordpress-plugin-wp-mail-smtp;
          inherit wordpress-plugin-wpforms-lite;
          inherit wordpress-plugin-wp-user-manager;
        };
        "papalpenguin.com".virtualHost.documentRoot = "/var/www/papalpenguin.com";
        "papalpenguin.com".virtualHost.enableACME = true;
        "papalpenguin.com" = {};
        "papalpenguin.com".virtualHost.listen = [
          {
            ip = "208.59.78.209";
            port = 443;
            ssl = true;
          }
          {
            ip = "208.59.78.209";
            port = 80;
          }
          {
            ip = "*";
            port = 8080;
          }
        ];
        "papalpenguin.com".database.tablePrefix = "wp_";
        "papalpenguin.com".settings = {
          WP_HOME = "http://www.papalpenguin.com";
          WP_DEFAULT_THEME = "responsive";
          FORCE_SSL_ADMIN = false;
          AUTOMATIC_UPDATER_DISABLED = false;
        };
        "papalpenguin.com".virtualHost = {
          adminAddr = "derek@papalpenguin.com";
          forceSSL = true;
          serverAliases = [
            "www.papalpenguin.com"
            "papalpenguin.com"
          ];
          locations."/".index = "index.php index.html";
        };
      };
      webserver = "nginx";
    };
  };
}
