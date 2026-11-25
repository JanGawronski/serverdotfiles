{ pkgs, ... }:
{
  users.groups.familytree = { };

  users.users.familytree = {
    isSystemUser = true;
    group = "familytree";
    home = "/var/lib/familytree";
    createHome = true;
    description = "Gramps Web service user";
  };

  systemd.tmpfiles.rules = [
    "d /var/lib/familytree 0750 familytree familytree -"
    "d /var/lib/familytree/app 0750 familytree familytree -"
    "d /var/lib/familytree/data 0750 familytree familytree -"
    "d /var/lib/familytree/media 0750 familytree familytree -"
    "d /var/lib/familytree/frontend 0750 familytree familytree -"
  ];

  systemd.services.familytreewebsite = {
    description = "Drzewo Genealogiczne Rodziny Jarząb";
    wantedBy = [ "multi-user.target" ];
    after = [ "network.target" ];
    path = [
      pkgs.nix
      pkgs.bash
      pkgs.gramps
      pkgs.gtk3
      pkgs.python3
    ];
    serviceConfig = {
      Type = "simple";
      User = "familytree";
      Group = "familytree";
      WorkingDirectory = "/var/lib/familytree/app";
      ExecStart = "${pkgs.python3}/bin/python3 /var/lib/familytree/app/server.py";
      Restart = "always";
      RestartSec = "10s";
      Environment = [
        "PORT=5050"
        "HOME=/var/lib/familytree"
        "NIX_PATH=nixpkgs=flake:nixpkgs:/nix/var/nix/profiles/per-user/root/channels"
      ];

      # Sandboxing & OPSEC Hardening
      ProtectHome = true;
      ProtectSystem = "strict";
      ReadWritePaths = [
        "/var/lib/familytree"
        "/tmp"
      ];
      PrivateTmp = true;
      NoNewPrivileges = true;
      ProtectKernelTunables = true;
      ProtectControlGroups = true;
      RestrictRealtime = true;
      RestrictSUIDSGID = true;
    };
  };

  services.nginx.virtualHosts."rodzina.jarzab.net.pl" = {
    enableACME = true;
    forceSSL = true;
    locations."/" = {
      proxyPass = "http://127.0.0.1:5050";
      proxyWebsockets = true;
      recommendedProxySettings = true;
      extraConfig = ''
        proxy_read_timeout 600s;
        proxy_send_timeout 600s;
      '';
    };
  };

  security.acme.acceptTerms = true;
}
