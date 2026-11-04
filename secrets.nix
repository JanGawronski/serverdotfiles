let
  secretNames = [
    "git-credentials"
    "musicbot"
    "rootpassword"
    "userpassword"
    "matmanpassword"
    "guestpassword"
  ];

  hostKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMJ9vjbpG3/h/EES9UiuZxgpuySqtlw834/RhFwt4qGj";

  mkSecret = name: {
    name = "secrets/${name}.age";
    value = {
      publicKeys = [ hostKey ];
      armor = true;
    };
  };

  mkTorSecret = service: {
    name = "secrets/tor-${service}.age";
    value = {
      publicKeys = [ hostKey ];
      armor = true;
    };
  };

  torSecrets = builtins.concatMap
    (service: [ (mkTorSecret service) ])
    [ "files" "ssh" ];
  secrets = builtins.listToAttrs ((map mkSecret secretNames) ++ torSecrets);
in
secrets
