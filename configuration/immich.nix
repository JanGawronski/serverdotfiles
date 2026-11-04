{ ... }:
{
  services.immich = {
    enable = true;
    mediaLocation = "/srv/data/private/immich";
    host = "127.0.0.1";
    port = 2283;
    openFirewall = false;
    settings = {
      newVersionCheck.enabled = false;
      server.externalDomain = "https://photos.jarzab.net.pl";
    };
  };

  systemd.tmpfiles.rules = [
    "d /srv/data/private 0751 root root -"
    "d /srv/data/private/immich 0700 immich immich -"
  ];

  services.nginx.virtualHosts."photos.jarzab.net.pl" = {
    enableACME = true;
    forceSSL = true;
    locations."/" = {
      proxyPass = "http://127.0.0.1:2283";
      proxyWebsockets = true;
      recommendedProxySettings = true;
      extraConfig = ''
        client_max_body_size 50000M;
        proxy_read_timeout 600s;
        proxy_send_timeout 600s;
      '';
    };
  };

  security.acme.acceptTerms = true;
}
