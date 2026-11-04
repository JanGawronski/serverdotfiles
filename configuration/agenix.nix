{
  age = {
    secrets = {
      user-git-credentials = {
        file = ./../secrets/user-git-credentials.age;
        mode = "0440";
        group = "users";
      };
      root-password.file = ./../secrets/root-password.age;
      user-password.file = ./../secrets/user-password.age;
      matman-password.file = ./../secrets/matman-password.age;
      guest-password.file = ./../secrets/guest-password.age;
      musicbot = {
        file = ./../secrets/musicbot.age;
        mode = "400";
        owner = "musicbot";
        group = "musicbot";
      };
    };
  };
}
