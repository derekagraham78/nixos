{ config, pkgs, ... }: {
  services.mysql = {
    package = pkgs.mariadb;
    enable = true;
    ensureDatabases = [ "papalpenguindb" ];
   replication.role = "master";
       replication.masterHost = "127.0.0.1";
       replication.masterUser = "papalpenguin";
       replication.masterPassword = "098825";
    ensureUsers = [
      {
        name = "papalpenguin";
        ensurePermissions = {
          "papalpenguindb.*" = "ALL PRIVILEGES";
        };
      }
    ];

};


#systemd.services.setdbpass = {
#    description = "MySQL database password setup";
#    wants = [ "mariadb.service" ];
#    wantedBy = [ "multi-user.target" ];
#    serviceConfig = {
#      ExecStart = ''
#      ${pkgs.mariadb}/bin/mysql -e "grant all privileges on papalpenguindb.* to papalpenguin@localhost identified by '098825';" papalpenguindb
#      '';
#      User = "root";
#      PermissionsStartOnly = true;
#      RemainAfterExit = true;
#    };
#
# };


#} 
  # Using PAM for database authentication,
  # so creating a system user for that purpose.
  users.users.papalpenguin = {
    isNormalUser = true;
    description = "papalpenguin";
    group = "dbuser";
    initialPassword = "098825";
  };
  users.groups.dbuser = {};
 
  # Create the database and set up permissions.
#  services.mysql.ensureDatabases = [ "papalpenguin" ];
#  services.mysql.ensureUsers = [
#    {
#      name = "papalpenguin"; # Must be a system user.
#      ensurePermissions = { "papalpenguin.*" = "ALL PRIVILEGES"; };
#    }
#  ];
}
