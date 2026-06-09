{ pkgs, config, ... }:

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

    gtk4 = {
      theme = config.gtk.theme;
      extraConfig = {
        gtk-application-prefer-dark-theme = true;
      };
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
    UseDarkTheme=True
  '';

  # fcitx5キーバインド設定（常時ON、全角半角で切替）
  xdg.configFile."fcitx5/config".text = ''
    [Hotkey]
    EnumerateWithTriggerKeys=True
    EnumerateSkipFirst=False

    [Hotkey/TriggerKeys]
    0=Zenkaku_Hankaku

    [Hotkey/AltTriggerKeys]

    [Hotkey/ActivateKeys]

    [Hotkey/DeactivateKeys]

    [Hotkey/EnumerateForwardKeys]

    [Hotkey/EnumerateBackwardKeys]

    [Hotkey/EnumerateGroupForwardKeys]

    [Hotkey/EnumerateGroupBackwardKeys]

    [Hotkey/PrevPage]
    0=Up

    [Hotkey/NextPage]
    0=Down

    [Hotkey/PrevCandidate]
    0=Shift+Tab

    [Hotkey/NextCandidate]
    0=Tab

    [Hotkey/TogglePreedit]

    [Behavior]
    ActiveByDefault=True
    ShareInputState=No
    PreeditEnabledByDefault=True
    ShowInputMethodInformation=True
    showInputMethodInformationWhenFocusIn=False
    CompactInputMethodInformation=True
    ShowFirstInputMethodInformation=True
    DefaultPage=0
    OverrideXkbOption=False
    PreloadInputMethod=True
    AllowInputMethodForPassword=False
    ShowPreeditForPassword=False
    AutoSavePeriod=30
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
