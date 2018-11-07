setlocal
@echo on
rem 
if "%1" == "" set DIST_DIR=dist
if not "%1" == "" set DIST_DIR=%1
echo Info: DIST_DIR=%DIST_DIR%

set PYTHONPATH=..\exe-pybemacs
%PYTHON% -u make_be_images.py
    if errorlevel 1 goto :error
%PYTHON% -m win_app_packager build be_main.py   --gui %DIST_DIR% --icon ..\Source\Windows\Resources\win_emacs.ico --name bemacs_server --verbose
    if errorlevel 1 goto :error
%PYTHON% -m win_app_packager build be_client.py --gui %DIST_DIR% --icon ..\Source\Windows\Resources\win_emacs.ico --name bemacs --merge
    if errorlevel 1 goto :error

pushd %DIST_DIR%\PyWinAppRes\PyQt5
    if errorlevel 1 goto :error

echo Info: clean up Qt 1. move all pyd and dll into a tmp folder
mkdir tmp
    if errorlevel 1 goto :error
move Qt*.pyd tmp >NUL
    if errorlevel 1 goto :error
move tmp\Qt.pyd . >NUL
    if errorlevel 1 goto :error

mkdir Qt\bin\tmp
    if errorlevel 1 goto :error
move Qt\bin\Qt5*.dll Qt\bin\tmp >NUL
    if errorlevel 1 goto :error

echo Info: clean up Qt 2. bring back only the ones we use
for %%x in (Core DBus Gui PrintSupport Svg Widgets) do call :qt_keep %%x

echo Info: clean up Qt 3. delete the Qt files we do not need
rmdir /s /q tmp
    if errorlevel 1 goto :error
rmdir /s /q Qt\bin\tmp
    if errorlevel 1 goto :error

echo Info: clean up Qt 4. delete qml file
rmdir /s /q Qt\qml
    if errorlevel 1 goto :error

echo Info: clean up Qt 5. delete translations file
rmdir /s /q Qt\translations
    if errorlevel 1 goto :error

echo Info: clean up Qt 6. delete webengine files
del Qt\bin\QtWebEngineProcess.exe >NUL
    if errorlevel 1 goto :error
del Qt\resources\qtwebengine*.pak >NUL
    if errorlevel 1 goto :error

echo Info: clean up Qt 6. delete qsci resources 
rmdir /s /q Qt\qsci
    if errorlevel 1 goto :error

echo on
echo Info: clean up python lib 1. delete test code
rmdir /s /q %DIST_DIR%\PyWinAppRes\Lib\ctypes\test
    if errorlevel 1 goto :error
rmdir /s /q %DIST_DIR%\PyWinAppRes\Lib\unittest\test
    if errorlevel 1 goto :error

popd

echo Info: build-windows completed successfully
exit /b 0
endlocal

:qt_keep
    echo Info: Keeping Qt%1
    move tmp\Qt%1.pyd . >NUL
        if errorlevel 1 goto :error
    move Qt\bin\tmp\Qt5%1.dll Qt\bin >NUL
        if errorlevel 1 goto :error
    goto :eof

:error
    echo Error: build-windows failed
    exit /b 1
