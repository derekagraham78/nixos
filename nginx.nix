{
  config,
  lib,
  ...
}: {
  services.nginx = {
    enable = true;
    recommendedOptimisation = true;
    defaultListen = [{addr = "0.0.0.0";}];
    defaultSSLListenPort = 443;
    virtualHosts."papalpenguin.com" = {
      enableACME = true;
      root = "/var/www/papalpenguin.com";
      locations = {
        "= /" = {
          extraConfig = ''
            rewrite ^ /index.php;
          '';
        };
        "~ \.php$" = {
          extraConfig = ''
            try_files $uri =404;
            fastcgi_pass  unix:${config.services.phpfpm.pools.${domain1_app}.socket};
            fastcgi_index index.php;
            include ${pkgs.nginx}/conf/fastcgi_params;
            include ${pkgs.nginx}/conf/fastcgi.conf;
          '';
        };
      };
      forceSSL = true;
      serverAliases = ["www.papalpenguin.com"];
    };
  };
  services.phpfpm.pools.mypool = {
    user = "nobody";
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
