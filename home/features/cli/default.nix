{ pkgs, ... }: {
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
      enableNushellIntegration = true;
    };

    direnv = {
      enable = true;
      nix-direnv.enable = true;
      enableBashIntegration = true;
      enableNushellIntegration = true;
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
      enableBashIntegration = true;
      enableNushellIntegration = true;
    };

    bat = {
      enable = true;
      extraPackages = with pkgs.bat-extras; [ batdiff batman batwatch ];
    };

  };

}
