#!/bin/echo Usage: . $0

export BUILDER_CFG_PLATFORM=$(uname -s)
export PYTHON_VERSION=${1:-2.6}
case ${BUILDER_CFG_PLATFORM} in

Darwin)
    export BUILDER_CFG_PLATFORM=MacOSX
    ;;

Linux)
    if [ -e /etc/fedora-release ]
    then
        export BUILDER_CFG_PLATFORM=Linux-Fedora

    elif [ -e /etc/lsb-release -a "$( grep "DISTRIB_ID=Ubuntu" /etc/lsb-release )" == "DISTRIB_ID=Ubuntu" ]
    then
        export BUILDER_CFG_PLATFORM=Linux-Ubuntu

    fi
    ;;
*)
    # no need to change
    ;;
esac

echo Info: WorkingDir: ${BUILDER_TOP_DIR}
echo Info: Config Platform: ${BUILDER_CFG_PLATFORM}
echo Info: Python Version: ${PYTHON_VERSION}
