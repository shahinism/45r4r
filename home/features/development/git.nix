{ pkgs, config, ... }:
{
  home.packages = with pkgs; [ git-extras ];

  programs.git = {
    enable = true;

    # TODO read from a config file
    userName = config.local.userName;
    userEmail = config.local.gitEmail;

    signing = {
      signByDefault = true;
      # defining it ismportant for tools like pass.
      # TODO read from a config file
      key = config.local.email;
    };

    includes = [
      {
        path = "~/.config/git/includes/DataChef";
        condition = "gitdir:~/projects/DataChef/";
      }
    ];

    extraConfig = {
      init = {
        # Set default branch name to main, to shut the client up for
        # reminding you of it.
        defaultBranch = "main";
      };
      push = {
        # Automatically set the remote when pushing.
        autoSetupRemote = true;
      };
    };
  };

  # TODO allow for custom imports
}
