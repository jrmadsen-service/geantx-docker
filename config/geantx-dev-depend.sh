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

cd ${SOURCE_DIR}

cd ${SOURCE_DIR}
run-verbose git clone https://github.com/VcDevel/Vc.git
cd Vc
run-verbose git checkout ${VC_VERSION}

cd ${SOURCE_DIR}
run-verbose git clone https://github.com/root-project/VecCore.git
cd VecCore
run-verbose git checkout v0.5.2

cd ${SOURCE_DIR}
run-verbose git clone https://github.com/root-project/VecMath.git
cd VecMath
run-verbose git checkout master

cd ${SOURCE_DIR}
run-verbose git clone https://gitlab.cern.ch/VecGeom/VecGeom.git

### Environment settings

: ${VECGEOM_VECTOR:=avx2}
: ${VECGEOM_BACKEND:=vc}

### Build Vc

setup-build
run-verbose cmake ${SOURCE_DIR}/Vc -DCMAKE_INSTALL_PREFIX=${INSTALL_DIR} -G Ninja
run-verbose cmake --build ${PWD} --target all
run-verbose cmake --build ${PWD} --target install

### Build VecCore

setup-build
run-verbose cmake ${SOURCE_DIR}/VecCore -DCMAKE_INSTALL_PREFIX=${INSTALL_DIR} -DVC=ON -G Ninja
run-verbose cmake --build ${PWD} --target all
run-verbose cmake --build ${PWD} --target install

### Build VecMath

setup-build
run-verbose cmake ${SOURCE_DIR}/VecMath -DCMAKE_INSTALL_PREFIX=${INSTALL_DIR} -DBACKEND=Vc
run-verbose cmake --build ${PWD} --target all
run-verbose cmake --build ${PWD} --target install

### Build VecGeom

setup-build
run-verbose cmake -DBACKEND=${VECGEOM_BACKEND} \
    -DBUILTIN_VECCORE=OFF \
    -DCMAKE_INSTALL_PREFIX=${INSTALL_DIR} \
    -DCUDA=ON -DCUDA_VOLUME_SPECIALIZATION=OFF \
    -DNO_SPECIALIZATION=ON -DROOT=OFF \
    -DVECGEOM_VECTOR=${VECGEOM_VECTOR} \
    ${SOURCE_DIR}/VecGeom -G Ninja
run-verbose cmake --build ${PWD} --target all
run-verbose cmake --build ${PWD} --target install
