# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{ config, lib, pkgs, ... }:

{
services.wordpress.sites."papalpenguin.com" = {};
services.wordpress.sites."papalpenguin.com".virtualHost.documentRoot = "/var/www/papalpenguin.com";
services.wordpress.sites."papalpenguin.com".virtualHost.addSSL = true;
services.wordpress.sites."papalpenguin.com".virtualHost.listen.true.ssl; 


services.wordpress.sites."papalpenguin.com".settings = {
WP_HOME = "https://www.papalpenguin.com";
FORCE_SSL_ADMIN = true;
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
  enableACME = true;
};
}


