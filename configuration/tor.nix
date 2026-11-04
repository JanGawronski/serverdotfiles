{ config, hostname, lib, ... }:
let
  onionServices = {
    files = {
      port = 80;
      target = {
        addr = "127.0.0.1";
        port = 8081;
      };
    };
    ssh = {
      port = 22;
      target = {
        addr = "127.0.0.1";
        port = 22;
      };
    };
  };

  secretName = service: "tor-${hostname}-${service}";
in
{
  age.secrets = lib.mapAttrs' (service: _: lib.nameValuePair (secretName service) {
    file = ./../../secrets/${secretName service}.age;
    mode = "0400";
    owner = "tor";
    group = "tor";
  }) onionServices;

  services.tor = {
    enable = true;
    client.enable = true;
    torsocks.enable = true;
    
    relay.onionServices = lib.mapAttrs (service: settings: {
      version = 3;
      secretKey = config.age.secrets.${secretName service}.path;
      map = [ settings ];
    }) onionServices;
  };
}
