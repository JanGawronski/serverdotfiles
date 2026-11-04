{
  programs.eza = {
    enable = true;
    enableFishIntegration = true;
    git = true;
    icons = "auto";
    extraOptions = [
      "--long"
      "--all"
      "--group-directories-first"
      "--no-permissions"
      "--no-user"
    ];
  };
}
