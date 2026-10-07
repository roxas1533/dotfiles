{ pkgs, ... }:

{
  programs.yazi = {
    enable = true;
    plugins = {
      ouch = pkgs.yaziPlugins.ouch;
    };
    settings = {
      opener = {
        extract = [
          {
            run = "ouch d -y %s";
            desc = "Extract here with ouch";
            for = "unix";
          }
        ];
      };
      plugin = {
        prepend_previewers = [
          {
            mime = "application/{*zip,tar,bzip2,7z*,rar,xz,zstd,java-archive}";
            run = "ouch";
          }
        ];
      };
    };
    keymap = {
      mgr.prepend_keymap = [
        {
          on = [ "C" ];
          run = "plugin ouch";
          desc = "Compress with ouch";
        }
      ];
    };
  };
}
