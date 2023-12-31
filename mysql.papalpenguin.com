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
 
}
