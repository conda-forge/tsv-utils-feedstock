#!/bin/bash

LDC_VERSION=1.26.0

set -x

curl -fsS https://dlang.org/install.sh | bash -s install ldc-$LDC_VERSION
source ~/dlang/ldc-$LDC_VERSION/activate

make DCOMPILER=ldc2 DFLAGS="-link-defaultlib-shared=false"

cp -r bin $PREFIX
