{ config, pkgs, ... }: {
  services.mysql = {
    package = pkgs.mariadb;
    enable = true;
    ensureDatabases = [ papalpenguin    ];
   replication.role = "master";
       replication.slaveHost = "127.0.0.1";
       replication.masterUser = "papalpenguin";
       replication.masterPassword = "098825";
    ensureUsers = [
      {
        name = "papalpenguin";
        ensurePermissions = {
          "papalpenguin.*" = "ALL PRIVILEGES";
        };
      }
    ];

};


systemd.services.setdbpass = {
    description = "MySQL database password setup";
    wants = [ "mariadb.service" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      ExecStart = ''
      ${pkgs.mariadb}/bin/mysql -e "grant all privileges on ${statsConfig.db}.* to ${statsConfig.user}@localhost identified by '${statsConfig.password}';" ${statsConfig.db}
      '';
      User = "root";
      PermissionsStartOnly = true;
      RemainAfterExit = true;
    };
 };


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
