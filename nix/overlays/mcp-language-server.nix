{ inputs }:

final: prev: {
  mcp-language-server = prev.buildGoModule rec {
    pname = "mcp-language-server";
    version = "unstable-${builtins.substring 0 8 inputs.mcp-language-server.rev}";

    src = inputs.mcp-language-server;

    vendorHash = "sha256-WcYKtM8r9xALx68VvgRabMPq8XnubhTj6NAdtmaPa+g=";

    # Only build the main package, not tests or integration tests
    subPackages = [ "." ];

    meta = with prev.lib; {
      description = "Model Context Protocol server that exposes language server capabilities to LLMs";
      homepage = "https://github.com/isaacphi/mcp-language-server";
      license = licenses.bsd3;
      maintainers = [ ];
      mainProgram = "mcp-language-server";
    };
  };
}
