{pkgs, ...}: {
  # Enable the mysql service.
  services.mysql.enable = true;
  services.mysql.package = pkgs.mariadb;
}
