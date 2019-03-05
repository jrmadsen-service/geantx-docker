#!/bin/bash -e

ROOT_DIR=${PWD}
if [ "${TIMEMORY}" = "ON" ]; then
    : ${TIMEMORY_BRANCH:="graph-storage"}
    git clone -b ${TIMEMORY_BRANCH} https://github.com/jrmadsen/TiMemory.git timemory-source
    cd timemory-source
    SOURCE_DIR=${PWD}
    mkdir timemory-build
    cd timemory-build
    BINARY_DIR=${PWD}
    cmake -DCMAKE_INSTALL_PREFIX=/usr/local -DCMAKE_BUILD_TYPE=${BUILD_TYPE} ${SOURCE_DIR} -G Ninja
    ninja
    ninja install
    cd ${ROOT_DIR}
    rm -rf ${BINARY_DIR} ${SOURCE_DIR}
fi
