#!/bin/bash
echo "Info: build-macosx.sh Editor/PyQtBEmacs - start"
PKG_DIST_DIR=${BUILDER_TOP_DIR}/Kits/MacOSX/pkg

if [ "$1" = "--package" ]
then
    DIST_DIR=${PKG_DIST_DIR}
else
    DIST_DIR=dist
fi

QT_KIT_PATH=~/Qt-5.6.1/5.6

rm -rf build ${DIST_DIR}

mkdir -p ${DIST_DIR}
${PYTHON} make_be_images.py
export PYTHONPATH=${BUILDER_TOP_DIR}/Editor/obj-pybemacs:$HOME/wc/hg/macholib
${PYTHON} setup-macosx.py py2app --dist-dir ${DIST_DIR} --no-strip 2>&1 | tee a.log

set -x
pushd "${DIST_DIR}/Barry's Emacs-Devel.app/Contents" >/dev/null

if false
then
cp -R \
    /Library/Frameworks/Python.framework/Versions/3.5/lib/python3.5/site-packages/PyQt5/Qt \
    Resources/lib/python3.5/lib-dynload/PyQt5

else
for PYQT_SO in Resources/lib/python3.5/lib-dynload/PyQt5/*.so
do
    otool -l ${PYQT_SO} | grep -e LC_RPATH -A 2
    install_name_tool -rpath "${QT_KIT_PATH}/clang_64/lib" "@executable_path/../Frameworks" ${PYQT_SO}
    install_name_tool -delete_rpath "${QT_KIT_PATH}/clang_64/lib" ${PYQT_SO}
    install_name_tool -add_rpath "@loader_path/../../../../Frameworks" ${PYQT_SO}
    otool -l ${PYQT_SO} | grep -e LC_RPATH -A 2
done

for LIBNAME in \
    QtCore \
    QtDBus \
    QtGui \
    QtPrintSupport \
    QtSvg \
    QtWidgets \
    ;
do
    echo "Info: Copy framework ${LIBNAME}"
    cp -R \
        "${BUILDER_QTDIR}/clang_64/lib/${LIBNAME}.framework" \
        "Frameworks"

    otool -l Frameworks/${LIBNAME}.framework/${LIBNAME} | grep -e LC_RPATH -A 2
done

echo "Info: remove Headers links"
find "Frameworks" -type l -name 'Headers' -exec rm -f {} ';'
echo "Info: remove Headers dirs"
find -d "Frameworks" -type d -name 'Headers' -exec rm -rf {} ';'

for PLUGIN in \
    imageformats/libqdds.dylib \
    imageformats/libqgif.dylib \
    imageformats/libqicns.dylib \
    imageformats/libqico.dylib \
    imageformats/libqjpeg.dylib \
    imageformats/libqsvg.dylib \
    imageformats/libqtga.dylib \
    imageformats/libqtiff.dylib \
    imageformats/libqwbmp.dylib \
    imageformats/libqwebp.dylib \
    platforms/libqcocoa.dylib \
    ;
do
    echo "Info: Copy plugin ${PLUGIN}"
    TARGET_DIR=$( dirname "Resources/plugins/${PLUGIN}" )
    mkdir -p "${TARGET_DIR}"
    cp \
        "${BUILDER_QTDIR}/clang_64/plugins/${PLUGIN}" \
        "${TARGET_DIR}"

    otool -l Resources/plugins/${PLUGIN} | grep -e LC_RPATH -A 2
    install_name_tool -rpath "@loader_path/../../lib" "@executable_path/../Frameworks" Resources/plugins/${PLUGIN}
    otool -l Resources/plugins/${PLUGIN} | grep -e LC_RPATH -A 2
done
fi

mkdir -p "Resources/emacs_library"
mkdir -p "Resources/documentation"

if [ "$1" != "--package" ]
then
    cp \
        "${PKG_DIST_DIR}/Barry's Emacs-Devel.app/Contents/Resources/emacs_library"/* \
        "Resources/emacs_library"
    cp \
        "${PKG_DIST_DIR}/Barry's Emacs-Devel.app/Contents/Resources/documentation"/* \
        "Resources/documentation"
fi
popd >/dev/null
echo "Info: build-macosx.sh Editor/PyQtBEmacs - end"
