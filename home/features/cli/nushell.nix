{ pkgs, config, ... }: {
  
  programs.nushell.enable = true;
  # https://github.com/rsteube/carapace-bin
  home.packages = with pkgs; [ carapace nu_scripts ];

  services.pueue = {
    enable = true;
    settings = {
      shared.use_unix_socket = true;
      daemon.default_parallel_tasks = 5;
    };
  };

  home.file = {
    # ".config/nushell" = {
    #   # FIXME find a way to not hardcode the path:
    #   # https://github.com/nix-community/home-manager/issues/676#issuecomment-1595795685
    #   source = config.lib.file.mkOutOfStoreSymlink
    #     "${config.home.homeDirectory}/.config/45rar/home/features/cli/nushell/";
    # };

    ".nu_scripts.nu" = {
      text = ''
      # maybe useful functions
      use ${pkgs.nu_scripts}/share/nu_scripts/modules/background_task/job.nu *

      # completions
      use ${pkgs.nu_scripts}/share/nu_scripts/custom-completions/git/git-completions.nu *
      use ${pkgs.nu_scripts}/share/nu_scripts/custom-completions/btm/btm-completions.nu *
      use ${pkgs.nu_scripts}/share/nu_scripts/custom-completions/cargo/cargo-completions.nu *
      use ${pkgs.nu_scripts}/share/nu_scripts/custom-completions/nix/nix-completions.nu *
      use ${pkgs.nu_scripts}/share/nu_scripts/custom-completions/tealdeer/tldr-completions.nu *
      use ${pkgs.nu_scripts}/share/nu_scripts/custom-completions/zellij/zellij-completions.nu *
    '';
    };
  };
}
