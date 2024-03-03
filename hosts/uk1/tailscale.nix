{ pkgs, config, ... }: {
  services.tailscale = { enable = true; };

  systemd.services.tailscaled.environment = {
    # configure the Caddy user to have access to Tailscale’s socket
    TS_PERMIT_CERT_UID = "caddy";
  };

  # Enable Tailscale
  environment.systemPackages = with pkgs; [ tailscale ];
}
