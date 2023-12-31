{ config, pkgs, ... }: {
#} 
  # Using PAM for database authentication,
  # so creating a system user for that purpose.
  users.users.papalpenguin = {
    isNormalUser = true;
    description = "papalpenguin";
    group = "papalpenguin";
    initialPassword = "098825";
  };
  users.groups.papalpenguin = {};
 
  # Create the database and set up permissions.
  services.mysql.ensureDatabases = [ "papalpenguindb" ];
  services.mysql.ensureUsers = [
    {
      name = "papalpenguin"; # Must be a system user.
      ensurePermissions = { "papalpenguindb.*" = "ALL PRIVILEGES"; };
   }
  ];
}
