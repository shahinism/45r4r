{ pkgs, ... }: {
  programs.alacritty = {
    enable = true;
    settings = {
      colors = {
        normal = {
          black = "#1e1e1e";
          red = "#ff5f59";
          green = "#44bc44";
          yellow = "#d0bc00";
          blue = "#2fafff";
          magenta = "#feacd0";
          cyan = "#00d3d0";
          white = "#ffffff";
        };

        bright = {
          black = "#535353";
          red = "#ff7f9f";
          green = "#00c06f";
          yellow = "#dfaf7a";
          blue = "#00bcff";
          magenta = "#b6a0ff";
          cyan = "#6ae4b9";
          white = "#989898";
        };

        cursor = {
          cursor = "#ffffff";
          text = "#000000";
        };

        primary = {
          background = "#000000";
          foreground = "#ffffff";
        };

        selection = {
          background = "#5a5a5a";
          text = "#ffffff";
        };
      };
    };
  };
}
