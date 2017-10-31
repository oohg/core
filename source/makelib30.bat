@echo off
rem
rem $Id: makelib30.bat,v 1.1 2015-03-13 23:04:04 fyurisich Exp $
rem

:MAKELIB_30

   cls

   rem *** Set Paths ***
   if "%1"=="/C" goto :CLEAN_PATH_30
   if "%1"=="/c" goto :CLEAN_PATH_30
   if "%HG_ROOT%"==""  set HG_ROOT=c:\oohg
   if "%HG_HRB%"==""   set HG_HRB=c:\oohg\hb30
   if "%HG_MINGW%"=="" set HG_MINGW=c:\oohg\hb30\comp\mingw
   if "%LIB_GUI%"==""  set LIB_GUI=lib
   if "%LIB_HRB%"==""  set LIB_HRB=lib
   if "%BIN_HRB%"==""  set BIN_HRB=bin
   goto :BUILD_30

:CLEAN_PATH_30

   set HG_ROOT=c:\oohg
   set HG_HRB=c:\oohg\hb30
   set HG_MINGW=c:\oohg\hb30\comp\mingw
   set LIB_GUI=lib
   set LIB_HRB=lib
   set BIN_HRB=bin
   shift

:BUILD_30

   call makelib_mingw.bat
