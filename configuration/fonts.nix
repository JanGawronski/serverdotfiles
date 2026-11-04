{pkgs, ...}:
{
  fonts.packages = with pkgs; [
    dejavu_fonts
    nerd-fonts.fira-code
    noto-fonts-cjk-sans
    noto-fonts-color-emoji
  ];
}
