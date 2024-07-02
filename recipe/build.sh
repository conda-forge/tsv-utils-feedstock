#!/bin/bash

set -euxo pipefail

if [[ "$target_platform" == "osx-arm64" ]]; then
    LDC_VERSION=1.38.0
    curl -fsS https://dlang.org/install.sh | bash -s install ldc-$LDC_VERSION
    source ~/dlang/ldc-$LDC_VERSION/activate
fi

make DCOMPILER=ldc2 DFLAGS="-link-defaultlib-shared=false"

cp -r bin $PREFIX
