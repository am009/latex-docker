#!/bin/bash

SCRIPTPATH="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"

testone() {
    echo "Testing $1"
    docker run -v $(realpath $1):/root/test -it --rm am009/latex bash -c "cd /root/test && ./main.sh"
}

debugone() {
    echo "Debugging $1"
    docker run -v $(realpath $1):/root/test -it --rm am009/latex
}

if [ -z "${1}" ]; then
    # for each folder
    for folder in $(ls -d $SCRIPTPATH/*/); do
        testone $folder
    done
else
    testone $SCRIPTPATH/$1
fi
