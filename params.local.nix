{ config, lib, ... }:
{
  options.local = {
    user = lib.mkOption {
      type = lib.types.str;
      default = "shahin";
      description = "System username to create.";
    };

    userName = lib.mkOption {
      type = lib.types.str;
      default = "Shahin Azad";
      description = "User's full name.";
    };

    email = lib.mkOption {
      type = lib.types.str;
      default = "hi@shahinism.com";
      # TODO indicate this is used for commit signing as well
      description = "User's Email address.";
    };

    gitEmail = lib.mkOption {
      type = lib.types.str;
      default = "hi@shahinism.com";
      # TODO link to description of the reason
      description = "No reply Email address to use with Git.";
    };
  };
}
