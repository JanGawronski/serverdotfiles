{
  programs.yt-dlp = {
    enable = true;
    settings = {
      audio-format = "mp3";
      audio-quality = 0;
      remux-video = "mp4>mkv";
      sponsorblock-remove = "all";
      embed-thumbnail = true;
      embed-metadata = true;
      output = "%(title)s.%(ext)s";
    };
    extraConfig = ''
    --replace-in-metadata artist " " ""
    --replace-in-metadata title " " ""
    '';
  };
}
