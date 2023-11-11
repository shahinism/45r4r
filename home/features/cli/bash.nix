{ pkgs, ... }: {
  programs.bash = {
    enable = true;

    initExtra = "source ${./bash/init.sh}";
    bashrcExtra = "source ${./bash/bashrc.sh}";
    profileExtra = "source ${./bash/profile.sh}";
  };

  home.file = {
    # TODO extract this scripts and make sure they are accessible on
    # all shells
    ".local/bin/nix-clean" = { source = ./. + "/bash/scripts/nix-clean"; };
  };
}
