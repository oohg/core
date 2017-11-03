@echo off
rem
rem $Id: compileXB.bat $
rem

if /I "%1"=="/c" compile %1 XB %2 %3 %4 %5 %6 %7 %8 %9
if not /I "%1"=="/c" compile XB %1 %2 %3 %4 %5 %6 %7 %8 %9
