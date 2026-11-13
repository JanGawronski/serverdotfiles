{
  services.samba = {
    enable = true;
    openFirewall = true;
    settings = {
      global = {
        security = "user";
        "map to guest" = "Never";
      };

      Data = {
        path = "/srv/data";
        browseable = true;
        "read only" = false;
        "valid users" = "matman";
      };

      Home = {
        path = "/home";
        browseable = true;
        "read only" = false;
        "valid users" = "matman";
      };
    };
  };
}
