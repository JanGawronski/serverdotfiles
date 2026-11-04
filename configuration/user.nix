{config, ...}: {
  users.users = {
    user = {
      isNormalUser = true;
      hashedPasswordFile = config.age.secrets.user-password.path;
      extraGroups = [ "wheel" ];
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGJ/dg13sIsZ7fIJa5DCrph4V8o6yJACiYAqJ1U7Nh5j computer"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGGsZSdZFEgpUV8TuxeYYFQIpDb2zVUMf7JNshqdyvUj laptop"
      ];
    };
    matman = {
      isNormalUser = true;
      hashedPasswordFile = config.age.secrets.matman-password.path;
      extraGroups = [ "wheel" ];
      openssh.authorizedKeys.keys = [


      ];      
    };
    guest = {
      isNormalUser = true;
      hashedPasswordFile = config.age.secrets.guest-password.path;
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGJ/dg13sIsZ7fIJa5DCrph4V8o6yJACiYAqJ1U7Nh5j computer"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGGsZSdZFEgpUV8TuxeYYFQIpDb2zVUMf7JNshqdyvUj laptop"
      ];
    };
  };
}
