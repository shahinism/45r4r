# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  # You can import other home-manager modules here
  imports = [
    # If you want to use modules your own flake exports (from modules/home-manager):
    # outputs.homeManagerModules.example

    # Or modules exported from other flakes (such as nix-colors):
    # inputs.nix-colors.homeManagerModules.default

    # You can also split up your configuration and import pieces of it here:
    # ./nvim.nix
    ./features/cli
    ./features/desktop
    ./features/emacs
    ./features/development
  ];

  nixpkgs = {
    # You can add overlays here
    overlays = [
      # Add overlays your own flake exports (from overlays and pkgs dir):
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.unstable-packages

      # TODO am I using both of these?
      # You can also add overlays exported from other flakes:
      inputs.emacs-overlay.overlays.default
      # Or define it inline, for example:
      (final: prev: {
        emacs29 = (prev.emacsGit.override {

        }).overrideAttrs (old: {
          name = "emacs29";
          version = "29.0-90";
          src = inputs.emacs-src;
        });
      })
    ];

    # Configure your nixpkgs instance
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
      # Workaround for https://github.com/nix-community/home-manager/issues/2942
      allowUnfreePredicate = _: true;
    };
  };

  home = {
    username = "shahin";
    homeDirectory = "/home/shahin";
  };

  # Add stuff for your user as you see fit:
  # programs.neovim.enable = true;
  # home.packages = with pkgs; [ steam ];
  home.packages = with pkgs;
  [
      gnumake
      cmake # rquired by emacs to build vterm
      gcc
      git-extras
      silver-searcher
      okular
      zstd # Used by emacs to optimize undo history
      rustfmt # Used by Emacs to format Rust code
      rust-analyzer # Used by Emacs to provide Rust code completion

      pavucontrol
      audacity

      nodejs # required by copilot
      aspell # Used with Emacs as spell checker
      aspellDicts.en
      aspellDicts.en-science
      aspellDicts.en-computers
      emacs-all-the-icons-fonts

      # Required for Emacs vterm
      libvterm
      libtool

      unzip # crucial for company-tabnine to unzip the package
      # otherwise you'll have an empty directory

      killall
      xorg.xkill

      gimp
      inkscape
      brave
      slack
      xclip
      fzf
      gnupg
      ripgrep

      pinentry-gtk2

      ranger
      direnv
      rpi-imager
      flameshot
      keybase-gui
      networkmanagerapplet
      blueman
      xss-lock
      udiskie
      betterlockscreen
      brightnessctl

      pulseaudioFull
      obs-studio
      vlc
      gnome.gnome-tweaks

      yubikey-personalization
      yubikey-manager
      pcscliteWithPolkit

      autorandr

      aws-vault
      awscli2
      ssm-session-manager-plugin

      libreoffice

      hugo

      # Nix tools
      comma # Run binaries without installing them!
      cachix # Service for Nix binary cache hosting
      nixos-option # Inspect NixOS configuration

      # Python
      # (python3.withPackages python-packages)

      bash-completion
      # zsh-completions
      docker-compose
      # Modern CLI tools
      # https://zaiste.net/posts/shell-commands-rust/
      # dust
      procs
      bottom
      tealdeer
      bandwhich
      zoxide
      fd
      rm-improved

      # AppImage
      appimage-run

      jc
      jq
      asciinema

      anki-bin
      exercism

      # Common Lisp
      sbcl
      rlwrap

      mosh
      magic-wormhole
      sshuttle

      protonvpn-cli
      mullvad-vpn
      wireguard-tools
      deluge-gtk
    ];

  # Enable home-manager
  programs.home-manager.enable = true;

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.05";
}
