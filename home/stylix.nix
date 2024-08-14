{ pkgs, ... }: {
  stylix = {
    enable = true;
    targets = { gnome.enable = true; };

    cursor = {
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Ice";
      size = 24;
    };

    fonts = {
      monospace = {
        package = pkgs.nerdfonts;
        name = "FiraCode Nerd Font";
      };

      sansSerif = {
        package = pkgs.nerdfonts;
        name = "Ubuntu Nerd Font";
      };

      serif = {
        package = pkgs.nerdfonts;
        name = "Ubuntu Nerd Font";
      };

      emoji = {
        package = pkgs.noto-fonts-emoji;
        name = "Noto Color Emoji";
      };

      sizes = {
        desktop = 10;
        applications = 10;
        terminal = 12;
      };
    };

    image = ./assets/wallpaper.png;

    opacity = { terminal = 0.9; };

    polarity = "dark";
    override = {
      scheme = "Modus Vivendi";
      base00 = "#000000";
      base01 = "#1e1e1e";
      base02 = "#535353";
      base03 = "#5a5a5a";
      base04 = "#989898";
      base05 = "#cad3f5";
      base06 = "#ffffff";
      base07 = "#ff7f8f";
      base08 = "#ff5f59";
      base09 = "#d0bc00";
      base0A = "#dfaf7a";
      base0B = "#44bc44";
      base0C = "#6ae4b9";
      base0D = "#00bcff";
      base0E = "#b6a0ff";
      base0F = "#feacd0";
    };
  };
}
