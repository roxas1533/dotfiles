{ inputs }:

final: prev:
let
  # Must be the same Hyprland the compositor runs, or the plugin's ABI hash check
  # rejects it at load time. configuration.nix runs nixpkgs' Hyprland.
  hyprlandPkg = prev.hyprland;
in
{
  hyprlandPlugins = (prev.hyprlandPlugins or { }) // {
    hyprexpo = prev.hyprlandPlugins.mkHyprlandPlugin {
      pluginName = "hyprexpo";
      version = "fork-${inputs.hyprexpo-fork.shortRev or "dirty"}";
      src = inputs.hyprexpo-fork;
      hyprland = hyprlandPkg;

      # Unpatched: the fork targets Hyprland v0.56.2's internals, and hyprland.lua
      # picks the grid overview through its own overview_mode option.
      patches = [ ];

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
