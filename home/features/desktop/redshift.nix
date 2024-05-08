{ pkgs, ... }: {

  services.redshift = {
    enable = true;
    latitude = 52.213;
    longitude = 5.2794;
    provider = "manual";
    tray = true;
  };
}
