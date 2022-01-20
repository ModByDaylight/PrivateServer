@echo off
set version=1.1.10.1
title DBD Private Server (%version%)
echo  ___  ___ ___    ___     _          _         ___
echo ^|   \^| _ )   \  ^| _ \_ _(_)_ ____ _^| ^|_ ___  / __^| ___ _ ___ _____ _ _
echo ^| ^|) ^| _ \ ^|) ^| ^|  _/ '_^| \ V / _` ^|  _/ -_) \__ \/ -_) '_\ V / -_) '_^|
echo ^|___/^|___/___/  ^|_^| ^|_^| ^|_^|\_/\__,_^|\__\___^| ^|___/\___^|_^|  \_/\___^|_^|
echo.
echo DBD Private Server (%version%)
echo.
%SYSTEMROOT%\System32\WindowsPowerShell\v1.0\powershell.exe -Command "& {$webRequest = Invoke-WebRequest https://raw.githubusercontent.com/ModByDaylight/PrivateServer/master/info.txt -UseBasicParsing; $paths = ConvertFrom-StringData -StringData $webRequest.Content; if ( $paths['latestVersion'] -ne '%version%' ) { 'Update available. Please download the latest version. ' + '(' + $paths['latestVersion'] + ')'; echo 'https://github.com/ModByDaylight/PrivateServer/releases/latest' ''; }; }"
if exist gamepath.txt (
    set /p path=<gamepath.txt
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
echo "%c%" is not valid, try again.
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
echo Launching Dead by Daylight
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
if exist "%path%\DeadByDaylight\Content\Paks\pakchunk0-EGS.pak" (
    echo The Private Server is currently unsupported on the Epic Games Store version of Dead by Daylight.
    goto end
)
if exist "%path%\DeadByDaylight\Content\Paks\pakchunk0-WinGDK.pak" (
    echo The Private Server is currently unsupported on the Microsoft Store version of Dead by Daylight.
    goto end
)
echo %path%>gamepath.txt
echo Importing mods...
if not exist "%path%\DeadByDaylight\Content\Paks\~mods" md "%path%\DeadByDaylight\Content\Paks\~mods"
%SYSTEMROOT%\System32\WindowsPowerShell\v1.0\powershell.exe -Command "& {$webRequest = Invoke-WebRequest https://raw.githubusercontent.com/ModByDaylight/PrivateServer/dev/DefaultMods.json -UseBasicParsing; $Data = ConvertFrom-Json $webRequest.Content; $Data.DefaultMods.File | ForEach-Object { 'Downloading' + ' ' + $_.Name + ' ' + '(' + $_.Version + ')' + ' ' + 'by' + ' ' + $_.Author; Invoke-WebRequest -Uri $_.Path -OutFile 'Mods.zip'; Expand-Archive -Path 'Mods.zip' -DestinationPath '%path%\DeadByDaylight\Content\Paks\~mods' -Force; Remove-Item -Path 'Mods.zip' -Force } }"
if exist "%path%\DeadByDaylight.exe" del "%path%\DeadByDaylight.exe"
if exist "%path%\DeadByDaylight\Binaries\Win64\DeadByDaylight-Win64-Shipping.exe" del "%path%\DeadByDaylight\Binaries\Win64\DeadByDaylight-Win64-Shipping.exe"
%SYSTEMROOT%\System32\WindowsPowerShell\v1.0\powershell.exe -Command "& {'Downloading Private Server Executables...'; $webRequest = Invoke-WebRequest https://raw.githubusercontent.com/ModByDaylight/PrivateServer/master/info.txt -UseBasicParsing; $paths = ConvertFrom-StringData -StringData $webRequest.Content; Invoke-WebRequest -Uri $paths['executablesPrivate'] -OutFile 'PrivateExecutables.zip'; Expand-Archive -Path 'PrivateExecutables.zip' -DestinationPath 'PrivateExecutables' -Force; Remove-Item -Path 'PrivateExecutables.zip' -Force }"
%SYSTEMROOT%\System32\WindowsPowerShell\v1.0\powershell.exe -Command "& {'Downloading Live Executables...'; $webRequest = Invoke-WebRequest https://raw.githubusercontent.com/ModByDaylight/PrivateServer/master/info.txt -UseBasicParsing; $paths = ConvertFrom-StringData -StringData $webRequest.Content; Invoke-WebRequest -Uri $paths['executablesLive'] -OutFile 'LiveExecutables.zip'; Expand-Archive -Path 'LiveExecutables.zip' -DestinationPath 'LiveExecutables' -Force; Remove-Item -Path 'LiveExecutables.zip' -Force }"
echo Installing Private Server Executables...
copy PrivateExecutables\DeadByDaylight.exe "%path%"
copy PrivateExecutables\DeadByDaylight-Win64-Shipping.exe "%path%\DeadByDaylight\Binaries\Win64"
echo Setup Complete!
goto end
:end
pause