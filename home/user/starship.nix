{
  programs.starship = {
    enable = true;
    enableFishIntegration = true;
    enableTransience = true;
    settings = {
      add_newline = false;
      format = "$directory$sudo$git_branch$cmd_duration$status";
      directory = {
        format = "[$path ]($style)";
        style = "fg:#FFFFFF";
        truncation_length = 3;
        truncation_symbol = "…/";
        substitutions = {
          "~/Documents/programming/rust" = " ";
          "~/Documents/programming/python" = " ";
          "~/Documents/programming/c" = " ";
          "~/Documents/programming/erlang" = "  ";
          "~/Documents/programming/haskell" = " ";
          "~/Downloads" = "󰇚 ";
          "~/Documents/programming" = " ";
        }; 
      };
      git_branch = {
        symbol = " ";
        format = "[$symbol$branch ]($style)";
      };
      cmd_duration = {
        min_time = 100;
        format = "$duration ";
      };
      sudo = {
        format = "[sudo cached ]($style)";
        disabled = false;
      };
      status = {
        format = "[\\[$common_meaning$signal_name$maybe_int\\] ]($style)";
        disabled = false;
      };
    };
   };
}
