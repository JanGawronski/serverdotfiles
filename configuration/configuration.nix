{ config, pkgs, ... }:
{
  imports = [
    ./default.nix
    ./hardware-configuration.nix
    ./networking.nix
    ./hostname.nix
    ./guestuserssh.nix
    ./musicbot.nix
    ./filegator.nix
    ./immich.nix
  ];

  environment.systemPackages = (import ./packages.nix { inherit pkgs; }).basePackages;
}
