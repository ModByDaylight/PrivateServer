@echo off
set version=1.1.9
title DBD Private Server Setup (%version%)
echo  ___  ___ ___    ___     _          _         ___
echo ^|   \^| _ )   \  ^| _ \_ _(_)_ ____ _^| ^|_ ___  / __^| ___ _ ___ _____ _ _
echo ^| ^|) ^| _ \ ^|) ^| ^|  _/ '_^| \ V / _` ^|  _/ -_) \__ \/ -_) '_\ V / -_) '_^|
echo ^|___/^|___/___/  ^|_^| ^|_^| ^|_^|\_/\__,_^|\__\___^| ^|___/\___^|_^|  \_/\___^|_^|
echo.
echo DBD Private Server Setup (%version%)
echo.
if exist gamepath.txt (
    set /p path=<gamepath.txt
    goto start
) else (
    goto paths
)
:start
echo [1]. Launch Live
echo [2]. Launch Private Server
echo [3]. Setup Private Server
echo.
set choice=
set /p choice=Select an option: 
if not '%choice%'=='' set choice=%choice:~0,1%
if '%choice%'=='1' goto launchLive
if '%choice%'=='2' goto launchPrivate
if '%choice%'=='3' goto setupPrivate
if '%choice%'=='4' goto setupConfig
echo "%choice%" is not valid, try again.
echo.
goto start
:paths
set path=C:\Program Files (x86)\Steam\steamapps\common\Dead by Daylight
echo Is this where DBD is installed? %path% [Y/N]
set /P c=
if /I "%c%" EQU "N" goto :dbdlocation
if /I "%c%" EQU "NO" goto :dbdlocation
if /I "%c%" EQU "Y" goto :setupPrivate
if /I "%c%" EQU "YES" goto :setupPrivate
echo It's a yes or no question Jimmy...
goto :paths
::If user chooses N they manually enter a directory where DBD is installed.
:dbdlocation
echo Please set your directory below.
set /p path=
goto setupPrivate
:launchLive
echo Copying Live Executables...
del "%path%\DeadByDaylight.exe"
del "%path%\DeadByDaylight\Binaries\Win64\DeadByDaylight-Win64-Shipping.exe"
copy LiveExecutables\DeadByDaylight.exe "%path%" 
copy LiveExecutables\DeadByDaylight-Win64-Shipping.exe "%path%\DeadByDaylight\Binaries\Win64"
echo Launching Dead By Daylight
start steam://rungameid/381210
goto end
:launchPrivate
echo Copying Private Server Executables...
del "%path%\DeadByDaylight.exe"
del "%path%\DeadByDaylight\Binaries\Win64\DeadByDaylight-Win64-Shipping.exe"
copy PrivateExecutables\DeadByDaylight.exe "%path%" 
copy PrivateExecutables\DeadByDaylight-Win64-Shipping.exe "%path%\DeadByDaylight\Binaries\Win64" 
echo Launching Private Server
start steam://rungameid/381210
goto end
:setupPrivate
echo %path%>gamepath.txt
echo Importing custom pak chunks...
if not exist "%path%\DeadByDaylight\Content\Paks\~mods" mkdir "%path%\DeadByDaylight\Content\Paks\~mods"
if exist pakchunk40-WindowsNoEditor.pak move pakchunk40-WindowsNoEditor.pak "%path%\DeadByDaylight\Content\Paks\~mods"
if exist pakchunk40-WindowsNoEditor.sig move pakchunk40-WindowsNoEditor.sig "%path%\DeadByDaylight\Content\Paks\~mods"
echo Downloading Live Executables...
if exist "%path%\DeadByDaylight.exe" del "%path%\DeadByDaylight.exe"
if exist "%path%\DeadByDaylight\Binaries\Win64\DeadByDaylight-Win64-Shipping.exe" del "%path%\DeadByDaylight\Binaries\Win64\DeadByDaylight-Win64-Shipping.exe"
echo Launching Steam...
echo Try running the setup again if you receive an error message in Steam.
:downloadExecutables
start steam://rungameid/381210
C:\Windows\System32\TASKKILL.exe /FI "WINDOWTITLE eq Steam - Error*" >nul
if exist "%path%\DeadByDaylight.exe" (
    echo Sucessfully downloaded DeadByDaylight.exe
    if exist "%path%\DeadByDaylight\Binaries\Win64\DeadByDaylight-Win64-Shipping.exe" (
        echo Sucessfully downloaded DeadByDaylight-Win64-Shipping.exe
        echo Moving Live Executables...
        move "%path%\DeadByDaylight.exe" LiveExecutables
        move "%path%\DeadByDaylight\Binaries\Win64\DeadByDaylight-Win64-Shipping.exe" LiveExecutables
    ) else goto downloadExecutables
) else goto downloadExecutables
:copyExecutables
if not exist LiveExecutables mkdir LiveExecutables
echo Installing Private Server Executables...
copy PrivateExecutables\DeadByDaylight.exe "%path%"
copy PrivateExecutables\DeadByDaylight-Win64-Shipping.exe "%path%\DeadByDaylight\Binaries\Win64"
echo Setup Complete!
:end
pause