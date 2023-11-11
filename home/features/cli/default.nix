{ ... }: {
  imports = [
    ./nushell.nix
  ];

  programs.zoxide = {
    enable = true;
    enableBashIntegration = true;
  };

  programs.direnv = {
    enable = true;
    enableBashIntegration = true;
  };

  programs.readline = {
    enable = true;
    variables = {
      completion-ignore-case = "On";
      expand-tilde = true;
    };
  };

}
