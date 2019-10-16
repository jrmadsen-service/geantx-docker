#!/bin/bash -e

rm -f /etc/profile.d/geantv.sh

## Common

TOP_DIR=/tmp
INSTALL_DIR=/usr/local
BUILD_DIR=${TOP_DIR}/build
SOURCE_DIR=${TOP_DIR}/sources

mkdir -p ${SOURCE_DIR}
mkdir -p ${INSTALL_DIR}
mkdir -p ${BUILD_DIR}

# clean the build directory
setup-build()
{
    cd ${BUILD_DIR}
    rm -rf ${BUILD_DIR}/*
}

# function for running command verbosely
run-verbose()
{
    echo -e "\nRunning : '$@'...\n"
    eval $@
}

cd ${SOURCE_DIR}

# install ROOT
run-verbose git clone http://root.cern.ch/git/root.git

### Build ROOT

setup-build
run-verbose cmake ${SOURCE_DIR}/root -DCMAKE_INSTALL_PREFIX=${INSTALL_DIR} -G Ninja
run-verbose cmake --build ${PWD} --target all
run-verbose cmake --build ${PWD} --target install
