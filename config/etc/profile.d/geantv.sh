#!/bin/sh

file-source()
{
    for i in $@
    do
        if [ -n "$(which ${i})" ]; then
            echo -e "sourcing $(which ${i})..."
            . $(which ${i})
        fi
    done
}

file-source geantv.sh
file-source geant.sh
