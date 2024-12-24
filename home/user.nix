{ config, ... }:
{
  imports = [ ./common.nix ];

  home = rec {
    username = config.local.user;
    homeDirectory = "/home/${username}";
  };
}
