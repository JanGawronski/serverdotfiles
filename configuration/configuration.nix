{ config, lib, pkgs, inputs, hostname, ... }:
{
  imports = [
    ./../../module/configuration
    ./hardware-configuration.nix
    ./networking.nix
    ./agenix.nix
    (import ./ngrok.nix { inherit config; })
    (import ./playit.nix { inherit config; })
    (import ./../../module/configuration/hostname.nix { inherit hostname; })
    ./guestuser.nix
    ./guestuserssh.nix
    (import ./musicbot.nix { inherit config; })
  ];

  environment.systemPackages = (import ./../../module/configuration/packages.nix { inherit pkgs; }).basePackages;
}
