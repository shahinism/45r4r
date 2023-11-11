{ pkgs, config, ... }: {
  home.packages = with pkgs; [ atuin ];

  home.file.".local/share/atuin" = {
    source = config.lib.file.mkOutOfStoreSymlink
      "${config.home.homeDirectory}/.config/45r4r/home/features/cli/atuin";
  };
}
