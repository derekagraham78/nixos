{config, ...}: {
  services.caddy = {
    enable = true;
    virtualHosts."http://localhost" = {
      extraConfig = ''
        root    * /var/www
        file_server
        php_fastcgi unix/var/run/phpfpm/localhost.sock
      '';
    };
  };
}
