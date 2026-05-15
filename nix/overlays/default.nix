{ inputs }:
[
  # Custom overlays
  inputs.claude-code.overlays.default
  inputs.codex-cli-nix.overlays.default
  (import ./mcp-language-server.nix { inherit inputs; })
  inputs.cloud-bugzilla-cli.overlays.default
]
