{ ... }: {
  services.keyd = {
    enable = true;
    keyboards.internal = {
      ids = [ "*" ];
      settings = {
        main = {
          a = "overloadt2(meta, a, 200)";
          s = "overloadt2(alt, s, 200)";
          d = "overloadt2(control, d, 200)";
          f = "overloadt2(shift, f, 200)";
          j = "overloadt2(shift, j, 200)";
          k = "overloadt2(control, k, 200)";
          l = "overloadt2(alt, l, 200)";
          ";" = "overloadt2(meta, ;, 200)";
        };
      };
    };
  };
}
