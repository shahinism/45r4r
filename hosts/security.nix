{ pkgs, ... }: {

  # NOTE enabling this breaks qtile from starting!
  # Enable more aggressive memory corruption mitiation
  # environment.memoryAllocator.provider = "scudo";
  # environment.variables.SCUDO_OPTIONS = "ZeroContents=1";

  # Hardening the kernel
  security.protectKernelImage = true;
  security.forcePageTableIsolation = true;
  # Allow building packages from source
  security.allowUserNamespaces = true;
  # Don't allow loading modules dynamically after boot
  security.lockKernelModules = true;

  # app armor
  security.apparmor = {
    enable = true;
    killUnconfinedConfinables = true;
    packages = with pkgs; [ apparmor-utils apparmor-profiles ];
  };

  # boot kernel parameters
  boot.kernelParams = [
    # Don't merge slabs
    "slab_nomerge"

    # Overwrite free'd pages
    "page_poison=1"

    # Enable page allocator randomization
    "page_alloc.shuffle=1"

    # Disable debugfs
    "debugfs=off"

    # Enable mitigations
    "mitigations=auto,nosmt"

    # Better entropy, may lead to longer boot time
    "random.trust_cpu=off"
    "random.trust_bootloader=off"
  ];

  boot.blacklistedKernelModules = [
    # Obscure network protocols
    "ax25"
    "netrom"
    "rose"

    # Old or rare or insufficiently audited filesystems
    "adfs"
    "affs"
    "bfs"
    "befs"
    "cramfs"
    "efs"
    "erofs"
    "exofs"
    "freevxfs"
    "f2fs"
    "hfs"
    "hpfs"
    "jfs"
    "minix"
    "nilfs2"
    "ntfs"
    "omfs"
    "qnx4"
    "qnx6"
    "sysv"
    "ufs"
  ];

  # enable firewall
  networking.firewall.enable = true;
  networking.firewall.allowedTCPPorts = [ ];
  networking.firewall.allowedUDPPorts = [ ];

  # disable coredump that could be exploited and by nature, slows down
  # the system, when something crashes.
  systemd.coredump.enable = false;

  # NOTE you can list firejailed session using `firejail --list`
  programs.firejail = {
    enable = true;
    # TODO only enable these on desktop setup
    wrappedBinaries = {
      # NOTE when managing firefox with home-manager, the name firefox
      # will be overwritten. So I use a unique name, to make the
      # wrapped binary accessible.
      jailed-firefox = {
        executable = "${pkgs.lib.getBin pkgs.firefox}/bin/firefox";
        profile = "${pkgs.firejail}/etc/firejail/firefox.profile";
      };

      tor-browser = {
        executable = "${pkgs.tor-browser-bundle-bin}/bin/tor-browser";
        profile = "${pkgs.firejail}/etc/firejail/tor-browser.profile";
      };

      slack = {
        executable = "${pkgs.lib.getBin pkgs.slack}/bin/slack";
        profile = "${pkgs.firejail}/etc/firejail/slack.profile";
      };

      brave = {
        executable = "${pkgs.lib.getBin pkgs.brave}/bin/brave";
        profile = "${pkgs.firejail}/etc/firejail/brave.profile";
      };
    };
  };

  # Enable Antivirus and keep signature DB update
  services.clamav = {
    daemon.enable = true;
    fangfrisch = {
      enable = true;
      interval = "daily";
    };
    updater = {
      enable = true;
      interval = "daily";
      frequency = 12;
    };
  };
}
