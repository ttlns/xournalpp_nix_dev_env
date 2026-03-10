let
  pkgs = import (fetchTarball{ 
    url = "https://github.com/NixOS/nixpkgs/archive/nixos-25.11.tar.gz";
    sha256 = "sha256:1v4f4p1v444r56m6n4jdjc6i1wg3gx724l0rnr45j6cvn5hf5zf9";
  }) {};
in
pkgs.mkShell {
  buildInputs = with pkgs; [
    # Core Build Tools
    cmake
    pkg-config
    gnumake
    ninja

    # Build dependencies
    gettext
    help2man
    glib
    gtk3
    gtksourceview4
    librsvg
    libsndfile
    libxml2
    libzip
    pcre
    poppler
    portaudio
    qpdf
    zlib
    adwaita-icon-theme
    lua5_3
    alsa-lib
    binutils

    # For enum script
    php

    # Development tools
    gdb
    valgrind
    strace
    ltrace
  ];

  shellHook = with pkgs; ''
    # Add icon theme to XDG_DATA_DIRS
    export XDG_DATA_DIRS="${adwaita-icon-theme}/share:$XDG_DATA_DIRS"
    export XDG_DATA_DIRS="${gtk3}/share:$XDG_DATA_DIRS"
    
    # Set library path for runtime linking
    export LD_LIBRARY_PATH="${lib.makeLibraryPath [
      alsa-lib
      glib
      gtk3
      poppler
      libxml2
      libzip
      librsvg
      portaudio
      libsndfile
      gtksourceview4
      qpdf
      zlib
      pcre
      stdenv.cc.cc.lib
    ]}:$LD_LIBRARY_PATH"
    
    # For pkg-config to find dependencies
    export PKG_CONFIG_PATH="${lib.makeSearchPath "lib/pkgconfig" [
      glib.dev
      gtk3.dev
      poppler.dev
      libxml2.dev
      libzip.dev
      librsvg.dev
      portaudio
      libsndfile.dev
      gtksourceview4.dev
      qpdf
      pcre.dev
      alsa-lib.dev
    ]}:$PKG_CONFIG_PATH"

     mkdir -p .vscode
    cat > .vscode/launch.json << 'EOF'
    {
      "version": "0.2.0",
      "configurations": [
        {
          "name": "Debug in nix environment",
          "type": "gdb",
          "request": "launch",
          "program": "''${workspaceFolder}/build/install/bin/xournalpp",
          "environment":{
              "XDG_DATA_DIRS": "${pkgs.adwaita-icon-theme}/share:${pkgs.gtk3}/share:''${env:XDG_DATA_DIRS}",
              "LD_LIBRARY_PATH":"${lib.makeLibraryPath [
      alsa-lib
      glib
      gtk3
      poppler
      libxml2
      libzip
      librsvg
      portaudio
      libsndfile
      gtksourceview4
      qpdf
      zlib
      pcre
      stdenv.cc.cc.lib
    ]}:''${env:LD_LIBRARY_PATH}"
            },
        }
      ]
    }
  EOF
  '';
}