{ pkgs, ... }: {
  home.packages = with pkgs; [ git-extras ];

  programs.git = {
    enable = true;

    userName = "Shahin Azad";
    userEmail = "hi@shahinism.com";

    signing = {
      signByDefault = true;
      # defining it ismportant for tools like pass.
      key = "hi@shahinism.com";
    };

    includes = [{
      path = "~/.config/git/includes/DataChef";
      condition = "gitdir:~/projects/DataChef/";
    }];

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

  home.file = {
    ".config/git/includes" = {
      source = ./. + "/git/includes";
      recursive = true;
    };
  };

}
