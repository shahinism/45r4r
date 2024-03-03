{ config, pkgs, ... }: {
  virtualisation.oci-containers = {
    backend = "docker";
    containers = {
      nextcloud = {
        image = "nextcloud/all-in-one:latest";
        autoStart = true;
        volumes = [
          "nextcloud_aio_mastercontainer=/mnt/docker-aio-config"
          "/var/run/docker.sock=/var/run/docker.sock=ro"
        ];
        ports = [ "80:80" "8080:8080" "8443:8443" ];
        extraOptions = [ ];
      };
    };
  };
}
