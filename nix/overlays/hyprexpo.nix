{ inputs }:

final: prev:
let
  hyprlandPkg = inputs.hyprland.packages.${prev.stdenv.hostPlatform.system}.hyprland;
in
{
  hyprlandPlugins = (prev.hyprlandPlugins or { }) // {
    hyprexpo = prev.hyprlandPlugins.mkHyprlandPlugin {
      pluginName = "hyprexpo";
      version = "fork-${inputs.hyprexpo-fork.shortRev or "dirty"}";
      src = inputs.hyprexpo-fork;
      hyprland = hyprlandPkg;

      nativeBuildInputs = [
        prev.cmake
        prev.pkg-config
      ];
      buildInputs = [ prev.lua5_4 ];

      meta = with prev.lib; {
        description = "Hyprland workspaces overview plugin (sandwichfarm fork)";
        homepage = "https://github.com/sandwichfarm/hyprexpo";
        license = licenses.bsd3;
        platforms = platforms.linux;
      };
    };
  };
}
