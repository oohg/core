@echo off
rem
rem $Id: compile3264.bat $
rem

if /I "%1"=="/c" "%~dp0.\compile.bat" %1 HM3264 %2 %3 %4 %5 %6 %7 %8 %9
if /I not "%1"=="/c" "%~dp0.\compile.bat" HM3264 %1 %2 %3 %4 %5 %6 %7 %8 %9
