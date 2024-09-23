{ ... }: {
  imports = [
    ./hardware-configuration.nix
    ./networking.nix # generated at runtime by nixos-infect
  ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  boot.tmp.cleanOnBoot = true;
  zramSwap.enable = true;
  networking.hostName = "cloud-1";
  networking.domain = "";
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      PermitRootLogin = "yes"; # FIXME
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
