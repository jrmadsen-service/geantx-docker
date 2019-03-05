#!/bin/bash -e

VC_VERSION=1.3.3

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

chmod 755 /usr/local/bin/thisroot.sh
. /usr/local/bin/thisroot.sh

### Checkout GeantV

cd ${SOURCE_DIR}
run-verbose git clone https://gitlab.cern.ch/GeantV/geant.git

# dummy to fool it into downloading file
mkdir -p geant/data
cp geant/examples/physics/FullCMS/Geant4/cms.gdml geant/data/cms2018.gdml

### Build GeantV

if [ -f /usr/local/bin/geant4.sh ]; then
    G4PATH=$(dirname $(find /usr/local | grep Geant4Config.cmake | head -n 1))
    export CMAKE_PREFIX_PATH=${G4PATH}:${CMAKE_PREFIX_PATH}
    : ${USE_GEANT4:=ON}
fi
: ${USE_GEANT4:=OFF}

setup-build
run-verbose cmake -DCMAKE_INSTALL_PREFIX=${INSTALL_DIR} \
    -DUSE_ROOT=ON -DWITH_GEANT4=${USE_GEANT4} -DDATA_DOWNLOAD=ON \
    -DBUILD_REAL_PHYSICS_TESTS=OFF -DVECTORIZED_GEOMETRY=ON \
    -DWITH_GEANT4_UIVIS=${USE_GEANT4} -DUSE_VECPHYS=OFF \
    ${SOURCE_DIR}/geant -G Ninja
run-verbose cmake --build ${PWD} --target all
run-verbose cmake --build ${PWD} --target install

run-verbose apt-get -y autoclean
run-verbose rm -rf /var/lib/apt/lists/*
