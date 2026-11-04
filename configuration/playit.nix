{config, ... }: {
  services.playit = {
    enable = true;
    secretPath = config.age.secrets.playit.path;
  };
}
