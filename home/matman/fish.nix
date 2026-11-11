{
  programs.fish = {
    enable = true;
    shellAliases = {
      cd = "z";
      cat = "bat";
      ls = "eza";
      speedtest = "speedtest --bytes";
      df = "df --human-readable";
      du = "du --human-readable --summarize";
      tree = "tree -L 2";
      wakeMATPC = "wakeonlan D8:BB:C1:02:2D:5C";
      copilot = "nix shell nixpkgs#nodejs -c npx --yes @github/copilot";
    };
    interactiveShellInit = "set -g fish_greeting";
  };
}
