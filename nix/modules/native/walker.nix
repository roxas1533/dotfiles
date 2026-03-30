# Walker application launcher configuration
{ inputs, ... }:

{
  imports = [
    inputs.walker.homeManagerModules.walker
  ];

  programs.walker = {
    enable = true;
    runAsService = true;

    config = {
      placeholder = "Search...";
      show_initial_entries = true;
      ssh_host_file = "";
      terminal = "wezterm";
      orientation = "vertical";
      fullscreen = false;
      scrollbar_policy = "automatic";

      ui = {
        anchors.top = true;
        anchors.bottom = false;
        anchors.left = true;
        anchors.right = true;
        window = {
          box.width = 600;
          box.height = 400;
          box.margins.top = 200;
        };
      };

      activation_mode = {
        use_alt = false;
        disabled = true;
      };

      search = {
        delay = 0;
        force_keyboard_focus = true;
      };

      builtins = {
        applications = {
          weight = 5;
          name = "applications";
        };
        runner = {
          weight = 3;
          name = "runner";
        };
        websearch = {
          weight = 1;
          name = "websearch";
          engines = [ "google" ];
        };
        clipboard = {
          weight = 2;
          name = "clipboard";
          max_entries = 10;
        };
      };
    };

    # Catppuccin Mocha theme
    themes."catppuccin" = {
      style = ''
        * {
          font-family: "JetBrainsMono Nerd Font", monospace;
          font-size: 14px;
        }

        #window {
          background: rgba(30, 30, 46, 0.9);
          border-radius: 12px;
          border: 2px solid rgba(180, 190, 254, 0.3);
        }

        #box {
          padding: 10px;
        }

        #search {
          background: rgba(49, 50, 68, 0.8);
          border-radius: 8px;
          padding: 10px 15px;
          margin-bottom: 10px;
          color: #cdd6f4;
          border: none;
        }

        #list {
          background: transparent;
        }

        #item {
          padding: 8px 12px;
          border-radius: 6px;
          margin: 2px 0;
        }

        #item:selected {
          background: rgba(137, 180, 250, 0.3);
        }

        #text {
          color: #cdd6f4;
        }

        #icon {
          margin-right: 10px;
        }
      '';
    };
  };
}
