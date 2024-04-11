{ inputs, lib, pkgs, ... }: {
  nix = {
    settings = {
      trusted-users = [ "root" "@wheel" ];

      # Automatic Disc Optimisation
      ## This can be done manually by running `# nix-store --optimise`
      ## It also might potentially slow down builds. However, given my
      ## experience with NixOS, I think it's worth it.
      auto-optimise-store = lib.mkDefault true;
      experimental-features = [ "nix-command" "flakes" "repl-flake" ];
      warn-dirty = false;
      system-features = [ "kvm" "big-parallel" "nixos-test" ];
    };
    gc = {
      automatic = true;
      dates = "weekly";
      # Keep the last 3 generations
      options = "--delete-older-than +3";
    };

  };
}
