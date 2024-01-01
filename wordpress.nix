# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{ config, lib, pkgs, ... }:

let
wordpress-theme-ollie = pkgs.stdenv.mkDerivation rec {
  name = "ollie";
  version = "1.1.0";
  src = pkgs.fetchzip {
    url = "https://downloads.wordpress.org/theme/ollie.1.1.0.zip";
    hash = "sha256-ePUHkwtjLP/JcJtSdc1QiJlXgru6SLysNqsPk/AF0kY=";
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
services.wordpress.sites."papalpenguin.com".themes = {
inherit wordpress-theme-ollie;
inherit wordpress-theme-responsive;
inherit wordpress-theme-astra;
    };
services.wordpress.sites."papalpenguin.com".virtualHost.documentRoot = "/var/www/papalpenguin.com";
services.wordpress.sites."papalpenguin.com".virtualHost.enableACME = true;
services.wordpress.sites."papalpenguin.com" = {};
services.wordpress.sites."papalpenguin.com".virtualHost.listen = [
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

services.wordpress.sites."papalpenguin.com".settings = {
WP_HOME = "http://www.papalpenguin.com";
FORCE_SSL_ADMIN = false;
AUTOMATIC_UPDATER_DISABLED = false;
};
services.wordpress.sites."papalpenguin.com".database.tablePrefix = "wp_";
services.wordpress.webserver = "nginx";
services.wordpress.sites."papalpenguin.com".virtualHost.serverAliases = [
"www.papalpenguin.com"
"papalpenguin.com"
];
services.wordpress.sites."papalpenguin.com".virtualHost.locations."/".index = "index.php index.html";
services.wordpress.sites."papalpenguin.com".virtualHost =
{
  adminAddr = "derek@papalpenguin.com";
  forceSSL = true;
};
}
