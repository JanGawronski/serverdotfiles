{
  age = {
    secrets = {
      git-credentials = {
        file = ./../secrets/git-credentials.age;
        mode = "0440";
        group = "users";
      };
      root-password.file = ./../secrets/rootpassword.age;
      user-password.file = ./../secrets/userpassword.age;
      matman-password.file = ./../secrets/matmanpassword.age;
      guest-password.file = ./../secrets/guestpassword.age;
      musicbot = {
        file = ./../secrets/musicbot.age;
        mode = "400";
        owner = "musicbot";
        group = "musicbot";
      };
    };
  };
}
