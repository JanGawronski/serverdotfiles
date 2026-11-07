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
    ./graphics.nix
    ./hardware-configuration.nix
    ./hostname.nix
    ./guestuserssh.nix
    ./kernel.nix
    ./keymap.nix
    ./matrix.nix
    ./musicbot.nix
    ./networking.nix
    ./ollama.nix
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

  environment.systemPackages = (import ./packages.nix { inherit pkgs; }).basePackages;
}
