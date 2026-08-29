# TODO

## Clapper: gluploader workaround を戻す

`nix/modules/native/default.nix` の Clapper override を削除して `clapper` に戻す。

**経緯**: GStreamer 1.28 で DRM modifier 付き DMABuf caps が導入され、NVIDIA EGL 上で
`gstclappergluploader` が `gst_gl_upload_transform_caps` → EMPTY caps → crash するようになった。
作者公認の workaround として `-Dgluploader=disabled` でビルドしている。

**issue**: https://github.com/Rafostar/clapper/issues/560

**修正後の状態**:
```nix
# before (workaround)
(clapper.override {
  clapper-unwrapped = clapper-unwrapped.overrideAttrs (old: {
    mesonFlags = (old.mesonFlags or [ ]) ++ [ "-Dgluploader=disabled" ];
  });
})

# after (issue 解決後)
clapper
```

issue が閉じられた、または Clapper が新しい sink に書き直された場合に戻す。

---

## Clapper: D-Bus アクティベーション workaround を戻す

`nix/modules/native/default.nix` の `xdg.dataFile."applications/com.github.rafostar.Clapper.desktop"` を削除する。

**経緯**: Thunar からダブルクリックで開くと GApplication D-Bus アクティベーション経由で起動され、
NVIDIA/Wayland 環境でクラッシュしていた。`sh -c 'clapper "$@"' -- %U` で D-Bus activation を
バイパスすることで回避。

**修正後の状態**: `xdg.dataFile` のエントリを丸ごと削除するだけでよい。
