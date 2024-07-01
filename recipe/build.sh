#!/bin/bash

LDC_VERSION=1.32.0

set -x

if [ "$target_platform" == "osx-64" ]; then
    ARCHSTR="osx-x86_64"
else
    ARCHSTR="linux-x86_64"
fi

wget https://github.com/ldc-developers/ldc/releases/download/v${LDC_VERSION}/ldc2-${LDC_VERSION}-${ARCHSTR}.tar.xz
tar -xf ldc2-${LDC_VERSION}-${ARCHSTR}.tar.xz
PATH=$PWD/ldc2-${LDC_VERSION}-${ARCHSTR}/bin:$PATH

make DCOMPILER=ldc2 DFLAGS="-link-defaultlib-shared=false"

cp -r bin $PREFIX
