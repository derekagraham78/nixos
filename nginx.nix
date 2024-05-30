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
}
