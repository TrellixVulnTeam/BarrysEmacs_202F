#!/bin/sh
${PYTHON} setup.py linux Makefile
NUM_PROC=$( grep -i ^processor /proc/cpuinfo |wc -l )
make -j ${NUM_PROC} -f Makefile "$@"
