{ pkgs, inputs, ... }:
let
  python-packages = p: with p; [ ipython ];
  devpkgs = inputs.devenv.packages.x86_64-linux;
in {
  imports = [ ./git.nix ./pass.nix ./aws-vault.nix ./tmux.nix ];

  home.packages = with pkgs;
    [
      gnumake
      gcc
      silver-searcher
      unzip
      awscli2
      ssm-session-manager-plugin
      docker-compose
      exercism
      sbcl
      rlwrap
      dbeaver-bin

      (python3.withPackages python-packages)

      cargo
      clippy
      pipx
    ] ++ [ devpkgs.devenv ];
}
