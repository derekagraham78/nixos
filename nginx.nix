{config, ...}: {
  services.nginx = {
    enable = true;
    defaultListen = [{addr = "0.0.0.0";}];
    defaultSSLListenPort = 443;
    virtualHosts."papalpenguin.com" = {
      enableACME = true;
      root = "/var/www/papalpenguin";
      locations."~ \\.php$".extraConfig = ''
        fastcgi_pass  unix:${config.services.phpfpm.pools.mypool.socket};
        fastcgi_index index.php;
      '';
      forceSSL = true;
      serverAliases = ["www.papalpenguin.com"];
    };
  };
  #  services.phpfpm.pools.mypool = {
  #    user = "php";
  #    settings = {
  #      "pm" = "dynamic";
  #      "listen.owner" = config.services.nginx.user;
  #      "pm.max_children" = 5;
  #      "pm.start_servers" = 2;
  #      "pm.min_spare_servers" = 1;
  #      "pm.max_spare_servers" = 3;
  #      "pm.max_requests" = 500;
  #    };
  #  };
}