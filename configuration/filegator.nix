{ config, pkgs, ... }:

let
  appRoot = "/var/lib/filegator/filegator";
  dataRoot = "/srv/data/public/cieplabaza";
  filegator = pkgs.fetchzip {
    url = "https://raw.githubusercontent.com/filegator/static/604fdfe167f135b56d8615e2ddbdc4949fc9b2f9/builds/filegator_latest.zip";
    hash = "sha256-DUR/wv8wBQN41006TnlZyR0cgiTlAvK8D84o52kUfc0=";
    stripRoot = false;
  };
  php = pkgs.php.withExtensions ({ enabled, all }: enabled ++ (with all; [
    dom
    mbstring
    xml
    zip
  ]));
in
{
  users.groups.filegator = { };
  users.users.filegator = {
    isSystemUser = true;
    group = "filegator";
  };

  systemd.tmpfiles.rules = [
    "d /var/lib/filegator 0750 filegator nginx -"
    "d ${appRoot} 0750 filegator nginx -"
    "d ${dataRoot} 0770 filegator nginx -"
    "d ${appRoot}/private 0770 filegator nginx -"
    "d ${appRoot}/private/logs 0770 filegator nginx -"
    "d ${appRoot}/private/sessions 0770 filegator nginx -"
    "d ${appRoot}/private/tmp 0770 filegator nginx -"
  ];

  systemd.services.filegator-init = {
    description = "Initialize FileGator application files";
    wantedBy = [ "multi-user.target" ];
    before = [ "phpfpm-filegator.service" "nginx.service" ];
    after = [ "systemd-tmpfiles-setup.service" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      User = "root";
    };
    script = ''
      set -eu

      mkdir -p ${appRoot}/private/{logs,sessions,tmp}
      cp -rn ${filegator}/filegator/private/. ${appRoot}/private/
      chown filegator:nginx /var/lib/filegator ${appRoot}
      chmod 0750 /var/lib/filegator ${appRoot}
      chown -R nginx:nginx ${appRoot}/private ${dataRoot}
      chmod 0770 ${appRoot}/private ${appRoot}/private/{logs,sessions,tmp} ${dataRoot}

      for item in ${filegator}/filegator/*; do
        name="$(basename "$item")"
        case "$name" in
          private|repository|configuration.php)
            continue
            ;;
        esac
        rm -rf "${appRoot}/$name"
        cp -r "$item" "${appRoot}/$name"
      done

      rm -rf ${appRoot}/repository
      ln -s ${dataRoot} ${appRoot}/repository

      if [ ! -e ${appRoot}/configuration.php ]; then
        csrf_key="$(od -An -N32 -tx1 /dev/urandom | tr -d ' \n')"
        cat > ${appRoot}/configuration.php <<PHP
<?php

return [
    'public_path' => APP_PUBLIC_PATH,
    'public_dir' => APP_PUBLIC_DIR,
    'overwrite_on_upload' => false,
    'timezone' => 'Europe/Warsaw',
    'download_inline' => ['pdf', 'mp3', 'wav', 'ogg', 'm4a', 'flac'],
    'lockout_attempts' => 5,
    'lockout_timeout' => 900,
    'frontend_config' => [
        'app_name' => 'Cieplabaza',
        'app_version' => APP_VERSION,
        'language' => 'polish',
        'logo' => "",
        'upload_max_size' => 10 * 1024 * 1024 * 1024,
        'upload_chunk_size' => 1 * 1024 * 1024,
        'upload_simultaneous' => 3,
        'default_archive_name' => 'archive.zip',
        'editable' => ['.txt', '.md', '.json', '.csv', '.log'],
        'date_format' => 'DD/MM/YYYY HH:mm:ss',
        'guest_redirection' => "",
        'search_simultaneous' => 5,
        'filter_entries' => [],
        'pagination' => ["", 25, 50, 100],
    ],
    'services' => [
        'Filegator\Services\Logger\LoggerInterface' => [
            'handler' => '\\Filegator\Services\Logger\Adapters\MonoLogger',
            'config' => [
                'monolog_handlers' => [
                    function () {
                        return new \Monolog\Handler\StreamHandler(
                            __DIR__ . '/private/logs/app.log',
                            \Monolog\Logger::DEBUG
                        );
                    },
                ],
            ],
        ],
        'Filegator\Services\Session\SessionStorageInterface' => [
            'handler' => '\\Filegator\Services\Session\Adapters\SessionStorage',
            'config' => [
                'handler' => function () {
                    return new \Symfony\Component\HttpFoundation\Session\Storage\NativeSessionStorage([
                        'cookie_samesite' => 'Lax',
                        'cookie_secure' => true,
                        'cookie_httponly' => true,
                    ]);
                },
            ],
        ],
        'Filegator\Services\Cors\Cors' => [
            'handler' => '\\Filegator\Services\Cors\Cors',
            'config' => ['enabled' => false],
        ],
        'Filegator\Services\Tmpfs\TmpfsInterface' => [
            'handler' => '\\Filegator\Services\Tmpfs\Adapters\Tmpfs',
            'config' => [
                'path' => __DIR__ . '/private/tmp/',
                'gc_probability_perc' => 10,
                'gc_older_than' => 172800,
            ],
        ],
        'Filegator\Services\Security\Security' => [
            'handler' => '\\Filegator\Services\Security\Security',
            'config' => [
                'csrf_protection' => true,
                'csrf_key' => '$csrf_key',
                'ip_allowlist' => [],
                'ip_denylist' => [],
                'allow_insecure_overlays' => false,
            ],
        ],
        'Filegator\Services\View\ViewInterface' => [
            'handler' => '\\Filegator\Services\View\Adapters\Vuejs',
            'config' => ['add_to_head' => "", 'add_to_body' => ""],
        ],
        'Filegator\Services\Storage\Filesystem' => [
            'handler' => '\\Filegator\Services\Storage\Filesystem',
            'config' => [
                'separator' => '/',
                'config' => [],
                'adapter' => function () {
                    return new \League\Flysystem\Adapter\Local(__DIR__ . '/repository');
                },
            ],
        ],
        'Filegator\Services\Archiver\ArchiverInterface' => [
            'handler' => '\\Filegator\Services\Archiver\Adapters\ZipArchiver',
            'config' => [],
        ],
        'Filegator\Services\Auth\AuthInterface' => [
            'handler' => '\\Filegator\Services\Auth\Adapters\JsonFile',
            'config' => ['file' => __DIR__ . '/private/users.json'],
        ],
        'Filegator\Services\Router\Router' => [
            'handler' => '\\Filegator\Services\Router\Router',
            'config' => [
                'query_param' => 'r',
                'routes_file' => __DIR__ . '/backend/Controllers/routes.php',
            ],
        ],
    ],
];
PHP
        chown filegator:nginx ${appRoot}/configuration.php
        chmod 0640 ${appRoot}/configuration.php
      fi

      sed -i "s/'download_inline' => \[[^]]*\]/'download_inline' => ['pdf', 'mp3', 'wav', 'ogg', 'm4a', 'flac']/" \
        ${appRoot}/configuration.php

      if [ ! -e ${appRoot}/private/users.json ]; then
        cp ${appRoot}/private/users.json.blank ${appRoot}/private/users.json
        chown filegator:nginx ${appRoot}/private/users.json
        chmod 0640 ${appRoot}/private/users.json
      fi
    '';
  };

  services.phpfpm.pools.filegator = {
    user = "nginx";
    group = "nginx";
    phpPackage = php;
    settings = {
      "listen.owner" = "nginx";
      "listen.group" = "nginx";
      "pm" = "dynamic";
      "pm.max_children" = 8;
      "pm.start_servers" = 2;
      "pm.min_spare_servers" = 1;
      "pm.max_spare_servers" = 4;
      "pm.max_requests" = 500;
    };
    phpOptions = {
      "date.timezone" = "Europe/Warsaw";
      "upload_max_filesize" = "10G";
      "post_max_size" = "10G";
      "max_execution_time" = 3600;
      "max_input_time" = 3600;
    };
  };

  services.nginx = {
    enable = true;
    recommendedGzipSettings = true;
    recommendedOptimisation = true;
    recommendedTlsSettings = true;
    virtualHosts = {
      "server.jarzab.net.pl" = {
        default = true;
        enableACME = true;
        forceSSL = true;
        locations."/" = {
          return = "404";
        };
      };
      "files.jarzab.net.pl" = {
        enableACME = true;
        forceSSL = true;
        root = "${appRoot}/dist";
        locations."/" = {
          index = "index.php";
          tryFiles = "$uri $uri/ /index.php?r=$uri&$args";
        };
        locations."~ \\.php$" = {
          extraConfig = ''
            include ${pkgs.nginx}/conf/fastcgi.conf;
            fastcgi_param SCRIPT_FILENAME ${appRoot}/dist$fastcgi_script_name;
            fastcgi_pass unix:${config.services.phpfpm.pools.filegator.socket};
          '';
        };
        locations."~ /\\." = {
          extraConfig = "deny all;";
        };
      };
    };
  };

  security.acme.acceptTerms = true;
}
