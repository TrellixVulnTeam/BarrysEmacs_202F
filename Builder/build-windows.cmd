@echo off
if "%BUILDER_TOP_DIR%" == "" (
    echo Error: BUILDER_TOP_DIR is not set. Hint: run builder_custom_init.cmd
    goto :eof
)
if "%BUILDER_CFG_PLATFORM%" == "" (
    echo Error: BUILDER_CFG_PLATFORM is not set. Hint: fix builder_custom_init.cmd to set it.
    goto :eof
)

if "%PYTHON%" == "" (
    echo Error: PYTHON is not set. Hint: fix builder_custom_init.cmd to set it.
    goto :eof
)

call :check_for_pip_dependency PyQt5 "from PyQt5 import QtWidgets, QtGui, QtCore"
if errorlevel 1 goto :eof
call :check_for_pip_dependency xml-preferences "import xml_preferences"
if errorlevel 1 goto :eof
call :check_for_pip_dependency win-app-packager "import win_app_packager"
if errorlevel 1 goto :eof

nmake -f Windows.mak PYTHON=%python% clean
if exist c:\unxutils\tee.exe (
    nmake -f Windows.mak INSTALL=%1 PYTHON=%PYTHON% build 2>&1 | c:\unxutils\tee build.log
) else (
    nmake -f Windows.mak INSTALL=%1 PYTHON=%PYTHON% build
)

goto :eof

:check_for_pip_dependency
    %PYTHON% -c %2 2>nul
    if errorlevel 1 (
        echo Error: %1 is not installed for %PYTHON%. Hint: %PYTHON% -m pip install %1
        exit /b 1
    )
    exit /b 0
