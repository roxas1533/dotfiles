{ inputs }:

final: prev:
let
  node2nixPackages = import ../node2nix {
    pkgs = prev;
    inherit (prev) system;
  };
in
{
  mcp-server-mysql = node2nixPackages.package.override {
    src = inputs.mcp-server-mysql;
  };
}
