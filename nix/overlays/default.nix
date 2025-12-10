{ inputs }:
[
  # Custom overlays
  (import ./mcp-server-mysql.nix { inherit inputs; })
  (import ./mcp-language-server.nix { inherit inputs; })
]
