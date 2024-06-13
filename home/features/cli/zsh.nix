{ pkgs, ... }: {
  programs.zsh = {
    enable = true;
    syntaxHighlighting = { enable = true; };
    autosuggestion = { enable = true; };
    initExtra = builtins.readFile ./functions.sh;
  };
}
