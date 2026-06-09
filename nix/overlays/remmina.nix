final: prev: {
  remmina = prev.remmina.overrideAttrs (old: {
    patches = (old.patches or [ ]) ++ [ ../patches/remmina-japanese-keyboard.patch ];
  });
}
