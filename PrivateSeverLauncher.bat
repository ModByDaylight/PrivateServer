@echo off
set version=2.1.1
set branch=master
set autoUpdateBinaries=true
set pwsh=%SYSTEMROOT%\System32\WindowsPowerShell\v1.0\powershell.exe -Command
title DBD Private Server (%version%)
echo  ___  ___ ___    ___     _          _         ___
echo ^|   \^| _ )   \  ^| _ \_ _(_)_ ____ _^| ^|_ ___  / __^| ___ _ ___ _____ _ _
echo ^| ^|) ^| _ \ ^|) ^| ^|  _/ '_^| \ V / _` ^|  _/ -_) \__ \/ -_) '_\ V / -_) '_^|
echo ^|___/^|___/___/  ^|_^| ^|_^| ^|_^|\_/\__,_^|\__\___^| ^|___/\___^|_^|  \_/\___^|_^|
echo.
echo DBD Private Server (%version%)
echo.
%pwsh% "& {[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; $webRequest = Invoke-WebRequest https://raw.githubusercontent.com/ModByDaylight/PrivateServer/%branch%/PrivateServer.json -UseBasicParsing; $Data = ConvertFrom-Json $webRequest.Content; if ( $Data.latestVersion -gt '%version%' ) { 'Update available. Please download the latest version. ' + '(' + $Data.latestVersion + ')'; echo 'https://github.com/ModByDaylight/PrivateServer/releases/latest' } }"
if exist gamepath.txt (
    set /p path=<gamepath.txt
) else goto :paths
call :platformCheck
if exist "%path%/.cache/BinariesVersion.json" call :updateBinaries
if exist "%path%/.cache/InstalledMods.json" call :updateMods
:start
echo [1]. Launch Live
echo [2]. Launch Private Server
echo [3]. Manage Private Server
echo [4]. Open Mods Folder
echo.
set launchOption=
set /p launchOption="Select an option: "
if not '%launchOption%'=='' set launchOption=%launchOption:~0,1%
if '%launchOption%'=='1' goto :launchLive
if '%launchOption%'=='2' goto :launchPrivate
if '%launchOption%'=='3' goto :managePrivate
if '%launchOption%'=='4' goto :modFolder
echo "%launchOption%" is not valid, try again.
echo.
goto :start
:paths
set path=C:\Program Files (x86)\Steam\steamapps\common\Dead by Daylight
echo Is this where DBD is installed? %path% [Y/N]
set /p installPath=
if /i '%installPath%'=='Y' goto :setupPrivate
if /i '%installPath%'=='YES' goto :setupPrivate
if /i '%installPath%'=='N' goto :dbdlocation
if /i '%installPath%'=='NO' goto :dbdlocation
echo "%installPath%" is not valid, try again.
goto :paths
:dbdlocation
echo Please set your directory below.
set /p path=
goto :setupPrivate
:launchLive
echo Launching Dead by Daylight
start %launch%
goto :end
:launchPrivate
echo Launching Private Server
cd %path%
start DeadByDaylight-Modded.exe
goto :end
:modFolder
%pwsh% "& {Invoke-Item '%path%\DeadByDaylight\Content\Paks\~mods'}"
pause
goto :start
:managePrivate
echo.
echo [1]. Repair Private Server
echo [2]. Uninstall Private Server
echo [3]. Back
echo.
set launchOption=
set /p launchOption="Select an option: "
if not '%launchOption%'=='' set launchOption=%launchOption:~0,1%
if '%launchOption%'=='1' goto :setupPrivate
if '%launchOption%'=='2' goto :uninstallPrivate
if '%launchOption%'=='3' goto :start
echo "%launchOption%" is not valid, try again.
echo.
goto :managePrivate
:setupPrivate
call :platformCheck
echo %path%>gamepath.txt
if not exist "%path%\DeadByDaylight\Content\Paks\~mods" md "%path%\DeadByDaylight\Content\Paks\~mods"
%pwsh% "& {'Installing required mods...'; [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; $webRequest = Invoke-WebRequest https://raw.githubusercontent.com/ModByDaylight/PrivateServer/%branch%/DefaultMods.json -UseBasicParsing; $Data = ConvertFrom-Json $webRequest.Content; $Data.DefaultMods | ForEach-Object { 'Downloading' + ' ' + $_.Name + ' ' + '(' + $_.Version + ')' + ' ' + 'by' + ' ' + $_.Author; Invoke-WebRequest -Uri $_.DownloadLink -OutFile 'Mods.zip'; Expand-Archive -Path 'Mods.zip' -DestinationPath 'temp' -Force; Remove-Item -Path 'Mods.zip' -Force }; $hash = @{}; foreach ($i in $Data.DefaultMods) { $hash.add($i.UUID,$i.Version) }; $hash | ConvertTo-Json -Depth 10 | Out-File '%path%\.cache\InstalledMods.json'; if (Test-Path 'temp') { Get-ChildItem -Path 'temp\*' -Include *.pak, *.sig -Recurse | Move-Item -Destination '%path%\DeadByDaylight\Content\Paks\~mods' -Force; Remove-Item -Path 'temp' -Force -Recurse }"
if not exist "%path%\.cache" md "%path%\.cache"
%pwsh% "& {'Downloading Private Server Binaries...'; [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; $webRequest = Invoke-WebRequest https://raw.githubusercontent.com/ModByDaylight/PrivateServer/%branch%/PrivateServer.json -UseBasicParsing; $Data = ConvertFrom-Json $webRequest.Content; Invoke-WebRequest -Uri $Data.executablesPrivate%binaries% -OutFile 'PrivateExecutables.zip'; Expand-Archive -Path 'PrivateExecutables.zip' -DestinationPath 'PrivateExecutables' -Force; Copy-Item -Path 'PrivateExecutables\DBDPrivateServerFiles\DeadByDaylight-Modded.exe' -Destination '%path%' -Force; Copy-Item -Path 'PrivateExecutables\DBDPrivateServerFiles\DeadByDaylight\Binaries\%binaries%\*' -Destination '%path%\DeadByDaylight\Binaries\%binaries%' -Force; Remove-Item -Path 'PrivateExecutables.zip' -Force; Remove-Item -Path 'PrivateExecutables' -Force -Recurse; @{binariesVersion=$Data.latestBinaries} | ConvertTo-Json | Out-File '%path%\.cache\BinariesVersion.json' }"
echo Installation Complete!
goto :end
:uninstallPrivate
echo Uninstalling Private Server...
%pwsh% "& {$ErrorActionPreference = 'SilentlyContinue'; Remove-Item '%path%\DeadByDaylight-Modded.exe', '%path%\DeadByDaylight\Binaries\%binaries%\DBDModLoader.dll', '%path%\DeadByDaylight\Binaries\%binaries%\DBDModLoader.dll', '%path%\DeadByDaylight\Binaries\%binaries%\PolyHook_2.dll', '%path%\DeadByDaylight\Binaries\%binaries%\steam_appid.txt', '%path%\DeadByDaylight\Binaries\%binaries%\UnrealFramework.dll' }"
echo Completed.
goto :end
:platformCheck
if exist "%path%\DeadByDaylight\Content\Paks\pakchunk0-WindowsNoEditor.pak" (
    set binaries=Win64
    set launch=steam://rungameid/381210
    goto :eof
)
if exist "%path%\DeadByDaylight\Content\Paks\pakchunk0-EGS.pak" (
    set binaries=EGS
    set launch=com.epicgames.launcher://apps/Brill?action=launch&silent=true
    echo The Private Server is currently unsupported on the Epic Games Store version of Dead by Daylight.
    goto :end
)
if exist "%path%\DeadByDaylight\Content\Paks\pakchunk0-WinGDK.pak" (
    set binaries=WinGDK
    set launch=shell:appsFolder\BehaviourInteractive.DeadbyDaylightWindows_b1gz2xhdanwfm!AppDeadByDaylightShipping
    echo The Private Server is currently unsupported on the Microsoft Store version of Dead by Daylight.
    goto :end
)
echo Invalid directory, try again.
goto :dbdlocation
:updateBinaries
if '%autoUpdateBinaries%'=='true' %pwsh% "& {[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; $webRequest = Invoke-WebRequest https://raw.githubusercontent.com/ModByDaylight/PrivateServer/%branch%/PrivateServer.json -UseBasicParsing; $Data = ConvertFrom-Json $webRequest.Content; $json = Get-Content '%path%\.cache\BinariesVersion.json' | Out-String | ConvertFrom-Json; if ( $Data.latestBinaries -gt $json.binariesVersion ) { 'Updating Private Server Binaries...'; Invoke-WebRequest -Uri $Data.executablesPrivate%binaries% -OutFile 'PrivateExecutables.zip'; Expand-Archive -Path 'PrivateExecutables.zip' -DestinationPath 'PrivateExecutables' -Force; Copy-Item -Path 'PrivateExecutables\DBDPrivateServerFiles\DeadByDaylight-Modded.exe' -Destination '%path%' -Force; Copy-Item -Path 'PrivateExecutables\DBDPrivateServerFiles\DeadByDaylight\Binaries\%binaries%\*' -Destination '%path%\DeadByDaylight\Binaries\%binaries%' -Force; Remove-Item -Path 'PrivateExecutables.zip' -Force; Remove-Item -Path 'PrivateExecutables' -Force -Recurse; @{binariesVersion=$Data.latestBinaries} | ConvertTo-Json | Out-File '%path%\.cache\BinariesVersion.json'; '' } }"
goto :eof
:updateMods
if '%autoUpdateBinaries%'=='true' %pwsh% "& {[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; $webRequest = Invoke-WebRequest https://raw.githubusercontent.com/ModByDaylight/PrivateServer/%branch%/DefaultMods.json -UseBasicParsing; $Data = ConvertFrom-Json $webRequest.Content; $json = Get-Content '%path%\.cache\InstalledMods.json' | Out-String | ConvertFrom-Json; foreach ($i in $Data.DefaultMods.UUID) { $DefaultMods = $Data.DefaultMods | Where-Object { $_.UUID -eq $i }; if ( $DefaultMods.Version -gt $json.$i ) { 'Updating' + ' ' + $DefaultMods.Name + ' ' + '(' + $DefaultMods.Version + ')' + ' ' + 'by' + ' ' + $DefaultMods.Author; Invoke-WebRequest -Uri $DefaultMods.DownloadLink -OutFile 'Mods.zip'; Expand-Archive -Path 'Mods.zip' -DestinationPath 'temp' -Force; Remove-Item -Path 'Mods.zip' -Force; } $hash = @{}; foreach ($i in $Data.DefaultMods) { $hash.add($i.UUID,$i.Version) }; $hash | ConvertTo-Json -Depth 10 | Out-File '%path%\.cache\InstalledMods.json'}; if (Test-Path 'temp') { Get-ChildItem -Path 'temp\*' -Include *.pak, *.sig -Recurse | Move-Item -Destination '%path%\DeadByDaylight\Content\Paks\~mods' -Force; Remove-Item -Path 'temp' -Force -Recurse } }"
goto :eof
:end
pause
exit