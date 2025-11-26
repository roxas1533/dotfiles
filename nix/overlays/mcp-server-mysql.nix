{ inputs }:

final: prev:
let
  node2nixPackages = import ../node2nix {
    pkgs = prev;
    inherit (prev) system;
  };

  # Convert package-lock.json to version 2
  convertedSrc = prev.stdenv.mkDerivation {
    name = "mcp-server-mysql-source";
    src = inputs.mcp-server-mysql;
    buildInputs = [ prev.nodejs ];
    buildPhase = ''
      if [ -f package-lock.json ]; then
        npm install --lockfile-version=2 --package-lock-only --ignore-scripts
      fi
    '';
    installPhase = ''
      mkdir -p $out
      cp -r . $out/
    '';
  };
in
{
  mcp-server-mysql = node2nixPackages.package.override {
    src = convertedSrc;
  };
}
