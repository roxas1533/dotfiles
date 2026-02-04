{ inputs }:
[
  # Custom overlays
  (import ./mcp-language-server.nix { inherit inputs; })
]
