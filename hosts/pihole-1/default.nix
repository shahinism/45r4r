{ config, pkgs, inputs, ... }: {
  imports = [ ./hardware-configuration.nix ];
  nix.settings.experimental-features = [ "nix-command flakes" ];

  boot.tmp.cleanOnBoot = true;
  networking.hostName = "pi3-1";

  # TODO extract and make it reusable
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      PermitRootLogin = "no";
    };
  };

  users = {
    mutableUsers = false;
    users.shahin = {
      isNormalUser = true;
      extraGroups = [ "wheel" ];
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMxr0CoUGmzn4nPIhddJbZzOYy1WpCkewbiSTa8BKp4c shahin"
      ];
    };
  };

  programs = { mosh.enable = true; };

  system.stateVersion = "23.11";
}
