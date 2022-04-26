@if "%~1"=="" goto :eof

@echo off
set /p path=<../gamepath.txt
if exist "%path%\DeadByDaylight\Content\Paks\pakchunk0-WindowsNoEditor.pak" set platform=WindowsNoEditor
if exist "%path%\DeadByDaylight\Content\Paks\pakchunk0-EGS.pak" set platform=EGS
if exist "%path%\DeadByDaylight\Content\Paks\pakchunk0-WinGDK.pak" set platform=WinGDK
@setlocal enableextensions
@pushd %~dp0
@echo "%~1\*.*" "..\..\..\*.*" >filelist.txt
.\UnrealPak.exe "%~1.pak" -create=filelist.txt -compress
copy /y "%path%\DeadByDaylight\Content\Paks\pakchunk39-%platform%.sig" "%~1.sig"
move "%~1.pak" "%path%\DeadByDaylight\Content\Paks\~mods"
move "%~1.sig" "%path%\DeadByDaylight\Content\Paks\~mods"
@popd
@pause