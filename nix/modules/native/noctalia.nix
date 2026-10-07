# Noctalia desktop shell configuration
# Replaces: hyprpaper (wallpaper), ashell (bar), swaync (notifications), swayosd (OSD), walker (launcher)
{ pkgs, inputs, ... }:

let
  wallpaper = pkgs.fetchurl {
    url = "https://r2.ro15.dev/wallpaper/atri_sora.jpg";
    sha256 = "sha256-NbaeV7SN12JaIXM0y2lCUNA6j5U30rA8mWI0w8Gt5J0=";
  };

  # Patch noctalia to use WlrLayer.Bottom so floating windows render above the bar
  noctalia-patched =
    inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default.overrideAttrs
      (old: {
        patches = (old.patches or [ ]) ++ [ ../../patches/noctalia-layer-bottom.patch ];
      });
in
{
  imports = [
    inputs.noctalia.homeModules.default
  ];

  # Settings are managed via dotfile symlink (dotfiles/noctalia/ → ~/.config/noctalia/)
  programs.noctalia = {
    enable = true;
    package = noctalia-patched;
  };

  # Expose the nix-store wallpaper at a stable home path so config.toml can reference it
  home.file."Pictures/Wallpapers/atri_sora.jpg".source = wallpaper;
}
