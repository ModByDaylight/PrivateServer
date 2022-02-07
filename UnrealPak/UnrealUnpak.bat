@if "%~1"=="" goto :eof

@echo off
@setlocal enableextensions
@pushd %~dp0
.\UnrealPak.exe %1 -extract "%~n1" -extracttomountpoint
@popd
@pause