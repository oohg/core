@echo off
rem
rem $Id: BuildLib30.bat,v 1.1 2015-03-14 01:11:45 fyurisich Exp $
rem

rem --- build30.bat

:HB30MAIN

   cls

   rem *** Set Paths ***
   if "%1"=="/C" goto :HB30CLEAN_PATH
   if "%1"=="/c" goto :HB30CLEAN_PATH
   if "%HG_ROOT%"==""  set HG_ROOT=c:\oohg
   if "%HG_HRB%"==""   set HG_HRB=c:\oohg\hb30
   if "%HG_MINGW%"=="" set HG_MINGW=c:\oohg\hb30\comp\mingw
   if "%LIB_GUI%"==""  set LIB_GUI=lib
   if "%LIB_HRB%"==""  set LIB_HRB=lib
   if "%BIN_HRB%"==""  set BIN_HRB=bin
   goto :HB30BUILD

:HB30CLEAN_PATH

   set HG_ROOT=c:\oohg
   set HG_HRB=c:\oohg\hb30
   set HG_MINGW=c:\oohg\hb30\comp\mingw
   set LIB_GUI=lib
   set LIB_HRB=lib
   set BIN_HRB=bin
   shift

:HB30BUILD

   set HG_CCOMP=%HG_MINGW%
   set HBMK2_WORDIR=-workdir=%HG_ROOT%\%LIB_GUI%\.hbmk
   call BuildLib_hbmk2.bat %1 %2 %3 %4 %5 %6 %7 %8 %9
   set HBMK2_WORDIR=
   goto :END

:END
