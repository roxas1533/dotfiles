{ pkgs, fetchFromGitHub, ... }:

pkgs.buildNpmPackage rec {
  pname = "mcp-server-mysql";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "benborla";
    repo = "mcp-server-mysql";
    rev = "main";
    sha256 = "sha256-7nu3tex9AOv43YN+yZ6a2/IVrW4IR3cNyWaS7IyKxP8=";
  };

  npmDepsHash = "sha256-MZUyJGoldPnavxF1ZFNyywRpgrlkbbQGU2ylRAUBcac=";

  dontNpmBuild = true;

  meta = with pkgs.lib; {
    description = "MCP server for MySQL";
    homepage = "https://github.com/benborla/mcp-server-mysql";
    license = licenses.mit;
    maintainers = [ ];
    platforms = platforms.all;
  };
}