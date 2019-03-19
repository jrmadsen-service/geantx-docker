#!/bin/sh

file-source()
{
    for i in $@
    do
        if [ -n "$(which ${i})" ]; then
            echo -e "sourcing $(which ${i})..."
            . $(which ${i})
        else
            path=$(find / -type f | grep ${i} | head -n 1)
            if [ -n "${path}" ]; then
                . ${path}
            fi
        fi
    done
}

file-source geant4.sh
file-source thisroot.sh
