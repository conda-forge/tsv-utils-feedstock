#!/bin/bash

set -euxo pipefail

MTRIPLE=""
OSX_FLAGS=""

# if target platform starts with osx
if [[ "$target_platform" == osx-* ]]; then
    MTRIPLE="-mtriple=x86_64-apple-macosx10.13"
    OSX_FLAGS="-L-Wl,-headerpad_max_install_names"
fi

if [[ "$target_platform" == "osx-arm64" ]]; then
    # Get the arm64 lib files
    # Ideally, we would get these from the conda-forge ldc2 arm64 package, but it is not available yet
    #latest_version=$(curl -s https://api.github.com/repos/ldc-developers/ldc/releases/latest | jq -r .tag_name | sed 's/^v//')
    LDC_VERSION=1.28.1
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
            ];
            lib-dirs = [
                "$BUILD_PREFIX/lib-arm64",
            ];
            rpath = "$BUILD_PREFIX/lib-arm64";
        };
EOF

fi

make DCOMPILER=ldc2 DFLAGS="-link-defaultlib-shared=false $MTRIPLE $OSX_FLAGS"

cp -r bin "$PREFIX"
