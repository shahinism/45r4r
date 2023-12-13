{ pkgs, ... }: {
  home.packages = with pkgs; [ mullvad-vpn ];
  services.mullvad-vpn.enable = true;
}
