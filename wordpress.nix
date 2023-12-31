# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{ config, lib, pkgs, ... }:

{
let
  domain = "papalpenguin.com";

  # Auxiliary functions
  fetchPackage = { name, version, hash, isTheme }:
    pkgs.stdenv.mkDerivation rec {
      inherit name version hash;
      src = let type = if isTheme then "theme" else "plugin";
      in pkgs.fetchzip {
        inherit name version hash;
        url = "https://downloads.wordpress.org/${type}/${name}.${version}.zip";
      };
      installPhase = "mkdir -p $out; cp -R * $out/";
    };

  fetchPlugin = { name, version, hash }:
    (fetchPackage {
      name = name;
      version = version;
      hash = hash;
      isTheme = false;
    });

  fetchTheme = { name, version, hash }:
    (fetchPackage {
      name = name;
      version = version;
      hash = hash;
      isTheme = true;
    });

  # Plugins
  google-site-kit = (fetchPlugin {
    name = "google-site-kit";
    version = "1.103.0";
    hash = "sha256-8QZ4XTCKVdIVtbTV7Ka4HVMiUGkBYkxsw8ctWDV8gxs=";
  });

  # Themes
  astra = (fetchTheme {
    name = "astra";
    version = "4.1.5";
    hash = "sha256-X3Jv2kn0FCCOPgrID0ZU8CuSjm/Ia/d+om/ShP5IBgA=";
  });
services.wordpress.sites."papalpenguin.com".virtualHost.enableACME = true;
services.wordpress.sites."papalpenguin.com" = {};
services.wordpress.sites."papalpenguin.com".virtualHost.documentRoot = "/var/www/papalpenguin.com";
services.wordpress.sites."papalpenguin.com".themes = {
inherit astra; };
services.wordpress.sites."papalpenguin.com".plugins = {
inherit google-site-kit; };
#services.wordpress.sites."papalpenguin.com".virtualHost.addSSL = true;
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
  forceSSL = false;
};
}
