{ pkgs, ... }: {
  services.activitywatch = {
    enable = true;
    package = pkgs.aw-server-rust;
    watchers = {
      aw-watcher-afk.package = pkgs.activitywatch;
      aw-watcher-window.package = pkgs.activitywatch;
    };
  };
}
