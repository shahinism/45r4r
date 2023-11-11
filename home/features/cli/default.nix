{ ... }: {
  imports = [
    ./aliases.nix
    ./nushell.nix
    ./bash.nix
    ./zellij.nix
    ./atuin.nix
  ];

  programs = {
    zoxide = {
      enable = true;
      enableBashIntegration = true;
    };

    direnv = {
      enable = true;
      nix-direnv.enable = true;
      enableBashIntegration = true;
    };

    readline = {
      enable = true;
      variables = {
        completion-ignore-case = "On";
        expand-tilde = true;
      };
    };

    starship = {
      enable = true;
      promptInit = "eval \"$(starship init bash)\"";
    };

    bat = {
      enable = true;
      extraPackages = with pkgs.bat-extras; [ batdiff batman batwatch ];
    };

  };

}
