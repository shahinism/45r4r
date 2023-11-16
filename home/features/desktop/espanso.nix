{ ... }: {
  services.espanso.enable = true;

  home.file.".config/espanso" = {
    source = ./espanso;
    recursive = true;
  };
}
