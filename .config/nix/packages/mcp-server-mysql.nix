{
  pkgs,
  fetchFromGitHub,
  nix-update-script,
  ...
}:

pkgs.buildNpmPackage {
  pname = "mcp-server-mysql";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "benborla";
    repo = "mcp-server-mysql";
    rev = "main";
    sha256 = "sha256-vd32WuWkjEiu45mTPnlGBctliGlNFaZTV4yi9KdZuBs=";
  };

  npmDepsHash = "sha256-lLXN14NayJowzHKjunBd+cJP0E+w/xALBaiuytVph/k=";

  dontNpmBuild = true;

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version=branch" ];
  };

  meta = with pkgs.lib; {
    description = "MCP server for MySQL";
    homepage = "https://github.com/benborla/mcp-server-mysql";
    license = licenses.mit;
    maintainers = [ ];
    platforms = platforms.all;
  };
}
