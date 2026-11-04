let
  secretNames = [
    "git-credentials"
    "ngrok"
    "playit"
    "musicbot"
    "userpassword"
    "rootpassword"
    "guestpassword"
  ];

  hostKeys = {
    computer = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIF6yz8qF2AurZtWC4VuudcQV2gs2wLopanb7eEoMg8Ef";
    laptop = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIExGxnc/NYA1zuezr5SxfM7JbuLiRbBjy5FdBpBdASSA";
    server = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMJ9vjbpG3/h/EES9UiuZxgpuySqtlw834/RhFwt4qGj";
  };

  mkSecret = name: {
    name = "secrets/${name}.age";
    value = {
      publicKeys = builtins.attrValues hostKeys;
      armor = true;
    };
  };

  mkTorSecret = host: service: {
    name = "secrets/tor-${host}-${service}.age";
    value = {
      publicKeys = [ hostKeys.${host} ];
      armor = true;
    };
  };

  torSecrets = builtins.concatMap
    (host: map (mkTorSecret host) [ "files" "ssh" ])
    (builtins.attrNames hostKeys);
  secrets = builtins.listToAttrs ((map mkSecret secretNames) ++ torSecrets);
in
secrets
