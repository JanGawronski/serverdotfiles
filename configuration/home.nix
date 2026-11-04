{pkgs, ...}: {
  imports = [
    ./../../module/home
  ];
  
  home.packages = (import ./../../module/home/packages.nix { inherit pkgs; }).basePackages;
}
