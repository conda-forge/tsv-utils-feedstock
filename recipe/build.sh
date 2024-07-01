#!/bin/bash

set -x

DFLAGS="-L-L${PREFIX}/lib -L-Wl,-rpath,${PREFIX}/lib"
if [[ "$target_platform" == "osx-64" ]]; then
    export DFLAGS=""
fi

make DCOMPILER=ldc2 DFLAGS="$DFLAGS"
make test-nobuild DCOMPILER=ldc2

cp -r bin $PREFIX
