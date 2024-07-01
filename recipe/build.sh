#!/bin/bash

set -x

DFLAGS="-L-L${PREFIX}/lib -L-Wl,-rpath,${PREFIX}/lib -static"
if [[ "$target_platform" == "osx-64" ]]; then
    export DFLAGS=""
fi

ls ${PREFIX}/lib | grep ldc

# Ensure the ldc2 and necessary libraries are correctly linked
export LIBRARY_PATH="${PREFIX}/lib:${LIBRARY_PATH}"
export LD_LIBRARY_PATH="${PREFIX}/lib:${LD_LIBRARY_PATH}"

make DCOMPILER=ldc2 DFLAGS="$DFLAGS"
make test-nobuild DCOMPILER=ldc2

cp -r bin $PREFIX
