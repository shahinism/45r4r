{ pkgs, ... }:
{
  stylix = {
    enable = true;
    targets = {
      gnome.enable = true;
    };

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

    polarity = "dark";
    # override = import ./stylix/modus_operandi.nix;
    # base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-latte.yaml";
    base16Scheme = "${pkgs.base16-schemes}/share/themes/tokyo-night-dark.yaml";
    #targets.alacritty.enable = false;
    targets.emacs.enable = false;
  };
}
