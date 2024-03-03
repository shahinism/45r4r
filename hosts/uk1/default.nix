{ config, pkgs, inputs, ... }: {
  imports =
    [ ./hardware-configuration.nix ./firewall.nix ./caddy.nix ./tailscale.nix ];
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

  system.stateVersion = "23.11";
}
