# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  pkgs,
  ...
}: let
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
