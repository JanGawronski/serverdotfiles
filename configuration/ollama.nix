{ pkgs, ... }:
{
  services.ollama = {
    enable = true;
    package = pkgs.ollama-vulkan;
    host = "0.0.0.0";
  };

  systemd.services.ollama.environment.OLLAMA_IGPU_ENABLE = "1";
  systemd.services.ollama.serviceConfig.SupplementaryGroups = [ "video" "render" ];
}
