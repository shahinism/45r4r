{ lib, ... }: {
  # This file was populated at runtime with the networking
  # details gathered from the active system.
  networking = {
    nameservers = [ "1.1.1.1" "1.0.0.1" ];
    defaultGateway = "104.248.160.1";
    defaultGateway6 = {
      address = "";
      interface = "eth0";
    };
    dhcpcd.enable = false;
    usePredictableInterfaceNames = lib.mkForce false;
    interfaces = {
      eth0 = {
        ipv4.addresses = [
          {
            address = "104.248.169.194";
            prefixLength = 20;
          }
          {
            address = "10.16.0.5";
            prefixLength = 16;
          }
        ];
        ipv6.addresses = [{
          address = "fe80::8471:61ff:fe9d:15cd";
          prefixLength = 64;
        }];
        ipv4.routes = [{
          address = "104.248.160.1";
          prefixLength = 32;
        }];
        ipv6.routes = [{
          address = "";
          prefixLength = 128;
        }];
      };
      eth1 = {
        ipv4.addresses = [{
          address = "10.106.0.2";
          prefixLength = 20;
        }];
        ipv6.addresses = [{
          address = "fe80::6480:bbff:febb:f9fb";
          prefixLength = 64;
        }];
      };
    };
  };
  services.udev.extraRules = ''
    ATTR{address}=="86:71:61:9d:15:cd", NAME="eth0"
    ATTR{address}=="66:80:bb:bb:f9:fb", NAME="eth1"
  '';
}
