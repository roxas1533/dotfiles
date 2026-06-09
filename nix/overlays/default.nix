{ inputs }:
[
  # Custom overlays
  (import ./mcp-language-server.nix { inherit inputs; })
  (import ./hazkey.nix)
  (import ./wezterm.nix { inherit inputs; })
  (import ./remmina.nix)
  (import ./hyprexpo.nix { inherit inputs; })
]
