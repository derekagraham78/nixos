{
  pkgs,
  config,
  lib,
  ...
}: {
  services.nginx = {
    enable = true;
    logError = "stderr info";
    recommendedOptimisation = true;
    appendHttpConfig = ''
                        # Add HSTS header with preloading to HTTPS requests.
                        # Adding this header to HTTP requests is discouraged
             #           map $scheme $hsts_header {
              #              https   "max-age=31536000; includeSubdomains; preload";
                        }
            #            add_header Strict-Transport-Security $hsts_header;

                        # Enable CSP for your services.
                        #add_header Content-Security-Policy "script-src 'self'; object-src 'none'; base-uri 'none';" always;
                        # Minimize information leaked to other domains
                  #      add_header 'Referrer-Policy' 'origin-when-cross-origin';

                        # Disable embedding as a frame
      #                  add_header X-Frame-Options ALLOW;

                        # Prevent injection of code in other mime types (XSS Attacks)
                   #     add_header X-Content-Type-Options nosniff;

                        # This might create errors
                    #    proxy_cookie_path / "/; secure; HttpOnly; SameSite=strict";
    '';
    defaultListen = [{addr = "0.0.0.0";}];
    defaultSSLListenPort = 443;
    virtualHosts."papalpenguin.com" = {
      enableACME = true;
      addSSL = true;

      root = "/var/www/papalpenguin.com";
      forceSSL = false;
      locations."~ \\.php$".index = "index.php";
      locations."~ \\.php$".extraConfig = ''
        autoindex on;
        fastcgi_pass  unix:${config.services.phpfpm.pools.mypool.socket};
        fastcgi_index index.php;
      '';
      locations."= /".extraConfig = ''
        autoindex on;
        rewrite ^ /index.php;
      '';
      locations."/".index = "index.php";
      locations."/".extraConfig = ''
                                autoindex on;
                                proxy_pass https://192.168.4.60:9090;
                                proxy_set_header Host $host;
                                proxy_set_header X-Forwarded-Proto $scheme;
        #        proxy_http_version 1.1;
        #                proxy_buffering off;
        #                proxy_set_header Upgrade $http_upgrade;
        #                proxy_set_header Connection "upgrade";

                        # Pass ETag header from Cockpit to clients.
                        # See: https://github.com/cockpit-project/cockpit/issues/5239
        #                gzip off;
      '';

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
