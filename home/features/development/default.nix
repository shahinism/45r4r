{ pkgs, inputs, ... }:
let
  python-packages = p: with p; [ ipython ];
  devpkgs = inputs.devenv.packages.x86_64-linux;
in {
  imports = [ ./git.nix ];

  home.packages = with pkgs;
    [
      gnumake
      gcc
      silver-searcher
      unzip
      aws-vault
      awscli2
      ssm-session-manager-plugin
      docker-compose
      exercism
      sbcl
      rlwrap
      dbeaver

      (python3.withPackages python-packages)

      cargo
      clippy
    ] ++ [ devpkgs.devenv ];
}
