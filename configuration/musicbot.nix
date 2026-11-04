{config, ... }: {
  services.musicbot = {
    enable = true;
    discordTokenPath = config.age.secrets.musicbot.path;
    audioDirectory = "/srv/data/public/musicbotaudio";
  };
}
  
