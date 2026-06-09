final: prev: {
  fcitx5-hazkey = prev.stdenv.mkDerivation rec {
    pname = "fcitx5-hazkey";
    version = "0.2.1";

    src = prev.fetchurl {
      url = "https://github.com/7ka-Hiira/hazkey/releases/download/${version}/fcitx5-hazkey-${version}-x86_64.tar.gz";
      sha256 = "0nzmfykvyvjwvh0w7x23swvrjdcj8ra5afvy5gg1zwi9pp89zvgy";
    };

    sourceRoot = ".";

    nativeBuildInputs = [
      prev.autoPatchelfHook
      prev.qt6.wrapQtAppsHook
    ];

    buildInputs = [
      prev.stdenv.cc.cc.lib # libstdc++
      prev.fcitx5
      prev.qt6.qtbase
      prev.vulkan-loader
    ];

    # Don't try to build anything
    dontBuild = true;
    dontConfigure = true;

    installPhase = ''
      runHook preInstall

      # Install libraries
      mkdir -p $out/lib/fcitx5
      cp usr/lib/x86_64-linux-gnu/fcitx5/fcitx5-hazkey.so $out/lib/fcitx5/

      # Install hazkey runtime (server, settings, llama libs)
      mkdir -p $out/lib/hazkey
      cp -r usr/lib/x86_64-linux-gnu/hazkey/* $out/lib/hazkey/

      # Install data files
      mkdir -p $out/share
      cp -r usr/share/fcitx5 $out/share/
      cp -r usr/share/hazkey $out/share/
      cp -r usr/share/icons $out/share/

      # Install desktop file
      if [ -d usr/share/applications ]; then
        cp -r usr/share/applications $out/share/
      fi

      # Create wrapper scripts
      mkdir -p $out/bin
      cat > $out/bin/hazkey-server <<WRAPPER
      #!/usr/bin/env sh
      ENV_FILE="\$XDG_CONFIG_HOME/hazkey/env"
      if [ -f "\$ENV_FILE" ]; then
          . "\$ENV_FILE"
      fi
      export GGML_BACKEND_DIR="$out/lib/hazkey/libllama/backends"
      export HAZKEY_DICTIONARY="$out/share/hazkey/Dictionary"
      exec "$out/lib/hazkey/hazkey-server" "\$@"
      WRAPPER
      chmod +x $out/bin/hazkey-server

      ln -s $out/lib/hazkey/hazkey-settings $out/bin/hazkey-settings

      runHook postInstall
    '';

    # Add llama libs to the rpath for hazkey-server
    appendRunpaths = [
      "$ORIGIN"
      "$ORIGIN/libllama"
      "$ORIGIN/libllama/backends"
    ];

    meta = with prev.lib; {
      description = "Japanese input method for fcitx5 using AzooKeyKanaKanjiConverter";
      homepage = "https://github.com/7ka-Hiira/hazkey";
      license = licenses.mit;
      platforms = [ "x86_64-linux" ];
    };
  };
}
