{ pkgs, ... }:
{
  imports = [
    ./hyprland.nix
    ./waybar.nix
    ./firefox.nix
    ./alacritty.nix
    ./rofi.nix
    ./dunst.nix
    ./activitywatch.nix
    ./input-remapper.nix
  ];

  home.packages = with pkgs; [
    flameshot
    okular
    pavucontrol
    ncpamixer
    audacity
    gimp
    inkscape
    wl-clipboard
    slurp
    grim
    networkmanagerapplet
    blueman
    xss-lock
    udiskie
    betterlockscreen
    brightnessctl
    rpi-imager
    pulseaudioFull
    obs-studio
    vlc
    autorandr
    libreoffice
    anki-bin
    appimage-run
    protonvpn-cli
    wireguard-tools
    deluge-gtk

    localsend
    libsForQt5.ktouch

    tailscale-systray
    # Use tablet as touch screen
    weylus
    xournalpp

    # Required by emacs-everywhere
    # https://github.com/tecosaur/emacs-everywhere
    xclip
    xdotool
    xorg.xprop
    xorg.xwininfo

    teams-for-linux
    zoom-us
    remmina
    feh

    tuxguitar
    musescore

    qutebrowser
  ];

  # TODO move it to CLI feature.
  services.gpg-agent = {
    enable = true;
    enableSshSupport = true;
    pinentryPackage = pkgs.pinentry-tty;
    enableZshIntegration = true;
    extraConfig = ''
      allow-emacs-pinentry
      allow-loopback-pinentry
    '';
  };

  # Set mimeapps for default applications
  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "x-scheme-handler/http" = "firefox.desktop";
      "x-scheme-handler/https" = "firefox.desktop";
      "application/x-extension-htm" = "firefox.desktop";
      "application/x-extension-html" = "firefox.desktop";
      "application/x-extension-shtml" = "firefox.desktop";
      "application/x-extension-xhtml" = "firefox.desktop";
      "application/x-extension-xht" = "firefox.desktop";
      "audio/x-ms-asx" = "vlc.desktop";
      "audio/x-ms-wma" = "vlc.desktop";
      "audio/mp2" = "vlc.desktop";
      "audio/x-mpegurl" = "vlc.desktop";
      "audio/ogg" = "vlc.desktop";
      "audio/x-scpls" = "vlc.desktop";
      "audio/mpeg" = "vlc.desktop";
      "audio/x-wav" = "vlc.desktop";
      "audio/aac" = "vlc.desktop";
      "audio/mp4" = "vlc.desktop";
      "audio/vnd.rn-realaudio" = "vlc.desktop";
      "text/x-c++src" = "emacsclient.desktop";
      "text/x-pascal" = "emacsclient.desktop";
      "text/x-google-video-pointer" = "emacsclient.desktop";
      "text/x-c++hdr" = "emacsclient.desktop";
      "text/html" = "emacsclient.desktop";
      "text/plain" = "emacsclient.desktop";
      "text/tcl" = "emacsclient.desktop";
      "text/x-csrc" = "emacsclient.desktop";
      "text/x-makefile" = "emacsclient.desktop";
      "text/x-chdr" = "emacsclient.desktop";
      "text/x-tex" = "emacsclient.desktop";
      "text/x-java" = "emacsclient.desktop";
      "text/x-moc" = "emacsclient.desktop";
      "video/3gpp" = "vlc.desktop";
      "video/ogg" = "vlc.desktop";
      "video/quicktime" = "vlc.desktop";
      "video/x-ms-wmv" = "vlc.desktop";
      "video/vnd.rn-realvideo" = "vlc.desktop";
      "video/mp4" = "vlc.desktop";
      "video/mpeg" = "vlc.desktop";
      "video/x-matroska" = "vlc.desktop";
      "video/x-flic" = "vlc.desktop";
      "video/x-msvideo" = "vlc.desktop";
      "video/x-theora+ogg" = "vlc.desktop";
      "video/x-flv" = "vlc.desktop";
      "application/x-xpinstall" = "firefox.desktop";
      "application/xhtml+xml" = "firefox.desktop";
      "application/xml" = "firefox.desktop";
      "application/json" = "firefox.desktop";
    };
  };
}
