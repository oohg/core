@echo off
rem
rem $Id: compile.bat,v 1.19 2015-03-09 00:27:30 fyurisich Exp $
rem
cls

rem *** Set Paths ***
if "%1"=="/C" goto CLEAN_PATH
if "%1"=="/c" goto CLEAN_PATH
if "%HG_ROOT%"==""  set HG_ROOT=c:\oohg
if "%HG_HRB%"==""   set HG_HRB=%HG_ROOT%\harbour
if "%HG_MINGW%"=="" set HG_MINGW=%HG_ROOT%\mingw
if "%LIB_GUI%"==""  set LIB_GUI=lib
if "%LIB_HRB%"==""  set LIB_HRB=lib
if "%BIN_HRB%"==""  set BIN_HRB=bin
goto COMPILE

:CLEAN_PATH
set HG_ROOT=c:\oohg
set HG_HRB=%HG_ROOT%\harbour
set HG_MINGW=%HG_ROOT%\mingw
set LIB_GUI=lib
set LIB_HRB=lib
set BIN_HRB=bin
shift

:COMPILE

rem *** Call Compiler Specific Batch File ***
call %HG_ROOT%\compile_mingw.bat %1 %2 %3 %4 %5 %6 %7 %8 %9
