@echo off
rem
rem $Id: compile32.bat $
rem

if /I "%1"=="/c" "%~dp0.\compile.bat" %1 HB32 %2 %3 %4 %5 %6 %7 %8 %9
if /I not "%1"=="/c" "%~dp0.\compile.bat" HB32 %1 %2 %3 %4 %5 %6 %7 %8 %9
