#!/bin/bash

set -euxo pipefail

MTRIPLE=""

if [[ "$target_platform" == "osx-arm64" ]]; then
    # Get the arm64 lib files
    LDC_VERSION=1.38.0
    LDC_ARCH=osx-arm64
    wget https://github.com/ldc-developers/ldc/releases/download/v$LDC_VERSION/ldc2-$LDC_VERSION-$LDC_ARCH.tar.xz
    tar -xf ldc2-$LDC_VERSION-$LDC_ARCH.tar.xz
    mv ldc2-$LDC_VERSION-$LDC_ARCH/lib "$BUILD_PREFIX"/lib-arm64

    MTRIPLE="-mtriple=arm64-apple-macosx11"

    # Configure ldc2.conf
    cat <<EOF >>"$BUILD_PREFIX"/etc/ldc2.conf
        "arm64-apple-":
        {
            switches = [
                "-defaultlib=phobos2-ldc,druntime-ldc",
                "-Xcc=-arch",
                "-Xcc=arm64",
                "-Xcc=-isysroot",
                "-Xcc=$CONDA_BUILD_SYSROOT",
                "-L-v",
            ];
            lib-dirs = [
                "$BUILD_PREFIX/lib-arm64",
            ];
            rpath = "$BUILD_PREFIX/lib-arm64";
        };
EOF

fi

make DCOMPILER=ldc2 DFLAGS="-link-defaultlib-shared=false $MTRIPLE"

cp -r bin "$PREFIX"
