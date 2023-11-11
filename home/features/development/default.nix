{ pkgs, ... }: {
  imports = [
    ./git.nix
  ];

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

    ];
}
