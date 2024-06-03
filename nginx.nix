{
  pkgs,
  config,
  lib,
  ...
}: {
  services.nginx = {
    enable = true;
    logError = "stderr error";
    recommendedOptimisation = true;
    defaultListen = [{addr = "0.0.0.0";}];
    defaultSSLListenPort = 443;
    virtualHosts."papalpenguin.com" = {
      enableACME = true;
      root = "/var/www/papalpenguin.com";
      forceSSL = true;
      locations."~ \\.php$".index = "index.php";
      locations."~ \\.php$".extraConfig = ''
        autoindex on;
        fastcgi_pass  unix:${config.services.phpfpm.pools.mypool.socket};
        fastcgi_index index.php;
      '';
locations.”~* /uploads/.*\.php$“.extraConfig =  ''
    return 503;
'';
      locations."= /".extraConfig = ''
        autoindex on;
        rewrite ^ /index.php;
      '';
      locations."/".index = "index.php";
      locations."/".extraConfig = ''
                autoindex on;
        #      '';
      serverAliases = ["www.papalpenguin.com"];
    };
  };
  services.phpfpm.pools.mypool = {
    #x phpOptions = ''
    # '';

    user = "nginx";
    phpPackage = pkgs.php82.buildEnv {
      extensions = {
        enabled,
        all,
      }:
        enabled
        ++ (with all; [
          apcu
          bcmath
          zlib
          iconv
          mbstring
          zip
          curl
          exif
          gmp
          imagick
          opcache
          pdo
          pdo_pgsql
          redis
          memcache
        ]);
      extraConfig = ''
        output_buffering = off
        memory_limit = 1G
        apc.enable_cli = 1
        opcache.memory_consumption=256
        opcache.interned_strings_buffer=64
        opcache.max_accelerated_files=32531
        upload_max_filesize = 128M;
        post_max_size = 128M;
        opcache.validate_timestamps=0
        opcache.enable_cli=1
      '';
    };
    settings = {
      "pm" = "dynamic";
      "listen.owner" = config.services.nginx.user;
      "pm.max_children" = 5;
      "pm.start_servers" = 2;
      "pm.min_spare_servers" = 1;
      "pm.max_spare_servers" = 3;
      "pm.max_requests" = 500;
    };
  };
}
