{
  description = "Shahin's digital life (and 45r4r) in Nix!";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.05";
    # You can access packages and modules from different nixpkgs revs
    # at the same time. Here's an working example:
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    # Also see the 'unstable-packages' overlay at 'overlays/default.nix'.

    nixpkgs-shahinism.url = "github:shahinism/nixpkgs/shahinism";
    # Home manager
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs-unstable";

    # Emacs
    emacs-overlay.url = "github:nix-community/emacs-overlay/master";
    emacs-src.url = "github:emacs-mirror/emacs/emacs-29";
    emacs-src.flake = false;

    # Add any other flake you might need
    hardware.url = "github:nixos/nixos-hardware";
    devenv.url = "github:cachix/devenv/latest";

    # Shameless plug: looking for a way to nixify your themes and make
    # everything match nicely? Try nix-colors!
    # nix-colors.url = "github:misterio77/nix-colors";
    stylix = {
      url = "github:danth/stylix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        home-manager.follows = "home-manager";
      };
    };
  };

  nixConfig = {
    extra-substituters = [
      #      "http://framework.starling-goldeye.ts.net:5000"
      "https://shahinism.cachix.org"
      "https://nix-community.cachix.org"
      "https://cuda-maintainers.cachix.org"
      "https://cache.nixos.org/"
    ];
    extra-trusted-public-keys = [
      "framework.starling-goldeye.ts.net:r79SpjobbITfeymQBw7GUNYBxGBGbFumJVdR9sdsOTM="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "shahinism.cachix.org-1:BzxJ+Ky6ASS/936XSAcq13841+hRW/FN++zOqoxtbGM="
      "cuda-maintainers.cachix.org-1:0dq3bujKpuEPMCX6U4WylrUDZ9JyUG0VpVZa7CNfq5E="
    ];

    extra-trusted-users = [ "root" "shahin" ];
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, nixpkgs-shahinism, home-manager
    , devenv, stylix, ... }@inputs:
    let
      inherit (self) outputs;
      lib = nixpkgs.lib // home-manager.lib;
      libUnstable = nixpkgs-unstable.lib // home-manager.lib;
      # Supported systems for your flake packages, shell, etc.
      systems = [ "aarch64-linux" "x86_64-linux" ];
      # This is a function that generates an attribute by calling a function you
      # pass to it, with each system as an argument
      forAllSystems = nixpkgs.lib.genAttrs systems;
      pkgsFor =
        lib.genAttrs systems (system: import nixpkgs { inherit system; });
      pkgsForUnstable = libUnstable.genAttrs systems
        (system: import nixpkgs-unstable { inherit system; });
      x86_64-linux = pkgsForUnstable.x86_64-linux;
    in {
      # Your custom packages
      # Acessible through 'nix build', 'nix shell', etc
      packages =
        forAllSystems (system: import ./pkgs nixpkgs.legacyPackages.${system});
      # Formatter for your nix files, available through 'nix fmt'
      # Other options beside 'alejandra' include 'nixpkgs-fmt'
      formatter =
        forAllSystems (system: nixpkgs.legacyPackages.${system}.alejandra);

      # Your custom packages and modifications, exported as overlays
      overlays = import ./overlays { inherit inputs outputs; };
      # Reusable nixos modules you might want to export
      # These are usually stuff you would upstream into nixpkgs
      nixosModules = import ./modules/nixos;
      # Reusable home-manager modules you might want to export
      # These are usually stuff you would upstream into home-manager
      homeManagerModules = import ./modules/home-manager;

      # NixOS configuration entrypoint
      # Available through 'nixos-rebuild --flake .#your-hostname'
      nixosConfigurations = {
        system76 = libUnstable.nixosSystem {
          specialArgs = { inherit inputs outputs; };
          modules = [ ./hosts/system76 ];
        };
        framework = libUnstable.nixosSystem {
          specialArgs = { inherit inputs outputs; };
          modules = [ ./hosts/framework ];
        };
        # TODO do you want to keep it on unstable?
        cloud-1 = libUnstable.nixosSystem {
          specialArgs = { inherit inputs outputs; };
          modules = [ ./hosts/cloud-1 ];
        };
      };

      # Standalone home-manager configuration entrypoint
      # Available through 'home-manager --flake .#your-username@your-hostname'
      homeConfigurations = {
        "shahin@system76" = home-manager.lib.homeManagerConfiguration {
          # Home-manager requires 'pkgs' instance
          pkgs = pkgsForUnstable.x86_64-linux;
          extraSpecialArgs = { inherit inputs outputs; };
          modules = [ stylix.homeManagerModules.stylix ./home/system76.nix ];
        };
        "shahin@framework" = home-manager.lib.homeManagerConfiguration {
          pkgs = pkgsForUnstable.x86_64-linux;
          extraSpecialArgs = { inherit inputs outputs; };
          modules = [ stylix.homeManagerModules.stylix ./home/framework.nix ];
        };
      };

      devShell.x86_64-linux = devenv.lib.mkShell {
        inherit x86_64-linux;
        modules = [ ./devenv.nix ];
      };
    };
}
