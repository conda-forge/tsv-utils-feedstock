#!/bin/bash

set -euxo pipefail

MTRIPLE=""

if [[ "$target_platform" == "osx-arm64" ]]; then
    # Get the arm64 lib files
    LDC_VERSION=1.38.0
    LDC_ARCH=osx-arm64
    wget https://github.com/ldc-developers/ldc/releases/download/v$LDC_VERSION/ldc2-$LDC_VERSION-$LDC_ARCH.tar.xz
    tar -xf ldc2-$LDC_VERSION-$LDC_ARCH.tar.xz
    mkdir "$BUILD_PREFIX"/lib-arm64
    cp -r ldc2-$LDC_VERSION-$LDC_ARCH/lib "$BUILD_PREFIX"/lib-arm64

    MTRIPLE="-mtriple=arm64-apple-macosx11"

    # Configure ldc2.conf
    cat <<EOF >>"$BUILD_PREFIX"/etc/ldc2.conf
        "arm64-apple-":
        {
            switches = [
                "-defaultlib=phobos2-ldc,druntime-ldc",
                "-Xcc=-arch",
                "-Xcc=arm64",
                "-mtriple=arm64-apple-macosx11",
                "-Xcc=-mmacosx-version-min=11",
                "-L-macos_version_min",
                "-L11",
                "-Xcc=-fno-autolink",
                "-L-arch",
                "-Larm64",
                "-L-no_objc_category_merging",
                "-L-dead_strip",
                "-L-no_implicit_dylibs",
                "-L-no_compact_unwind",

            ];
            lib-dirs = [
                "%%ldcbinarypath%%/../lib-arm64",
            ];
            rpath = "%%ldcbinarypath%%/../lib-arm64";
        };
EOF

fi

make DCOMPILER=ldc2 DFLAGS="-link-defaultlib-shared=false $MTRIPLE"

cp -r bin "$PREFIX"
