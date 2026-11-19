{ pkgs, ... }:
{
  systemd.services.familytreewebsite = {
    description = "Drzewo Genealogiczne Rodziny Jarząb";
    wantedBy = [ "multi-user.target" ];
    after = [ "network.target" ];
    serviceConfig = {
      Type = "simple";
      User = "matman";
      WorkingDirectory = "/home/matman/jarzabdrzewosite";
      ExecStart = "${pkgs.python3}/bin/python3 /home/matman/jarzabdrzewosite/server.py";
      Restart = "always";
      RestartSec = "10s";
      Environment = "PORT=5050";
    };
  };

  services.nginx.virtualHosts."rodzina.jarzab.net.pl" = {
    enableACME = true;
    forceSSL = true;
    locations."/" = {
      proxyPass = "http://127.0.0.1:5050";
      proxyWebsockets = true;
      recommendedProxySettings = true;
    };
  };

  security.acme.acceptTerms = true;
}
