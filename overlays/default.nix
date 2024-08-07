# This file defines overlays
{ inputs, outputs, ... }: {
  # This one brings our custom packages from the 'pkgs' directory
  additions = final: _prev: import ../pkgs { pkgs = final; };

  # This one contains whatever you want to overlay
  # You can change versions, add patches, set compilation flags, anything really.
  # https://nixos.wiki/wiki/Overlays
  modifications = final: prev: {
    # example = prev.example.overrideAttrs (oldAttrs: rec {
    # ...
    # });
    qtile-unwrapped = prev.qtile-unwrapped.overrideAttrs (_: rec {
      postInstall = let
        qtileSession = ''
          [Desktop Entry]
          Name=Qtile Wayland
          Comment=Qtile on Wayland
          Exec=qtile start -b wayland
          Type=Application
        '';
      in ''
        mkdir -p $out/share/wayland-sessions
        echo "${qtileSession}" > $out/share/wayland-sessions/qtile.desktop
      '';
      passthru.providedSessions = [ "qtile" ];
    });

    ulauncher = prev.ulauncher.overrideAttrs (old: {
      nativeBuildInputs = old.nativeBuildInputs
        ++ (with prev; [ gobject-introspection ]);

      propagatedBuildInputs = with prev.python3Packages;
        old.propagatedBuildInputs ++ [ fuzzywuzzy pint pytz simpleeval ];
    });

    flameshot = prev.flameshot.overrideAttrs {
      cmakeFlags = [
        (prev.lib.cmakeBool "USE_WAYLAND_GRIM" true)
        (prev.lib.cmakeBool "USE_WAYLAND_CLIPBOARD" true)
      ];
    };
  };

  # When applied, the unstable nixpkgs set (declared in the flake inputs) will
  # be accessible through 'pkgs.unstable'
  unstable-packages = final: _prev: {
    unstable = import inputs.nixpkgs-unstable {
      system = final.system;
      config.allowUnfree = true;
    };

    shahinism = import inputs.nixpkgs-shahinism {
      system = final.system;
      config.allowUnfree = true;
    };
  };
}
