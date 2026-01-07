{ pkgs, ... }:

{
  # Wayland/Hyprland全体のカーソル設定
  home.pointerCursor = {
    name = "Adwaita";
    package = pkgs.adwaita-icon-theme;
    size = 24;
    gtk.enable = true;
    x11.enable = true;
  };
  # GTK アプリケーション（Waylandネイティブ & XWayland）のダークモード設定
  gtk = {
    enable = true;

    theme = {
      name = "Fluent-round-Dark";
      package = pkgs.fluent-gtk-theme.override {
        themeVariants = [ "default" ];
        colorVariants = [ "dark" ];
        sizeVariants = [ "standard" ];
        tweaks = [ "round" ]; # 角丸デザイン
      };
    };

    iconTheme = {
      name = "candy-icons";
      package = pkgs.candy-icons;
    };

    cursorTheme = {
      name = "Adwaita";
      package = pkgs.adwaita-icon-theme;
      size = 24;
    };

    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = true;
    };

    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = true;
    };
  };

  # Qt アプリケーション用のダークモード設定
  qt = {
    enable = true;
    platformTheme.name = "adwaita";
    style.name = "adwaita-dark";
  };

  # Wayland/XWayland共通：Freedesktop color-scheme設定
  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      gtk-theme = "Fluent-round-Dark";
      icon-theme = "candy-icons";
    };
    # Nautilus ダークモード
    "org/gnome/nautilus/preferences" = {
      always-use-location-entry = true;
    };
    "org/gtk/gtk4/settings/file-chooser" = {
      sort-directories-first = true;
    };
  };

  # fcitx5（IME）のFluentダークテーマ設定
  xdg.configFile."fcitx5/conf/classicui.conf".text = ''
    # Vertical Candidate List
    Vertical Candidate List=False

    # Font
    Font="Sans 13"

    # Theme (Fluent dark with blur)
    Theme=FluentDark
  '';

  # fcitx5キーバインド設定（無変換でIMEオフ、変換でIMEオン）
  xdg.configFile."fcitx5/config".text = ''
    [Hotkey]
    TriggerKeys=
    EnumerateWithTriggerKeys=True

    [Hotkey/ActivateKeys]
    0=Henkan

    [Hotkey/DeactivateKeys]
    0=Muhenkan

    [Behavior]
    ActiveByDefault=False
    ShareInputState=No
  '';

  # mozc設定
  xdg.configFile."mozc/config1.db" = {
    source = ../../../mozc/config1.db;
    force = true;
  };

  # 必要なパッケージを追加
  home.packages = with pkgs; [
    adwaita-qt
    adwaita-qt6
    dconf
    gtk-engine-murrine # Fluent テーマに必要
    qt6Packages.fcitx5-configtool # fcitx5設定ツール
  ];
}
