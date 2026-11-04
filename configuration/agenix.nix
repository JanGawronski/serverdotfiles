{
  age = {
    secrets = {
      ngrok = {
        file = ./../../secrets/ngrok.age;
        mode = "400";
        owner = "ngrok";
        group = "ngrok";
      };
      playit = {
        file = ./../../secrets/playit.age;
        mode = "400";
        owner = "user";
        group = "users";
      };
      musicbot = {
        file = ./../../secrets/musicbot.age;
        mode = "400";
        owner = "musicbot";
        group = "musicbot";
      };
    };
  };
}
