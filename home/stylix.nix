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

    image = ./assets/wallpapers/01.png;

    opacity = { terminal = 0.9; };

    polarity = "dark";
    override = import ./stylix/kaolin_mono_dark.nix;
  };
}
