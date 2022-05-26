@if "%~1"=="" goto :eof
@if not "%~x1"==".pak" goto :eof

@echo off
@setlocal enableextensions
@pushd %~dp0
Engine\Binaries\Win64\UnrealPak.exe %1 -extract ../../../"%~n1" -extracttomountpoint
@popd
@pause