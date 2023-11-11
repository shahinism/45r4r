{ config, ... }: {
  home.file = {
    ".config/qtile" = {
      source = config.lib.file.mkOutOfStoreSymlink
        "${config.home.homeDirectory}/.config/45r4r/home/features/desktop/qtile/";
    };
  };
}
