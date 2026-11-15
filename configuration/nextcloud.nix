{ config, lib, pkgs, ... }:
{
  services.nextcloud = {
    enable = true;
    hostName = "cloud.jarzab.net.pl";
    https = true;
    package = pkgs.nextcloud35;
    maxUploadSize = "10G";
    database.createLocally = true;
    config.dbtype = "pgsql";
    extraApps = {
      onlyoffice = pkgs.nextcloud35Packages.apps.onlyoffice;
    };
    extraAppsEnable = true;
    settings = {
      default_phone_region = "PL";
      "overwrite.cli.url" = "https://cloud.jarzab.net.pl";
    };
  };

  services.onlyoffice = {
    enable = true;
    enableExampleServer = true;
    examplePort = 8001;
    hostname = "office.jarzab.net.pl";
    port = 8000;
    securityNonceFile = config.age.secrets.onlyoffice-nonce.path;
    jwtSecretFile = config.age.secrets.onlyoffice-jwt.path;
    wopi = true;
  };

  services.nginx.virtualHosts."cloud.jarzab.net.pl" = {
    enableACME = true;
    forceSSL = true;
  };
  services.nginx.virtualHosts."office.jarzab.net.pl" = {
    enableACME = true;
    forceSSL = true;
  };

  age.secrets.onlyoffice-nonce = {
    file = ./../secrets/onlyoffice-nonce.age;
    mode = "0440";
    group = "nginx";
  };
  age.secrets.onlyoffice-jwt = {
    file = ./../secrets/onlyoffice-jwt.age;
    mode = "0440";
    group = "onlyoffice";
  };

  security.acme.acceptTerms = true;
}
