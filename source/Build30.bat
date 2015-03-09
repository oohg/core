@echo off
rem
rem $Id: Build30.bat,v 1.1 2015-03-09 23:27:01 fyurisich Exp $
rem
cls

rem *** Set Paths ***
if "%1"=="/C" goto CLEAN_PATH
if "%1"=="/c" goto CLEAN_PATH
if "%HG_ROOT%"==""  set HG_ROOT=c:\oohg
if "%HG_HRB%"==""   set HG_HRB=c:\oohg\harbour
if "%HG_MINGW%"=="" set HG_MINGW=c:\oohg\mingw
if "%LIB_GUI%"==""  set LIB_GUI=lib
if "%LIB_HRB%"==""  set LIB_HRB=lib
if "%BIN_HRB%"==""  set BIN_HRB=bin
goto BUILD

:CLEAN_PATH
set HG_ROOT=c:\oohg
set HG_HRB=c:\oohg\harbour
set HG_MINGW=c:\oohg\mingw
set LIB_GUI=lib
set LIB_HRB=lib
set BIN_HRB=bin
shift

:BUILD
call BuildLib.bat %1 %2 %3 %4 %5 %6 %7 %8 %9
