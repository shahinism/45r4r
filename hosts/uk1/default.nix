{ config, pkgs, inputs, ... }: {
  imports = [ ./hardware-configuration.nix ];
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  boot.tmp.cleanOnBoot = true;
  zramSwap.enable = true;
  networking.hostName = "uk1";
  networking.domain = "";
  services.openssh.enable = true;
  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMxr0CoUGmzn4nPIhddJbZzOYy1WpCkewbiSTa8BKp4c shahin"
  ];

  programs = { mosh.enable = true; };

  # Enable Tailscale
  environment.systemPackages = with pkgs; [ tailscale ];

  services = { tailscale = { enable = true; }; };

  networking.firewall = {
    # enable the firewall
    enable = true;

    # always allow traffic from your Tailscale network
    trustedInterfaces = [ "tailscale0" ];

    # allow the Tailscale UDP port through the firewall
    allowedUDPPorts = [ config.services.tailscale.port ];

    # allow you to SSH in over the public internet
    allowedTCPPorts = [ ];
  };

  # Nextcloud
  services.nextcloud = {
    enable = true;
    https = true;
    package = pkgs.nextcloud28;
    datadir = "/data/nextcloud";
    hostName = "uk1.starling-goldeye.ts.net";
    database.createLocally = true;
    config = {
      dbtype = "pgsql";
      adminpassFile = "/etc/nextcloud-admin-pass";
    };
    # settings = {
    #   trusted_domains = [ "uk1.starling-goldeye.ts.net" ];
    #   trusted_proxies = [ ];
    # };
  };

  # services.nginx.virtualHosts.${config.services.nextcloud.hostName} = {
  #   forceSSL = true;
  #   sslCertificate =
  #     "/etc/ssl/certs/private/${config.services.nextcloud.hostName}.crt";
  #   sslCertificateKey =
  #     "/etc/ssl/certs/private/${config.services.nextcloud.hostName}.key";
  # };

  services.nginx.enable = false;
  services.caddy = {
    enable = true;
    virtualHosts = {
      "${config.services.nextcloud.hostName}" = {
        extraConfig = ''
          redir /.well-known/carddav /remote.php/dav 301
          redir /.well-known/caldav /remote.php/dav 301

          @forbidden {
              path /.htaccess
              path /data/*
              path /config/*
              path /db_structure
              path /.xml
              path /README
              path /3rdparty/*
              path /lib/*
              path /templates/*
              path /occ
              path /console.php
          }
          respond @forbidden 404

          root * ${config.services.nextcloud.package}
          file_server
          php_fastcgi unix//run/phpfpm/nextcloud.sock
        '';
      };
    };
  };

  system.stateVersion = "23.11";
}
