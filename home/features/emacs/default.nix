{ pkgs, config, ... }:

let
  emacsClientGuiDesktop = pkgs.makeDesktopItem {
    desktopName = "Emacs Client GUI";
    name = "Emacs Client GUI";
    genericName = "Text Editor";
    comment = "Edit Text";
    mimeTypes = [
      "text/english"
      "text/plain"
      "text/x-makefile"
      "text/x-c++hdr"
      "text/x-c++src"
      "text/x-chdr"
      "text/x-csrc"
      "text/x-java"
      "text/x-moc"
      "text/x-pascal"
      "text/x-tcl"
      "text/x-tex"
      "application/x-shellscript"
      "text/x-c"
      "text/x-c++"
    ];
    exec = ''emacsclient -c -a "emacs" %F'';
    icon = "emacs";
    terminal = false;
    categories = [ "Development" "TextEditor" "Utility" ];
    startupWMClass = "Emacs";
  };
in {
  home.packages = with pkgs; [
    cmake         # rquired by emacs to build vterm
    zstd          # Used by emacs to optimize undo history
    rustfmt       # Used by Emacs to format Rust code
    rust-analyzer # Used by Emacs to provide Rust code completion
    nodejs        # required by copilot
    aspell        # Used with Emacs as spell checker
    aspellDicts.en
    aspellDicts.en-science
    aspellDicts.en-computers
    emacs-all-the-icons-fonts

    # Required for Emacs vterm
    libvterm
    libtool

  ] ++ [
    emacsClientGuiDesktop
  ];

  programs.emacs = {
    enable = true;
    package = pkgs.emacs-unstable;
  };

  services.emacs = {
    enable = true;
    package = pkgs.emacs-unstable;
    defaultEditor = true;
  };

  home.file = {
    ".emacs.d" = {
      source = config.lib.file.mkOutOfStoreSymlink
        "${config.home.homeDirectory}/.config/45r4r/home/features/emacs/emacs.chemacs2/";
    };
  };

  home.file = {
    ".emacs-profiles.el" = {
      source = ./emacs-profile.el;
    };
  };
}
