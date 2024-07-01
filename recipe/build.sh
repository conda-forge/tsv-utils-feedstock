#!/bin/bash

set -x

make DCOMPILER=ldc2 DFLAGS="-link-defaultlib-shared=false"

cp -r bin $PREFIX
