{ config, pkgs, ... }:

let
  syncting = { };
in
{

  imports = [
    ./nix.nix
    ./keyd.nix
    ./desktop.nix
    ./security.nix
    ./experimental.nix
  ];

  # TODO switch to Caddy if it can enable SSL for localhost
  services.nginx = {
    enable = true;
    virtualHosts."syncthing" = {
      locations."/".proxyPass = "http://127.0.0.1:8384";
    };
    virtualHosts."activitywatch" = {
      locations."/".proxyPass = "http://127.0.0.1:5600";
    };
  };

  # Set your time zone.
  time.timeZone = "Europe/Amsterdam";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  fonts.packages = with pkgs; [
    emacs-all-the-icons-fonts
    (nerdfonts.override {
      fonts = [
        "Inconsolata"
        "FiraCode"
        "Hack"
        "RobotoMono"
      ];
    })
  ];

  # Disable CUPS to print documents.
  services.printing.enable = false;

  # Enable pcscd, required for Yubikey to act like smart card
  services.pcscd.enable = true;
  # Enable ssh-agent
  programs.ssh.startAgent = true;

  # Enable sound with pipewire.
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    wireplumber.enable = true;
  };

  # Enable Docker
  virtualisation.docker.enable = true;

  # Enable automatic login for the user.
  services.xserver = {
    # Enable the X11 windowing system.
    enable = true;
    # Configure keymap in X11
    xkb = {
      layout = "us";
      variant = "";
    };

    # qtile
    windowManager.qtile.enable = true;
  };

  services.displayManager = {
    sddm.enable = true;
    sessionPackages = [ pkgs.qtile-unwrapped ];
  };

  # Enable input remapper in order to help with configuring custom
  # inputs for Mouse
  services.input-remapper.enable = true;

  programs.hyprland = {
    enable = true;
  };
  # Define the default session manager
  services.displayManager.defaultSession = "hyprland";

  # Enable touchpad support (enabled default in most desktopManager).
  services.libinput.enable = true;

  environment.variables = {
    # fix for this curl issue with https requests: https://github.com/NixOS/nixpkgs/issues/148686
    CURL_CA_BUNDLE = "/etc/pki/tls/certs/ca-bundle.crt"; # this is the value of $SSL_CERT_FILE ; may be brittle
  };

  # Workaround for GNOME autologin: https://github.com/NixOS/nixpkgs/issues/103746#issuecomment-945091229
  systemd.services."getty@tty1".enable = false;
  systemd.services."autovt@tty1".enable = false;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  # Automatic Nix garbage collection
  nix.gc.automatic = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  programs.zsh.enable = true;
  users.users = {
    # TODO make this from local configuration
    "shahin" = {
      shell = pkgs.zsh;
      isNormalUser = true;
      description = "Shahin";
      extraGroups = [
        "networkmanager"
        "wheel"
        "docker"
      ];
      packages = [ ];
    };
  };

  # Bluetooth
  services.blueman.enable = true;
  # TODO make sure to enable me only on desktops
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };
  # It's needed to explicitly disable this, as this is enabled by
  # default on Gnome, and prevents using tlp:
  # https://discourse.nixos.org/t/cant-enable-tlp-when-upgrading-to-21-05/13435
  services.power-profiles-daemon.enable = false;
  services.tlp = {
    enable = true;
    settings = {
      #https://linrunner.de/tlp/settings/platform.html
      PLATFORM_PROFILE_ON_AC = "performance";
      PLATFORM_PROFILE_ON_BAT = "low-power";

      # https://discourse.nixos.org/t/how-to-switch-cpu-governor-on-battery-power/8446/4
      # https://linrunner.de/tlp/settings/processor.html
      CPU_SCALING_GOVERNOR_ON_AC = "performance";
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

      CPU_ENERGY_PERF_POLICY_ON_AC = "balance_performance";
      CPU_ENERGY_PERF_POLICY_ON_BAT = "power";

      CPU_HWP_ON_AC = "balance_performance";
      CPU_HWP_ON_BAT = "power";

      CPU_MAX_PERF_ON_BAT = 30;

      CPU_BOOST_ON_AC = 1;
      CPU_BOOST_ON_BAT = 0;

      # https://github.com/linrunner/TLP/issues/122
      # https://linrunner.de/tlp/settings/network.html
      WIFI_PWR_ON_AC = "off";
      WIFI_PWR_ON_BAT = "on";

      CPU_HWP_DYN_BOOST_ON_AC = 1;
      CPU_HWP_DYN_BOOST_ON_BAT = 0;

      SCHED_POWERSAVE_ON_AC = 0;
      SCHED_POWERSAVE_ON_BAT = 1;

      # https://linrunner.de/tlp/settings/runtimepm.html
      RUNTIME_PM_ON_AC = "on";
      RUNTIME_PM_ON_BAT = "auto";

      # https://linrunner.de/tlp/settings/usb.html
      USB_BLACKLIST_BTUSB = 1;
    };
  };

  # Flatpak
  services.flatpak.enable = false;

  # https://nixos.wiki/wiki/NTFS
  boot.supportedFilesystems = [ "ntfs" ];

  # Memtest
  boot.loader.grub.memtest86.enable = false;

  # TODO make me conditional and customize user
  users.groups.uinput = {
    members = [ "@wheel" ];
  };

  services.udev.extraRules = ''
    KERNEL=="uinput", MODE="0660", GROUP="uinput", OPTIONS+="static_node=uinput"
  '';

  # NetworkManager
  networking.networkmanager.enable = true;
  # Firewall
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [
      # waylus
      1701 # server
      9001 # websocket
    ];

    # This is in order to help with Tailscale using exit node
    # https://github.com/tailscale/tailscale/issues/10319#issuecomment-1886730614
    checkReversePath = "loose";
  };

  # Tailscale
  environment.systemPackages = with pkgs; [ tailscale ];
  services.tailscale = {
    enable = true;
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.11"; # Did you read the comment?
}
