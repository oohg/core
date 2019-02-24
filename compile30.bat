@echo off
rem
rem $Id: compile30.bat $
rem

if /I "%1"=="/c" "%~dp0.\compile.bat" %1 HM30 %2 %3 %4 %5 %6 %7 %8 %9
if /I not "%1"=="/c" "%~dp0.\compile.bat" HM30 %1 %2 %3 %4 %5 %6 %7 %8 %9
