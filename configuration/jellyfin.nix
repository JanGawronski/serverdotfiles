{ ... }:
{
  services.jellyfin = {
    enable = true;
    dataDir = "/srv/data/private/jellyfin";
    openFirewall = false;
  };

  services.nginx.virtualHosts."media.jarzab.net.pl" = {
    enableACME = true;
    forceSSL = true;
    locations."/" = {
      proxyPass = "http://127.0.0.1:8096";
      proxyWebsockets = true;
      recommendedProxySettings = true;
    };
  };

  security.acme.acceptTerms = true;
}
