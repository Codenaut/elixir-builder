#!/bin/sh
set -e 
source=`pwd`
libs=$source/../libs

rm -rf amd64/
mkdir -p amd64/rel 2> /dev/null
cp -r $source/rel/* $source/amd64/rel/

builddir=$source/amd64/_build
depsdir=$source/amd64/deps
reldir=$source/amd64/rel

GIT_REV=`git rev-parse --short HEAD`
# Replace the version in rel/config.exs with something like this:
#    set version: "0.1.0-" <> System.get_env("GIT_REV")

if [ -z $DEV_MODE ]; then
    if [ "x" != "x`git diff-files`"  ]; then
        echo "You have uncommitted files. Please commit them before building release"
        exit 1
    fi
    if [ "x" != "x`git diff-index origin/master`"  ]; then
        echo "You have unpushed local commits. Please push them before building release"
        exit 1
    fi
fi

mix="docker run --rm -e GIT_REV=$GIT_REV -v $libs:/libs -v $source:/build -v $builddir:/build/_build -v $depsdir:/build/deps -v $reldir:/build/rel codenaut/exrm-builder mix "

$mix clean
$mix deps.get
$mix phx.digest.clean
$mix phx.digest
(cd apps/yourapp_web/assets/ && npm run deploy)
$mix compile
$mix release
