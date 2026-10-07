{
  pkgs,
  config,
  inputs,
  ...
}:
{
  wayland.windowManager.hyprland.enable = true;
  wayland.windowManager.hyprland.configType = "hyprlang";
  # Suppress "no config provided" warning — config is managed via home.file symlinks
  wayland.windowManager.hyprland.extraConfig = "";

  # hyprland.lua is linked here (not in the activation script) so it exists
  # atomically with hyprland.conf during linkGeneration, preventing the "No such
  # file or directory" warning Hyprland emits when it inotify-reloads mid-activation.
  home.file.".config/hypr/hyprland.lua".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/hypr/hyprland.lua";

  # Stable symlink for hyprexpo plugin — loaded via hl.plugin() in hyprland.lua
  home.file.".config/hypr/plugins/hyprexpo.so".source =
    "${pkgs.hyprlandPlugins.hyprexpo}/lib/libhyprexpo.so";

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
