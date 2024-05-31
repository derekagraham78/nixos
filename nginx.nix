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

locations = { "/var/www/papalpenguin.com" autoindex on; } }; "~ \.php$" = { location ~* \.(xml|xsl)$ { add_header Cache-Control "no-cache, 
    no-store, must-revalidate, max-age=0"; expires -1; } extraConfig = ''
location /robots.txt { add_header Cache-Control "no-cache, no-store, must-revalidate, max-age=0"; expires -1; } try_files $uri =404; 
            fastcgi_pass unix:${config.services.phpfpm.pools.mypool.socket}; fastcgi_index index.php;
location ~* \.(css|js|pdf)$ { add_header Cache-Control "public, must-revalidate, proxy-revalidate, immutable, max-age=2592000, 
stale-while-revalidate=86400, stale-if-error=604800"; expires 30d; } ''; location ~* 
\.(jpg|jpeg|png|gif|ico|eot|swf|svg|webp|avif|ttf|otf|woff|woff2|ogg|mp4|mpeg|avi|mkv|webm|mp3)$ { add_header Cache-Control "public, 
must-revalidate, proxy-revalidate, immutable, max-age=31536000, stale-while-revalidate=86400, stale-if-error=604800"; expires 365d; } }; 
location /wp-cron.php { add_header Cache-Control "no-cache, no-store, must-revalidate, max-age=0"; expires -1; } };
location = /wp-content/wp-cloudflare-super-page-cache/www.papalpenguin.com/debug.log { access_log off; deny all; }      forceSSL = true;
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
