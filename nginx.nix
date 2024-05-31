{
  config,
  lib,
  ...
}: {
  services.nginx = {
    enable = true;
    recommendedOptimisation = true;
    logError = "stderr debug";
    defaultListen = [{addr = "0.0.0.0";}];
    defaultSSLListenPort = 443;
    virtualHosts."papalpenguin.com" = {
      enableACME = true;
      root = "/var/www/papalpenguin.com";
      locations."~ \\.php$".index = "index.php";
      locations."~ \\.php$".extraConfig = ''
        autoindex on;
        fastcgi_pass  unix:${config.services.phpfpm.pools.mypool.socket};
        fastcgi_index index.php;
      '';
      forceSSL = true;
      locations."= /".extraConfig = ''
        autoindex on;
        rewrite ^ /index.php;
      '';
      locations."/".index = "index.php";
      locations."/".extraConfig = ''
        autoindex on;
      '';
      serverAliases = ["www.papalpenguin.com"];
    };
  };
  services.phpfpm.pools.mypool = {
    user = "nginx";
phpPackage = pkgs.php83.buildEnv {
      extensions = {enabled, all}: enabled ++ (with all; [
        apcu
        bcmath
        gmp
        imagick
        opcache
        pdo
        pdo_pgsql
        memcache
      ]);
      extraConfig = ''
        output_buffering = off
        memory_limit = 1G
        apc.enable_cli = 1
        opcache.memory_consumption=256
        opcache.interned_strings_buffer=64
        opcache.max_accelerated_files=32531
        opcache.validate_timestamps=0
        opcache.enable_cli=1
      '';
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
