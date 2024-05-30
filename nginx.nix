{config, ...}: {
  #  services.nginx = {
  #    enable = true;
  #    defaultListen = [{addr = "0.0.0.0";}];
  #    defaultSSLListenPort = 443;
  #    virtualHosts."papalpenguin.com" = {
  #      enableACME = true;
  #      root = "/var/www/papalpenguin.com";
  #      locations."~ \\.php$".extraConfig = ''
  #        fastcgi_pass  unix:${config.services.phpfpm.pools.mypool.socket};
  #         fastcgi_index index.php;
  #      '';
  #      forceSSL = false;
  #      serverAliases = ["www.papalpenguin.com"];
  #    };
  #  };
  services.caddy = {
    enable = true;
    virtualHosts."papalpenguin.com" = {
      serverAliases = ["www.papalpenguin.com"];
      extraConfig = ''
        root    * /var/www/papalpenguin.com
        file_server
        php_fastcgi unix/var/run/phpfpm/localhost.sock
      '';
    };
  };
  services.phpfpm.pools.mypool = {
    user = "nobody";
    settings = {
      "pm" = "dynamic";
      "listen.owner" = "caddy";
      "pm.max_children" = 5;
      "pm.start_servers" = 2;
      "pm.min_spare_servers" = 1;
      "pm.max_spare_servers" = 3;
      "pm.max_requests" = 500;
    };
  };
}
