@echo off
if /I "%1"=="/c" "%~dp0.\buildlib.bat" %1 HM34 %2 %3 %4 %5 %6 %7 %8 %9
if /I not "%1"=="/c" "%~dp0.\buildlib.bat" HM34 %1 %2 %3 %4 %5 %6 %7 %8 %9
