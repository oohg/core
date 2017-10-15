@echo off
rem
rem $Id: BuildLib32.bat,v 1.1 2015-03-14 01:11:45 fyurisich Exp $
rem
cls

rem *** Set Paths ***
if "%1"=="/C" goto CLEAN_PATH
if "%1"=="/c" goto CLEAN_PATH
if "%HG_ROOT%"==""  set HG_ROOT=c:\oohg
if "%HG_HRB%"==""   set HG_HRB=c:\oohg\hb32
if "%HG_MINGW%"=="" set HG_MINGW=c:\oohg\hb32\comp\mingw
if "%LIB_GUI%"==""  set LIB_GUI=lib\hb\mingw
if "%LIB_HRB%"==""  set LIB_HRB=lib\win\mingw
if "%BIN_HRB%"==""  set BIN_HRB=bin
goto BUILD

:CLEAN_PATH

   set HG_ROOT=c:\oohg
   set HG_HRB=c:\oohg\hb32
   set HG_MINGW=c:\oohg\hb32\comp\mingw
   set LIB_GUI=lib\hb\mingw
   set LIB_HRB=lib\win\mingw
   set BIN_HRB=bin
   shift

:BUILD

   set HG_CCOMP=%HG_MINGW%
   set HBMK2_WORDIR=
   call BuildLib_hbmk2.bat %*
