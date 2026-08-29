# Run Windows .exe files via Proton (GE-Proton) without Steam, using
# umu-launcher. Double-clicking a .exe in a file manager runs it through
# ${dotfilesDir}/.bin/run-with-proton, which derives a per-exe GAMEID/prefix.
# Proton builds are fetched with protonup-rs (not managed by Nix):
#   protonup-rs -q --tool GEProton --version latest --for ~/.local/share/proton-ge
{
  pkgs,
  lib,
  config,
  dotfilesDir ? "${config.home.homeDirectory}/dotfiles",
  ...
}:

{
  home.packages = with pkgs; [
    umu-launcher
    protonup-rs
  ];

  xdg.dataFile."applications/run-with-proton.desktop".text = ''
    [Desktop Entry]
    Type=Application
    Name=Run with Proton
    Comment=Launch a Windows .exe through Proton (umu-launcher)
    Exec=${dotfilesDir}/.bin/run-with-proton %f
    Icon=wine
    Terminal=false
    MimeType=application/x-ms-dos-executable;application/x-msdownload;application/vnd.microsoft.portable-executable;
    NoDisplay=false
  '';

  xdg.mimeApps.defaultApplications = {
    "application/x-ms-dos-executable" = "run-with-proton.desktop";
    "application/x-msdownload" = "run-with-proton.desktop";
    "application/vnd.microsoft.portable-executable" = "run-with-proton.desktop";
  };

  home.activation.updateDesktopDatabase = lib.hm.dag.entryAfter [ "linkGeneration" ] ''
    ${pkgs.desktop-file-utils}/bin/update-desktop-database \
      "$HOME/.local/share/applications/" || true
  '';
}
