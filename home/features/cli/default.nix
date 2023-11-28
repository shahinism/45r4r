{ pkgs, ... }: {
  imports = [ ./aliases.nix ./nushell.nix ./bash.nix ./zellij.nix ./atuin.nix ];

  home.packages = with pkgs; [
    killall
    fzf
    gnupg
    ripgrep
    ranger # muscle memory
    yazi # doesn't seem stable

    yubikey-personalization
    yubikey-manager
    pcscliteWithPolkit
    bash-completion

    # A cross-platform graphical process/system monitor with a
    # customizable interface: https://github.com/ClementTsang/bottom
    bottom
    # A very fast implementation of tldr in Rust:
    # https://github.com/dbrgn/tealdeer
    tealdeer

    procs
    bandwhich

    fd
    rm-improved
    jc
    jq
    asciinema
    mosh
    magic-wormhole
    sshuttle
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
