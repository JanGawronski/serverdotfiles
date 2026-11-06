{ config, pkgs, ... }:
{
  imports = [
    ./agenix.nix
    ./bootloader.nix
    ./dconf.nix
    ./dynamiclinking.nix
    ./experimental.nix
    ./firewall.nix
    ./fish.nix
    ./fonts.nix
    ./hardware-configuration.nix
    ./hostname.nix
    ./guestuserssh.nix
    ./kernel.nix
    ./keymap.nix
    ./musicbot.nix
    ./networking.nix
    ./filegator.nix
    ./immich.nix
    ./pamsshd.nix
    ./root.nix
    ./rtkit.nix
    ./ssh.nix
    ./stateversion.nix
    ./timezone.nix
    ./tor.nix
    ./unfree.nix
    ./user.nix
    ./vim.nix
    ./zoxide.nix
  ];

  services.ollama = {
    enable = true;
    package = pkgs.ollama-rocm;
    host = "0.0.0.0";
  };

  environment.systemPackages = (import ./packages.nix { inherit pkgs; }).basePackages;
}
