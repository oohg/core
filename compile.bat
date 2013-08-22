@echo off
rem
rem $Id: compile.bat,v 1.18 2013-08-22 22:25:02 fyurisich Exp $
rem
cls

rem *** Set Paths ***
if "%HG_ROOT%"=="" set HG_ROOT=c:\oohg

rem *** Call Compiler Specific Batch File ***
call %HG_ROOT%\compile_mingw.bat %1 %2 %3 %4 %5 %6 %7 %8 %9
