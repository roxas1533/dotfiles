{ inputs }:
[
  # Custom overlays
  (import ./mcp-server-mysql.nix { inherit inputs; })
]
