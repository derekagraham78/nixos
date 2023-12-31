{ config, pkgs, ... }: {
 
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
  services.mysql.ensureDatabases = [ "papalpenguin" ];
  services.mysql.ensureUsers = [
    {
      name = "papalpenguin"; # Must be a system user.
      ensurePermissions = { "papalpenguin.*" = "ALL PRIVILEGES"; };
    }
  ];
}
