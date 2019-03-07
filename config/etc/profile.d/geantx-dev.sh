#!/bin/sh

if [ -n "${CUDA_HOME}" ]; then
    PATH=${CUDA_HOME}/bin:${PATH}
    export PATH
fi
