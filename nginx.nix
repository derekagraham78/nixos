{
  config,
  lib,
  ...
}: {
  services.nginx = {
    enable = true;
    recommendedOptimisation = true;
    logError = "stderr error";
    defaultListen = [{addr = "0.0.0.0";}];
    defaultSSLListenPort = 443;
    virtualHosts."papalpenguin.com" = {
      enableACME = true;
      root = "/var/www/papalpenguin.com";
      locations."~ \\.php$".index = "index.php";
      locations."~ \\.php$".extraConfig = ''
        location "~ \\.php$"  { "autoindex on" };

          fastcgi_pass  unix:${config.services.phpfpm.pools.mypool.socket};
          fastcgi_index index.php;
      '';
      forceSSL = true;
      locations = {
        "= /" = {
          index = "index.php";
          extraConfig = ''
            rewrite ^ /index.php;
          '';
        };
      };
      serverAliases = ["www.papalpenguin.com"];
    };
  };
  services.phpfpm.pools.mypool = {
    user = "nginx";
    settings = {
      "pm" = "dynamic";
      "listen.owner" = config.services.nginx.user;
      "pm.max_children" = 5;
      "pm.start_servers" = 2;
      "pm.min_spare_servers" = 1;
      "pm.max_spare_servers" = 3;
      "pm.max_requests" = 500;
    };
  }
