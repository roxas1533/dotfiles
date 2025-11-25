{
  pkgs,
  lib,
  config,
  dotfilesDir ? "${config.home.homeDirectory}/dotfiles",
  helpers,
  ...
}:
let
  homeDir = config.home.homeDirectory;
  configHome = config.xdg.configHome;
in
{
  # Common dotfile symlinks for all platforms
  home.activation.linkDotfilesCommon = lib.hm.dag.entryAfter [ "linkGeneration" ] ''
    ${helpers.mkLinkForce}

    # Ensure .config directory exists
    $DRY_RUN_CMD mkdir -p "${configHome}"

    # Fish shell configuration
    link_force "${dotfilesDir}/fish" "${configHome}/fish"

    # Neovim configuration
    link_force "${dotfilesDir}/nvim" "${configHome}/nvim"

    # Git configuration
    link_force "${dotfilesDir}/git" "${configHome}/git"

    # LazyGit configuration
    link_force "${dotfilesDir}/lazygit" "${configHome}/lazygit"

    # GitHub CLI configuration
    link_force "${dotfilesDir}/gh" "${configHome}/gh"
  '';
}
