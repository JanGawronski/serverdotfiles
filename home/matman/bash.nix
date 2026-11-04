{
  programs.bash = {
    enable = true;

    bashrcExtra = ''
      if [[ -n "$SSH_CONNECTION" && $- == *i* ]] &&
         command -v fish >/dev/null 2>&1; then
        exec fish
      fi
    '';

    profileExtra = ''
      [[ -f ~/.bashrc ]] && source ~/.bashrc
    '';
  };
}
