{ pkgs, lib, config, ... }:

let
  inherit (lib) mkForce;
  inherit (config.lib.formats.rasi) mkLiteral;
  inherit (config.lib.stylix.colors.withHashtag) base00 base0D;
  rofi-pkg = pkgs.rofi-wayland;
  rofi-calc-pkg = pkgs.rofi-calc.override { rofi-unwrapped = rofi-pkg; };
in {
  programs.rofi = {
    enable = true;
    package = rofi-pkg;
    plugins = [ rofi-calc-pkg ];

    extraConfig = {
      show-icons = true;
      display-drun = " ";
      display-window = " ";
      display-combi = " ";
      display-calc = "󱖦 ";
      font = "FiraCode Nerd Font 12";

    };

    theme = {
      "*" = {
        width = mkLiteral "480";
        border-radius = mkLiteral "5px";
      };

      inputbar = {
        border = mkLiteral "1px";
        border-color = mkLiteral "${base0D}FF";
        padding = mkLiteral "8px 16px";
      };

      listview = {
        background-color = mkLiteral "transparent";
        margin = mkLiteral "12px 0 0";
        lines = mkLiteral "8";
        columns = mkLiteral "1";
      };

      element = {
        padding = mkLiteral "8px 16px";
        spacing = mkLiteral "8px";
        border-radius = mkLiteral "5px";
      };

    };
  };
}
