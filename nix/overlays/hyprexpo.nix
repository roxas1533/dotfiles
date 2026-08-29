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

      # Fork hasn't caught up with Hyprland's keybind refactor (#15568, moved
      # KeybindManager/stringToModMask to Keybinds::modMaskFromString), the
      # desktop/view/Window.hpp -> desktop/view/window/Window.hpp header move,
      # the CWindow field refactor (alpha(key) -> alpha()[key], m_pinned ->
      # m_state & WINDOW_STATE_PINNED, m_monitorMovedFrom -> m_presentation),
      # or m_isMapped becoming private (use mapped() instead).
      patches = [
        ../patches/hyprexpo-fork-keybind-modmask.patch
        ../patches/hyprexpo-fork-window-header-move.patch
        ../patches/hyprexpo-fork-window-state-refactor.patch
        ../patches/hyprexpo-fork-mapped-accessor.patch
      ];

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
