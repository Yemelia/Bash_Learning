#!/bin/bash

in_path()
{
    cmd=$1
    oldIFS=$IFS
    ourpath=$2
    IFS=':'
    result=1
    for directory in $ourpath; do
        if [ -x "$directory/$cmd" ] ; then
        result=0
        fi
    done

    IFS=$oldIFS
    return $result
}

checkForCmdInPath()
{
    var=$1
    if [ "$var" != "" ]; then
        if [ "${var%${var#?}}" = "/" ]; then
            if [ ! -x $var ]; then
                return 1
            fi
        elif ! in_path $var "$PATH"; then
            return 2
        fi
    fi
}

if [ $# -ne 1 ]; then
    echo "Usage: $0 command" >&2
    exit 1
fi

checkForCmdInPath "$1"
case $? in
    0 ) echo "$1 found in PATH" ;;
    1 ) echo "$1 not found or not executable" ;;
    2 ) echo "$1 not found in PATH" ;;
esac

exit 0