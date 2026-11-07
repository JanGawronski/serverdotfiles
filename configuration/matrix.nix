{ config, pkgs, ... }:

let
  homeserver = "matrix.jarzab.net.pl";
  element = "element.jarzab.net.pl";
  rtc = "rtc.jarzab.net.pl";
  matrixPort = 8008;
  livekitPort = 7880;
  jwtPort = config.services.lk-jwt-service.port;
in
{
  services.matrix-synapse = {
    enable = true;
    settings = {
      database.name = "sqlite3";
      registration_shared_secret_path =
        config.age.secrets.matrix-registration-shared-secret.path;
      server_name = homeserver;
      public_baseurl = "https://${homeserver}/";
      enable_registration = false;
      report_stats = false;
      listeners = [
        {
          bind_addresses = [ "127.0.0.1" ];
          port = matrixPort;
          type = "http";
          tls = false;
          x_forwarded = true;
          resources = [
            {
              names = [ "client" "federation" ];
              compress = true;
            }
          ];
        }
      ];
      experimental_features = {
        msc4143_enabled = true;
        msc4222_enabled = true;
      };
      max_event_delay_duration = "24h";
      rc_message = {
        per_second = 0.5;
        burst_count = 30;
      };
      rc_delayed_event_mgmt = {
        per_second = 1;
        burst_count = 20;
      };
      matrix_rtc.transports = [
        {
          type = "livekit";
          livekit_service_url = "https://${rtc}/livekit/jwt";
        }
      ];
    };
  };

  services.livekit = {
    enable = true;
    openFirewall = false;
    keyFile = config.age.secrets.matrix-livekit-key.path;
    settings = {
      port = livekitPort;
      rtc = {
        tcp_port = 7881;
        udp_port = 7882;
        node_ip = "185.239.41.4";
      };
      room.auto_create = false;
    };
  };

  services.lk-jwt-service = {
    enable = true;
    livekitUrl = "wss://${rtc}/livekit/sfu";
    keyFile = config.age.secrets.matrix-livekit-key.path;
  };

  systemd.services.lk-jwt-service.environment.LIVEKIT_FULL_ACCESS_HOMESERVERS = homeserver;

  services.nginx = {
    enable = true;
    recommendedGzipSettings = true;
    recommendedOptimisation = true;
    recommendedTlsSettings = true;
    virtualHosts = {
      "${homeserver}" = {
        enableACME = true;
        forceSSL = true;
        locations."/.well-known/matrix/server" = {
          extraConfig = ''
            default_type application/json;
            return 200 '{"m.server":"${homeserver}:443"}';
          '';
        };
        locations."/.well-known/matrix/client" = {
          extraConfig = ''
            default_type application/json;
            add_header Access-Control-Allow-Origin "*" always;
            return 200 '{"m.homeserver":{"base_url":"https://${homeserver}"},"org.matrix.msc4143.rtc_foci":[{"type":"livekit","livekit_service_url":"https://${rtc}/livekit/jwt"}]}';
          '';
        };
        locations."/_matrix".proxyPass = "http://127.0.0.1:${toString matrixPort}";
        locations."/_synapse".proxyPass = "http://127.0.0.1:${toString matrixPort}";
      };

      "${element}" = {
        enableACME = true;
        forceSSL = true;
        root = pkgs.element-web.override {
          conf = {
            "m.homeserver" = {
              base_url = "https://${homeserver}";
              server_name = homeserver;
            };
            default_server_config = {
              "m.homeserver" = {
                base_url = "https://${homeserver}";
                server_name = homeserver;
              };
            };
            "org.matrix.msc4143.rtc_foci" = [
              {
                type = "livekit";
                livekit_service_url = "https://${rtc}/livekit/jwt";
              }
            ];
          };
        };
      };

      "${rtc}" = {
        enableACME = true;
        forceSSL = true;
        locations."^~ /livekit/jwt/" = {
          proxyPass = "http://127.0.0.1:${toString jwtPort}/";
          proxyWebsockets = true;
          recommendedProxySettings = true;
        };
        locations."^~ /livekit/sfu/" = {
          proxyPass = "http://127.0.0.1:${toString livekitPort}/";
          proxyWebsockets = true;
          recommendedProxySettings = true;
          extraConfig = ''
            proxy_buffering off;
            proxy_read_timeout 120s;
            proxy_send_timeout 120s;
          '';
        };
      };
    };
  };

  security.acme = {
    acceptTerms = true;
    defaults.email = "coolmatteen@gmail.com";
  };
}
