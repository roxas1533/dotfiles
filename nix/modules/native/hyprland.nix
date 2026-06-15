{ pkgs, inputs, ... }:
let
  screenshot = pkgs.writeShellScript "screenshot" ''
    ${pkgs.grim}/bin/grim -g "$(${pkgs.slurp}/bin/slurp -b '#00000080' -s '#00000000')" - | ${pkgs.wl-clipboard}/bin/wl-copy
  '';
in
{
  wayland.windowManager.hyprland = {
    enable = true;

    # hyprexpo: sandwichfarm fork (upstream dropped it in hyprland-plugins#663, 2026-05-12).
    # Built via nix/overlays/hyprexpo.nix.
    plugins = [
      pkgs.hyprlandPlugins.hyprexpo
    ];

    settings = {
      # Monitor configuration
      # DP-1 (BenQ) on left, HDMI-A-2 (HP) on right (primary)
      monitor = [
        "DP-1,1920x1080@60,-1920x0,1"
        "HDMI-A-2,1920x1080@60,0x0,1"
      ];

      # Environment variables
      env = [
        "XCURSOR_THEME,Adwaita"
        "XCURSOR_SIZE,24"
        "HYPRCURSOR_SIZE,24"
        "GTK_THEME,Fluent-round-Dark"
        "ADW_DEBUG_COLOR_SCHEME,prefer-dark"
        # Qt6 dark mode (for fcitx5-configtool etc.)
        "QT_QPA_PLATFORMTHEME,adwaita"
        "QT_STYLE_OVERRIDE,adwaita-dark"
      ];

      # Programs
      "$terminal" = "wezterm";
      "$fileManager" = "thunar";
      "$menu" = "noctalia-shell ipc call launcher toggle";
      "$mainMod" = "SUPER";

      # Autostart
      exec-once = [
        "noctalia-shell"

        # Line In: set input source and connect to HDMI output
        "amixer -c Generic_1 sset 'Input Source' 'Line' && amixer -c Generic_1 sset 'Capture' 50% cap && amixer -c Generic_1 sset 'Line Boost' 0% && pw-link alsa_input.pci-0000_0d_00.6.analog-stereo:capture_FL alsa_output.pci-0000_01_00.1.hdmi-stereo:playback_FL && pw-link alsa_input.pci-0000_0d_00.6.analog-stereo:capture_FR alsa_output.pci-0000_01_00.1.hdmi-stereo:playback_FR"
      ];

      # General settings
      general = {
        gaps_in = 5;
        gaps_out = 5;
        border_size = 2;
        "col.active_border" = "rgba(33ccffee) rgba(00ff99ee) 45deg";
        "col.inactive_border" = "rgba(595959aa)";
        resize_on_border = false;
        allow_tearing = false;
        layout = "scrolling";

        # Floating window snap settings
        snap = {
          enabled = true;
          window_gap = 10;
          monitor_gap = 10;
        };
      };

      # Decoration
      decoration = {
        rounding = 10;
        rounding_power = 2;
        active_opacity = 1.0;
        inactive_opacity = 1.0;

        shadow = {
          enabled = true;
          range = 4;
          render_power = 3;
          color = "rgba(1a1a1aee)";
        };

        blur = {
          enabled = true;
          size = 1;
          passes = 2;
          vibrancy = 0.1696;
          brightness = 0.7;
          popups = true;
          popups_ignorealpha = 0.2;
          input_methods = true;
        };
      };

      # Animations
      animations = {
        enabled = true;

        bezier = [
          "easeOutQuint, 0.23, 1, 0.32, 1"
          "easeInOutCubic, 0.65, 0.05, 0.36, 1"
          "linear, 0, 0, 1, 1"
          "almostLinear, 0.5, 0.5, 0.75, 1"
          "quick, 0.15, 0, 0.1, 1"
        ];

        animation = [
          "global, 1, 10, default"
          "border, 1, 5.39, easeOutQuint"
          "windows, 1, 4.79, easeOutQuint"
          "windowsIn, 1, 4.1, easeOutQuint, popin 87%"
          "windowsOut, 1, 1.49, linear, popin 87%"
          "fadeIn, 1, 1.73, almostLinear"
          "fadeOut, 1, 1.46, almostLinear"
          "fade, 1, 3.03, quick"
          "layers, 1, 3.81, easeOutQuint"
          "layersIn, 1, 4, easeOutQuint, fade"
          "layersOut, 1, 1.5, linear, fade"
          "fadeLayersIn, 1, 1.79, almostLinear"
          "fadeLayersOut, 1, 1.39, almostLinear"
          "workspaces, 1, 1.94, almostLinear, fade"
          "workspacesIn, 1, 1.21, almostLinear, fade"
          "workspacesOut, 1, 1.94, almostLinear, fade"
          "zoomFactor, 1, 7, quick"
        ];
      };

      # Dwindle layout
      dwindle = {
        preserve_split = true;
      };

      # Master layout
      master = {
        new_status = "master";
      };

      # Misc
      misc = {
        force_default_wallpaper = -1;
        disable_hyprland_logo = false;
      };

      # Input
      input = {
        kb_layout = "jp";
        follow_mouse = 1;
        sensitivity = 0;

        touchpad = {
          natural_scroll = false;
        };
      };

      # Gestures (see line 239 in original config)
      gesture = "3, horizontal, workspace";

      # Device-specific config
      device = {
        name = "epic-mouse-v1";
        sensitivity = -0.5;
      };

      # Keybindings
      bind = [
        "$mainMod, Q, exec, $terminal"
        "$mainMod, C, killactive"
        "$mainMod, M, exit"
        "$mainMod, E, exec, $fileManager"
        "$mainMod, G, togglefloating"
        "$mainMod, R, exec, $menu"
        "$mainMod, P, pin"
        "$mainMod, J, layoutmsg, togglesplit"

        "$mainMod, TAB, hyprexpo:expo, toggle"

        # Screenshot (grim + slurp)
        "$mainMod SHIFT, S, exec, ${screenshot}"

        # System monitor
        "CTRL SHIFT, Escape, exec, missioncenter"

        # Move focus
        "$mainMod, left, movefocus, l"
        "$mainMod, right, movefocus, r"
        "$mainMod, up, movefocus, u"
        "$mainMod, down, movefocus, d"

        # Switch workspaces
        "$mainMod, 1, workspace, 1"
        "$mainMod, 2, workspace, 2"
        "$mainMod, 3, workspace, 3"
        "$mainMod, 4, workspace, 4"
        "$mainMod, 5, workspace, 5"
        "$mainMod, 6, workspace, 6"
        "$mainMod, 7, workspace, 7"
        "$mainMod, 8, workspace, 8"
        "$mainMod, 9, workspace, 9"
        "$mainMod, 0, workspace, 10"

        # Move window to workspace
        "$mainMod SHIFT, 1, movetoworkspace, 1"
        "$mainMod SHIFT, 2, movetoworkspace, 2"
        "$mainMod SHIFT, 3, movetoworkspace, 3"
        "$mainMod SHIFT, 4, movetoworkspace, 4"
        "$mainMod SHIFT, 5, movetoworkspace, 5"
        "$mainMod SHIFT, 6, movetoworkspace, 6"
        "$mainMod SHIFT, 7, movetoworkspace, 7"
        "$mainMod SHIFT, 8, movetoworkspace, 8"
        "$mainMod SHIFT, 9, movetoworkspace, 9"
        "$mainMod SHIFT, 0, movetoworkspace, 10"

        # Special workspace
        "$mainMod, S, togglespecialworkspace, magic"
        "$mainMod SHIFT, W, movetoworkspace, special:magic"

        # Scroll workspaces
        "$mainMod, mouse_down, workspace, e+1"
        "$mainMod, mouse_up, workspace, e-1"

        # Scrolling layout: swap columns
        "$mainMod SHIFT, left, layoutmsg, swapcol l"
        "$mainMod SHIFT, right, layoutmsg, swapcol r"

        # Scrolling layout: scroll view with mouse wheel
        "$mainMod SHIFT, mouse_down, layoutmsg, move -col"
        "$mainMod SHIFT, mouse_up, layoutmsg, move +col"

        # Scrolling layout: scroll view with horizontal mouse wheel
        "$mainMod, mouse_right, layoutmsg, move -col"
        "$mainMod, mouse_left, layoutmsg, move +col"
      ];

      # Mouse bindings
      bindm = [
        "$mainMod, mouse:272, movewindow"
        "$mainMod, mouse:273, resizewindow"
      ];

      # Volume/brightness bindings (Noctalia provides OSD overlay)
      bindel = [
        ", XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"
        ", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
        ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
        ", XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
        ", XF86MonBrightnessUp, exec, brightnessctl set 5%+"
        ", XF86MonBrightnessDown, exec, brightnessctl set 5%-"
      ];

      # Media bindings
      bindl = [
        ", XF86AudioNext, exec, playerctl next"
        ", XF86AudioPause, exec, playerctl play-pause"
        ", XF86AudioPlay, exec, playerctl play-pause"
        ", XF86AudioPrev, exec, playerctl previous"
      ];

      layerrule = [
        # Noctalia shell
        "blur on, match:namespace noctalia-background-.*$"
        "blur on, match:namespace noctalia-bar-content-.*$"
        "ignore_alpha 0.3, match:namespace noctalia-background-.*$"
        "ignore_alpha 0.3, match:namespace noctalia-bar-content-.*$"
        # Input methods
        "blur on, match:namespace fcitx"
      ];

      # Window rules (0.53+ syntax)
      windowrule = [
        "opacity 0.7 0.7, match:class ^(org.gnome.Nautilus|thunar)$"
        "border_color rgb(ff9500) rgb(cc7700), match:pin 1"
        "no_focus on, match:class ^$, match:title ^$, match:xwayland 1, match:float 1, match:fullscreen 0, match:pin 0"
        # Picture-in-Picture
        "keep_aspect_ratio on, match:title ^(ピクチャーインピクチャー|Picture.in.[Pp]icture)$"
        "size 960 540, match:title ^(ピクチャーインピクチャー|Picture.in.[Pp]icture)$"
        # Thunar rename dialog
        "float on, match:class ^(thunar)$, match:title .+の名前を変更$"
        # Remmina RDP connection window
        "float on, match:class ^(org.remmina.Remmina)$, match:title ^main$"
        "size 3840 1080, match:class ^(org.remmina.Remmina)$, match:title ^main$"
        "workspace special:magic, match:class ^(org.remmina.Remmina)$, match:title ^main$"
      ];

      plugin = {
        hyprexpo = {
          columns = 3;
          gaps_in = 5;
          bg_col = "rgb(111111)";
          workspace_method = "center current";
          gesture_distance = 300;
        };
      };
    };
  };

  # Clean up thumbnail cache: remove thumbnails not accessed in 30 days (weekly)
  systemd.user.services.thumbnail-cleanup = {
    Unit.Description = "Remove unused thumbnail cache files";
    Service = {
      Type = "oneshot";
      ExecStart = "${pkgs.findutils}/bin/find %h/.cache/thumbnails -type f -atime +30 -delete";
    };
  };
  systemd.user.timers.thumbnail-cleanup = {
    Unit.Description = "Weekly thumbnail cache cleanup";
    Timer = {
      OnCalendar = "weekly";
      Persistent = true;
    };
    Install.WantedBy = [ "timers.target" ];
  };

  # EasyEffects with DeepFilterNet for noise suppression
  services.easyeffects = {
    enable = true;
    preset = "noise-canceling";

    extraPresets = {
      noise-canceling = {
        input = {
          blocklist = [ ];
          plugins_order = [ "deepfilternet#0" ];

          "deepfilternet#0" = {
            bypass = false;
            input-gain = 0.0;
            output-gain = 0.0;
          };
        };
      };
    };
  };
}
