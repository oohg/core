@echo off
rem
rem $Id: BuildLib.bat,v 1.9 2015-03-14 01:11:45 fyurisich Exp $
rem

:MAIN

   cls
   if /I "%1"=="HB30" goto :CHECK30
   if /I "%1"=="HB32" goto :CHECK32

:NOVERSION

   if exist buildlib30.bat goto CONTINUE
   if exist buildlib32.bat goto :HB32
   echo File buildlib30.bat not found !!!
   echo File buildlib32.bat not found !!!
   echo.
   echo This file must be executed from SOURCE folder !!!
   echo.
   goto :END

:CONTINUE

   if not exist buildlib.bat goto :HB30
   echo Syntax:
   echo    To build with Harbour 3.0
   echo       buildlib HB30 [options]
   echo   To build with Harbour 3.2
   echo       buildlib HB32 [options]
   echo.
   goto :END

:CHECK30

   shift
   if exist buildlib.bat goto :HB30
   echo File buildlib.bat not found !!!
   echo.
   echo This file must be executed from SOURCE folder !!!
   echo.
   goto :END

:CHECK32

   shift
   if exist buildlib.bat goto :HB32
   echo File buildlib.bat not found !!!
   echo.
   echo This file must be executed from SOURCE folder !!!
   echo.
   goto :END

:HB30

   call ::HB30MAIN %1 %2 %3 %4 %5 %6 %7 %8 %9
   goto :END

:HB32

   call ::HB32MAIN %1 %2 %3 %4 %5 %6 %7 %8 %9
   goto :END

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

rem --- build32.bat

:HB32MAIN

   cls

   rem *** Set Paths ***
   if "%1"=="/C" goto :HB32CLEAN_PATH
   if "%1"=="/c" goto :HB32CLEAN_PATH
   if "%HG_ROOT%"==""  set HG_ROOT=c:\oohg
   if "%HG_HRB%"==""   set HG_HRB=c:\oohg\hb32
   if "%HG_MINGW%"=="" set HG_MINGW=c:\oohg\hb32\comp\mingw
   if "%LIB_GUI%"==""  set LIB_GUI=lib\hb\mingw
   if "%LIB_HRB%"==""  set LIB_HRB=lib\win\mingw
   if "%BIN_HRB%"==""  set BIN_HRB=bin
   goto :HB32BUILD

:HB32CLEAN_PATH

   set HG_ROOT=c:\oohg
   set HG_HRB=c:\oohg\hb32
   set HG_MINGW=c:\oohg\hb32\comp\mingw
   set LIB_GUI=lib\hb\mingw
   set LIB_HRB=lib\win\mingw
   set BIN_HRB=bin
   shift

:HB32BUILD

   set HG_CCOMP=%HG_MINGW%
   set HBMK2_WORDIR=
   call BuildLib_hbmk2.bat %1 %2 %3 %4 %5 %6 %7 %8 %9
   goto :END

:END
