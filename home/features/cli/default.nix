{ pkgs, ... }: {
  imports = [ ./aliases.nix ./zsh.nix ./atuin.nix ];

  home.packages = with pkgs; [
    killall
    fzf
    gnupg
    ripgrep
    yazi # doesn't seem stable
    rm-improved # https://github.com/nivekuil/rip

    yubikey-personalization
    yubikey-manager
    pcscliteWithPolkit
    zsh-completions
    nix-zsh-completions

    # A cross-platform graphical process/system monitor with a
    # customizable interface: https://github.com/ClementTsang/bottom
    bottom
    # A very fast implementation of tldr in Rust:
    # https://github.com/dbrgn/tealdeer
    tealdeer

    procs
    bandwhich

    eza
    fd
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
      enableZshIntegration = true;
    };

    direnv = {
      enable = true;
      nix-direnv.enable = true;
      enableZshIntegration = true;
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
      enableZshIntegration = true;
    };

    bat = {
      enable = true;
      extraPackages = with pkgs.bat-extras; [ batdiff batman batwatch ];
    };

  };

}
