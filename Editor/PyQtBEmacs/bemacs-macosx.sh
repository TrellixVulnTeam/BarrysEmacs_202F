#!/bin/bash
export PYTHONPATH=${BUILDER_TOP_DIR}/Editor/PythonBEmacs:${BUILDER_TOP_DIR}/Editor/obj-pybemacs
export BEMACS_EMACS_LIBRARY=${BUILDER_TOP_DIR}/Kits/MacOSX/pkg/Barry\'s\ Emacs-Devel.app/Contents/Resources/emacs_library
# BArry's quote handling...
export BEMACS_FIFO=.bemacs8devel/.emacs_command

if [ "$1" = "--lldb" ]
then
    shift 1
    echo
    rm -f .lldbinit
    if [ -e init.lldb ]
    then
        cat init.lldb >.lldbinit
    fi
    echo
    lldb -- python${PYTHON_VERSION} -u be_main.py "$@"

else
    which python${PYTHON_VERSION}
    python${PYTHON_VERSION} -u be_main.py "$@"
fi
