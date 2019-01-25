#!/bin/bash -e

# function for running command verbosely
run-verbose()
{
    echo -e "\nRunning : '$@'...\n"
    eval $@
}

#-----------------------------------------------------------------------------#
#
#   apt configuration
#
#-----------------------------------------------------------------------------#

# update
run-verbose apt-get update

# repository for newer compilers
run-verbose apt-get install -y software-properties-common
run-verbose add-apt-repository -u -y ppa:ubuntu-toolchain-r/test
run-verbose apt-get dist-upgrade -y

#-----------------------------------------------------------------------------#
#
#   Base packages
#
#-----------------------------------------------------------------------------#

run-verbose apt-get install -y build-essential cmake git-core

#-----------------------------------------------------------------------------#
#
#   Compiler specific installation
#
#-----------------------------------------------------------------------------#

if [ "${COMPILER_TYPE}" = "gcc" ]; then

    # install compilers
    run-verbose apt-get -y install gcc-${COMPILER_VERSION} g++-${COMPILER_VERSION} gcc-${COMPILER_VERSION}-multilib

elif [ "${COMPILER_TYPE}" = "llvm" ]; then

    # install compilers
    run-verbose apt-get -y install clang-${COMPILER_VERSION} libc++-dev libc++abi-dev

fi

#-----------------------------------------------------------------------------#
#
#   Install supplemental packages
#
#-----------------------------------------------------------------------------#

run-verbose apt-get install -y \
    libxerces-c-dev libexpat1-dev libhdf5-dev \
    xserver-xorg libhdf5-openmpi-dev freeglut3-dev \
    libx11-dev libx11-xcb-dev libxpm-dev libxft-dev libxmu-dev libxv-dev libxrandr-dev \
    libglew-dev libftgl-dev libxkbcommon-x11-dev libxrender-dev libxxf86vm-dev libxinerama-dev \
    qt5-default

#-----------------------------------------------------------------------------#
#
#   TiMemory
#
#-----------------------------------------------------------------------------#

if [ "${TIMEMORY}" = "ON" ]; then
    # TODO: build timemory
    echo "TiMemory not setup"
fi

#-----------------------------------------------------------------------------#
#   ALTERNATIVES
#-----------------------------------------------------------------------------#
priority=10
for i in 5 6 7 8
do
    if [ -n "$(which gcc-${i})" ]; then
        run-verbose update-alternatives --install $(which gcc) gcc $(which gcc-${i}) ${priority} \
            --slave $(which g++) g++ $(which g++-${i})
        run-verbose priority=$(( ${priority}+10 ))
    fi
done

priority=10
for i in 5 6 7
do
    if [ -n "$(which clang-${i}.0)" ]; then
        run-verbose update-alternatives --install /usr/bin/clang clang $(which clang-${i}.0) ${priority} \
            --slave /usr/bin/clang++ clang++ $(which clang++-${i}.0)
        run-verbose priority=$(( ${priority}+10 ))
    fi
done

priority=10
if [ -n "$(which clang)" ]; then
    run-verbose update-alternatives --install $(which cc)  cc  $(which clang)   ${priority}
    run-verbose update-alternatives --install $(which c++) c++ $(which clang++) ${priority}
    run-verbose priority=$(( ${priority}+10 ))
fi

if [ -n "$(which gcc)" ]; then
    run-verbose update-alternatives --install $(which cc)  cc  $(which gcc)     ${priority}
    run-verbose update-alternatives --install $(which c++) c++ $(which g++)     ${priority}
fi

#-----------------------------------------------------------------------------#
#   CLEANUP
#-----------------------------------------------------------------------------#
run-verbose apt-get -y autoclean
run-verbose rm -rf /var/lib/apt/lists/*
