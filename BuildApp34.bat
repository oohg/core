@echo off
rem
rem $Id: BuildApp34.bat $
rem

if /I "%1"=="/c" "%~dp0.\BuildApp.bat" %1 HM34 %2 %3 %4 %5 %6 %7 %8 %9
if /I not "%1"=="/c" "%~dp0.\BuildApp.bat" HM34 %1 %2 %3 %4 %5 %6 %7 %8 %9
