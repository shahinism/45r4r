{ pkgs, ... }: {

  services.redshift = {
    enable = true;
    # NOTE to verify if geoclue is working, you can run `redshift -l geoclue2`
    provider = "geoclue2";
    tray = true;
  };
}
