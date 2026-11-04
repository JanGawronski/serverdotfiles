{
  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = false;
      ChallengeResponseAuthentication = "no";
      KbdInteractiveAuthentication = false;
      PubkeyAuthentication = "yes";
    };
  };
}
