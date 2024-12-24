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
    categories = [
      "Development"
      "TextEditor"
      "Utility"
    ];
    startupWMClass = "Emacs";
  };
  python-packages =
    p: with p; [
      grip # FIXME markdown preview, currently failing due to nix
      # package collision.
    ];
  nodejs-packages = with pkgs.nodePackages_latest; [
    js-beautify # Used by Emacs to format JavaScript code
  ];
  emacsPackage =
    with pkgs;
    (emacsPackagesFor emacs-pgtk).emacsWithPackages (
      epkgs: with epkgs; [
        # NOTE this is important for languages like C, otherwise you'll
        # face: https://github.com/nix-community/emacs-overlay/issues/341
        treesit-grammars.with-all-grammars
        vterm
      ]
    );
in
{
  home.packages =
    with pkgs;
    [
      cmake # rquired by emacs to build vterm
      zstd # Used by emacs to optimize undo history
      rustfmt # Used by Emacs to format Rust code
      rust-analyzer # Used by Emacs to provide Rust code completion
      nodejs # required by copilot
      aspell # Used with Emacs as spell checker
      aspellDicts.en
      aspellDicts.en-science
      aspellDicts.en-computers
      emacs-all-the-icons-fonts

      # Required for Emacs vterm
      libvterm
      libtool
      # (python311.withPackages python-packages)
      zip # used by org-mode to publish to ODT
    ]
    ++ nodejs-packages
    ++ [ emacsClientGuiDesktop ];

  programs.emacs = {
    enable = true;
    package = emacsPackage;
  };

  services.emacs = {
    enable = true;
    package = emacsPackage;
    defaultEditor = true;
  };

  home.file = {
    ".emacs.d" = {
      # TODO fix hardcoded path
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/cosmos/home/features/emacs/emacs.d";
    };
  };
}
