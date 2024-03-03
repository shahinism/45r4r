{ config, pkgs, ... }: {

  # Nextcloud
  services.nextcloud = {
    enable = true;

    # Pin major version. The default version is pretty old, and it's
    # only able to upgrade one major version at a time.
    package = pkgs.nextcloud28;

    # Use https for links
    https = true;
    hostName = "uk1.starling-goldeye.ts.net";

    home = "/var/lib/nextcloud";
    datadir = "/data/nextcloud";

    config = {
      dbtype = "pgsql";
      dbuser = "nextcloud";
      dbhost = "/run/postgresql";
      dbname = "nextcloud";

      # Admin User
      adminuser = "shahinism";
      # TODO: Automate this. Currently the deployment depends on
      # manually creating this file, as I don't want to expose the
      # password in the configuration.
      adminpassFile = "/etc/nextcloud-admin-pass";
    };

    settings = {
      # trusted_domains = [ "uk1.starling-goldeye.ts.net" ];
      # trusted_proxies = [ ];
      "overwrite.cli.url" =
        "https://${config.services.nextcloud.hostName}/cloud";
      overwritewebroot = "/cloud";
      enabledPreviewProviders = [
        "OC\\Preview\\BMP"
        "OC\\Preview\\GIF"
        "OC\\Preview\\JPEG"
        "OC\\Preview\\Krita"
        "OC\\Preview\\MarkDown"
        "OC\\Preview\\MP3"
        "OC\\Preview\\OpenDocument"
        "OC\\Preview\\PNG"
        "OC\\Preview\\TXT"
        "OC\\Preview\\XBitmap"
        "OC\\Preview\\HEIC"
        "OC\\Preview\\Movie"
      ];
    };
  };

  services.nginx.enable = false;

  services.phpfpm.pools.nextcloud.settings = {
    "listen.owner" = config.services.caddy.user;
    "listen.group" = config.services.caddy.group;
  };

  # Database configuration
  services.postgresql = {
    enable = true;
    ensureDatabases = [ "nextcloud" ];
    ensureUsers = [{
      name = "nextcloud";
      ensureDBOwnership = true;
    }];
  };

  # Ensure that postgres is running *before* running the setup
  systemd.services."nextcloud-setup" = {
    requires = [ "postgresql.service" ];
    after = [ "postgresql.service" ];
  };

}
