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
    package = pkgs.nextcloud28;
    datadir = "/data/nextcloud";
    hostName = "localhost";
    database.createLocally = true;
    config = {
      dbtype = "pgsql";
      adminpassFile = "/etc/nextcloud-admin-pass";
    };
    settings = {
      trusted_domains = [ "uk1.starling-goldeye.ts.net" "localhost" ];
      trusted_proxies = [ ];
    };
  };

  system.stateVersion = "23.11";
}
