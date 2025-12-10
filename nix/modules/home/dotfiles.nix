{
  lib,
  config,
  dotfilesDir ? "${config.home.homeDirectory}/dotfiles",
  helpers,
  ...
}:
let
  configHome = config.xdg.configHome;
in
{
  # Clean up old .config symlink before linkGeneration
  home.activation.cleanupOldConfigLink = lib.hm.dag.entryBefore [ "linkGeneration" ] ''
    # Check if .config is an old symlink
    if [[ -L "${configHome}" && ! -d "${configHome}" ]]; then
      echo ""
      echo "=========================================="
      echo "既存の .config シンボリックリンクが見つかりました:"
      echo "  パス: ${configHome}"
      echo "  リンク先: $(readlink ${configHome})"
      echo "=========================================="
      echo ""
      echo "このシンボリックリンクを削除する必要があります。"
      echo ""
      echo "以下のコマンドを実行してから、再度 nixos-rebuild を実行してください:"
      echo "  sudo rm ${configHome}"
      echo ""
      echo "または、環境変数を設定して自動削除することもできます:"
      echo "  DOTFILES_CLEANUP_CONFIG=yes sudo -E nixos-rebuild switch --flake /home/ro/dotfiles"
      echo ""

      # Check if auto-cleanup is enabled via environment variable
      if [[ "''${DOTFILES_CLEANUP_CONFIG:-no}" == "yes" ]]; then
        echo "環境変数 DOTFILES_CLEANUP_CONFIG=yes が設定されているため、自動的に削除します..."
        $DRY_RUN_CMD rm -f "${configHome}"
        echo ".config シンボリックリンクを削除しました。"
      else
        exit 1
      fi
    fi
  '';

  # Common dotfile symlinks for all platforms
  home.activation.linkDotfilesCommon = lib.hm.dag.entryAfter [ "linkGeneration" ] ''
    ${helpers.mkLinkForce}

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

    echo ""
    echo "✓ Dotfiles のシンボリックリンクを作成しました"
    echo ""
    echo "シェル設定を反映するには以下のコマンドを実行してください:"
    echo "  exec fish"
    echo ""
  '';
}
