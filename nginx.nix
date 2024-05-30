{
  config,
  lib,
  ...
}: {
  services.nginx = {
    enable = true;
    recommendedOptimisation = true;
    virtualHosts."papalpenguin.com" = {
      enableACME = true;
      root = lib.mkDefault "/var/www/papalpenguin.com";
      listen = [
         { 
	   addr = "208.59.78.209";
  	   port = 443;
	   ssl = true;
         }
	 {
	   addr = "208.59.78.209";
	   port = 80;
	 }
]
      locations."~ \\.php$".extraConfig = ''
        fastcgi_pass  unix:${config.services.phpfpm.pools.mypool.socket};
         fastcgi_index index.php;
      '';
      forceSSL = false;
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
