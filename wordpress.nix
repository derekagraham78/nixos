# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{pkgs, ...}: let
  wordpress-plugin-wpforms-lite = pkgs.stdenv.mkDerivation rec {
    name = "wpforms-lite";
    version = "1.8.7.2";
    src = pkgs.fetchzip {
      url = "https://downloads.wordpress.org/plugin/wpforms-lite.1.8.7.2.zip";
      hash = "sha256-qqjuqSHMppMRvCcFh/003rPyE1kqxJQe3inabTfdRtk=";
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
    version = "4.46.0";
    src = pkgs.fetchzip {
      url = "https://downloads.wordpress.org/plugin/mailpoet.4.46.0.zip";
      hash = "sha256-DUkmB1j67EPu/b75yThEY5FNmY/g5TuR/l/uJ84QxG8=";
    };
    installPhase = "mkdir -p $out; cp -R * $out/";
  };

  wordpress-plugin-social-feed-for-threads = pkgs.stdenv.mkDerivation rec {
    name = "social-feed-for-threads";
    version = "0.0.4";
    src = pkgs.fetchzip {
      url = "https://downloads.wordpress.org/plugin/better-social-feeds.0.0.4.zip";

      hash = "sha256-HehMBKPGA+NY1oFnCkWzOKFGE6z/+yIEm9IOBJ4YPog=";
    };
    installPhase = "mkdir -p $out; cp -R * $out/";
  };

  wordpress-plugin-indieweb = pkgs.stdenv.mkDerivation rec {
    name = "indieweb";
    version = "4.0.4";
    src = pkgs.fetchzip {
      url = "https://downloads.wordpress.org/plugin/indieweb.4.0.4.zip";
      hash = "sha256-KJqD00C74KO/GL+KVwGuy/IqpfCrKASr9LuIPDPD1ao=";
    };
    installPhase = "mkdir -p $out; cp -R * $out/";
  };
  wordpress-plugin-webmention = pkgs.stdenv.mkDerivation rec {
    name = "webmention";
    version = "5.2.5";
    src = pkgs.fetchzip {
      url = "https://downloads.wordpress.org/plugin/webmention.5.2.5.zip";
      hash = "sha256-zrHFRZFAX09Og1JoCScPQdRd/E20lsoXQeikcAw3Zl0=";
    };
    installPhase = "mkdir -p $out; cp -R * $out/";
  };
  wordpress-plugin-indieauth = pkgs.stdenv.mkDerivation rec {
    name = "indieauth";
    version = "4.4.2";
    src = pkgs.fetchzip {
      url = "https://downloads.wordpress.org/plugin/indieauth.4.4.2.zip";
      hash = "sha256-vJ1Hy77C+FKHhnS0hf/yNyzYxsTRWdL2LiCSDqBJqrg=";
    };
    installPhase = "mkdir -p $out; cp -R * $out/";
  };
  wordpress-plugin-wp-social-ninja = pkgs.stdenv.mkDerivation rec {
    name = "wp-social-ninja";
    version = "3.13.0";
    src = pkgs.fetchzip {
      url = "https://downloads.wordpress.org/plugin/wp-social-reviews.3.13.0.zip";
      hash = "sha256-O+rFNCS7qkft2HwsFNUlN+LosGY4LiiV3011zvT3rb4=";
    };
    installPhase = "mkdir -p $out; cp -R * $out/";
  };

  wordpress-plugin-wp-social-ninja-pro = pkgs.stdenv.mkDerivation rec {
    name = "wp-social-ninja-pro";
    version = "3.13.0";
    src = pkgs.fetchzip {
      url = "http://www.papalpenguin.com/wp-content/uploads/2024/03/wp-social-ninja-pro-3.13.0.zip";
      hash = "sha256-3jnIz4NypxaWFfvqsdFPHYraxRBQhM1BNjyRQrZ7k0o=";
    };
    installPhase = "mkdir -p $out; cp -R * $out/";
  };
  wordpress-plugin-include-mastodon-feed = pkgs.stdenv.mkDerivation rec {
    name = "include-mastodon-feed";
    version = "1.9.3";
    src = pkgs.fetchzip {
      url = "https://downloads.wordpress.org/plugin/include-mastodon-feed.1.9.3.zip";
      hash = "sha256-57nub2/Xa/pyvkmMy119B6/gLDTwodiRr9PkHPjBgwY=";
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
          inherit wordpress-plugin-indieweb;
          inherit wordpress-plugin-webmention;
          inherit wordpress-plugin-indieauth;
          inherit wordpress-plugin-wp-social-ninja;
          inherit wordpress-plugin-wp-social-ninja-pro;
          inherit wordpress-plugin-include-mastodon-feed;
          inherit wordpress-plugin-social-feed-for-threads;
          inherit wordpress-plugin-mailpoet;
          inherit wordpress-plugin-wp-mail-smtp;
          inherit wordpress-plugin-wpforms-lite;
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
