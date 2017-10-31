@echo off
rem
rem $Id: BuildLib.bat,v 1.9 2015-03-14 01:11:45 fyurisich Exp $
rem

:MAIN

   cls
   if not exist buildlib.bat goto :SYNTAX
   if /I "%1"=="HB30" goto :HB30
   if /I "%1"=="HB32" goto :HB32

:SYNTAX

   echo Syntax:  (from source folder - buildlib.bat)
   echo.
   echo  buildlib HB30 [options]  (Harbour 3.0)
   echo  buildlib HB32 [options]  (Harbour 3.2)
   echo.
   goto :END

:HB30

   call ::HB30MAIN %*
   goto :END

:HB32

   call ::HB32MAIN %*
   goto :END

rem --- build30.bat

:HB30MAIN

   cls

   rem *** Set Paths ***
   if /I "%1"=="/C" call :CLEAN_PATH
   if /I "%1"=="/C" shift /1
   if "%HG_ROOT%"==""  set HG_ROOT=c:\oohg
   if "%HG_HRB%"==""   set HG_HRB=c:\oohg\hb30
   if "%HG_MINGW%"=="" set HG_MINGW=c:\oohg\hb30\comp\mingw
   if "%LIB_GUI%"==""  set LIB_GUI=lib
   if "%LIB_HRB%"==""  set LIB_HRB=lib
   if "%BIN_HRB%"==""  set BIN_HRB=bin
   goto :HB30BUILD

:HB30BUILD

   set HG_CCOMP=%HG_MINGW%
   set HBMK2_WORDIR=-workdir=%HG_ROOT%\%LIB_GUI%\.hbmk
   call BuildLib_hbmk2.bat %1 %2 %3 %4 %5 %6 %7 %8 %9
   set HBMK2_WORDIR=
   goto :END

:CLEAN_PATH

   set HB_ROOT=
   set HG_HRB=
   set HG_MINGW=
   set LIB_GUI=
   set LIB_HRB=
   set BIN_HRB=
   goto :END

rem --- build32.bat

:HB32MAIN

   cls

   rem *** Set Paths ***
   if /I "%1"=="/C" call :CLEAN_PATH
   if /i "%1"=="/C" shift /1
   if "%HG_ROOT%"==""  set HG_ROOT=c:\oohg
   if "%HG_HRB%"==""   set HG_HRB=c:\oohg\hb32
   if "%HG_MINGW%"=="" set HG_MINGW=c:\oohg\hb32\comp\mingw
   if "%LIB_GUI%"==""  set LIB_GUI=lib\hb\mingw
   if "%LIB_HRB%"==""  set LIB_HRB=lib\win\mingw
   if "%BIN_HRB%"==""  set BIN_HRB=bin
   goto :HB32BUILD

:HB32BUILD

   set HG_CCOMP=%HG_MINGW%
   set HBMK2_WORDIR=
   call BuildLib_hbmk2.bat %1 %2 %3 %4 %5 %6 %7 %8 %9
   goto :END

:END
