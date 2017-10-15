@echo off
rem
rem $Id: BuildApp30.bat,v 1.2 2015-03-14 01:11:45 fyurisich Exp $
rem
cls

rem *** Set Paths ***
if "%1"=="/C" goto CLEAN_PATH
if "%1"=="/c" goto CLEAN_PATH
if "%HG_ROOT%"==""  set HG_ROOT=c:\oohg
if "%HG_HRB%"==""   set HG_HRB=c:\oohg\hb30
if "%HG_MINGW%"=="" set HG_MINGW=c:\oohg\hb30\comp\mingw
if "%LIB_GUI%"==""  set LIB_GUI=lib
if "%LIB_HRB%"==""  set LIB_HRB=lib
if "%BIN_HRB%"==""  set BIN_HRB=bin
goto COMPILE

:CLEAN_PATH

   set HG_ROOT=c:\oohg
   set HG_HRB=c:\oohg\hb30
   set HG_MINGW=c:\oohg\hb30\comp\mingw
   set LIB_GUI=lib
   set LIB_HRB=lib
   set BIN_HRB=bin
   shift

:COMPILE

   rem *** Call Compiler Specific Batch File ***
   set HG_CCOMP=%HG_MINGW%
   call %HG_ROOT%\BuildApp_hbmk2.bat %*
