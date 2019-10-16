#!/bin/sh

file-source()
{
    for i in $@
    do
        if [ -n "$(which ${i})" ]; then
            . $(which ${i})
        fi
    done
}

file-source geant4.sh
