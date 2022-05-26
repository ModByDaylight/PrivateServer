@if "%~1"=="" goto :eof

@echo off
set /p path=<../gamepath.txt
@setlocal enableextensions
@pushd %~dp0
@echo "%~1\*.*" "..\..\..\*.*" >filelist.txt
Engine\Binaries\Win64\UnrealPak.exe "%~1.pak" -create=../../../filelist.txt
move "%~1.pak" "%path%\DeadByDaylight\Content\Paks"
@popd
@pause