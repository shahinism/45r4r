{ config, ... }:
let link = config.lib.file.mkOutOfStoreSymlink;
in {
  home.file = {
    # NOTE in practice, it's easier to just map the whole document,
    # however, `input-remapper-gtk` needs access to this directory,
    # and if in future for some reason I need to use it again to
    # generate some configuration or pause something, it'll fail.
    ".config/input-remapper-2/config.json" = {
      source = link ./input-remapper/config.json;
    };

    ".config/input-remapper-2/presets/ELECOM TrackBall Mouse DEFT Pro TrackBall/default.json" =
      {
        source = link ./input-remapper/elecom_deft_pro.json;
        target =
          ".config/input-remapper-2/presets/ELECOM TrackBall Mouse DEFT Pro TrackBall/default.json";
      };
  };
}
