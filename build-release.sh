#!/bin/sh
set -e 
source=`pwd`
libs=$source/../libs

rm -rf amd64/_build
mkdir -p amd64/rel 2> /dev/null
cp $source/rel/config.exs $source/amd64/rel

builddir=$source/amd64/_build
depsdir=$source/amd64/deps
reldir=$source/amd64/rel

mix="docker run --rm -v $libs:/libs -v $source:/build -v $builddir:/build/_build -v $depsdir:/build/deps -v $reldir:/build/rel codenaut/exrm-builder mix "

$mix clean
$mix deps.get
$mix phx.digest.clean
$mix phx.digest
$mix compile
$mix release
