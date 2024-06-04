{
  pkgs,
  config,
  lib,
  ...
}: {
  services.nginx = {
    enable = true;
    logError = "stderr error";
    recommendedGzipSettings = true;
    recommendedOptimisation = true;

    # Only allow PFS-enabled ciphers with AES256
    #    sslCiphers = "AES256+EECDH:AES256+EDH:!aNULL";
    appendHttpConfig = ''
            # Add HSTS header with preloading to HTTPS requests.
            # Adding this header to HTTP requests is discouraged
            map $scheme $hsts_header {
                https   "max-age=31536000; includeSubdomains; preload";
            }
            add_header Strict-Transport-Security $hsts_header;

            # Enable CSP for your services.
            #add_header Content-Security-Policy "script-src 'self'; object-src 'none'; base-uri 'none';" always;
            # Minimize information leaked to other domains
      #      add_header 'Referrer-Policy' 'origin-when-cross-origin';

            # Disable embedding as a frame
            add_header X-Frame-Options ALLOW;

            # Prevent injection of code in other mime types (XSS Attacks)
       #     add_header X-Content-Type-Options nosniff;

            # This might create errors
        #    proxy_cookie_path / "/; secure; HttpOnly; SameSite=strict";
    '';
    defaultListen = [{addr = "0.0.0.0";}];
    defaultSSLListenPort = 443;
    virtualHosts."papalpenguin.com" = {
      enableACME = true;
      root = "/var/www/papalpenguin.com";
      forceSSL = true;
      locations."~ \.user\.ini$".extraConfig = ''
        deny all;
      '';
      locations."~* /uploads/.*\.php$".extraConfig = ''
        return 503;
      '';
      locations."/".index = "index.php";
      locations."/".extraConfig = ''
                                                autoindex on;
                                        #        try_files $Uri = 404;
        #                                        fastcgi_pass  unix:${config.services.phpfpm.pools.mypool.socket};
                        #                        fastcgi_split_path_info ^(.+\.php)(/.+)$;
                                                fastcgi_index index.php;
                                #                fastcgi_buffering on;
                #                                fastcgi_param SCRIPT_FILENAME $request_filename;
      '';
      #      locations."~* \.(?:css|js|map|jpe?g|gif|png)$".extraConfig = ''
      #        index  index.html index.htm index.php;
      #          try_files $uri $uri/ /index.php?$args;
      #            fastcgi_pass unix:${config.services.phpfpm.pools.mypool.socket};
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
        #                output_buffering = on
                        memory_limit = 1G
         #               security.limit_extensions =         .php .php3 .php4 .php5 .php7 .html .htm .js .css .png .webp



                        cgi.fix_pathinfo = 0
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
      "pm.max_children" = 500;
      "pm.start_servers" = 2;
      "pm.min_spare_servers" = 1;
      "pm.max_spare_servers" = 25;
      "pm.process_idle_timeout" = 150;
      "pm.max_requests" = 2000;
    };
  };
}
