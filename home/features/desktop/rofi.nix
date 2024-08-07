{ pkgs, ... }:

{
  programs.rofi = {
    enable = true;
    package = pkgs.rofi.override { plugins = with pkgs; [ rofi-emoji ]; };
  };

  programs.wofi = { enable = true; };

  home.file.".local/share/rofi/themes/zenburn.rasi".source =
    ./rofi/zenburn.rasi;
}
