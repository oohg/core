@echo off
rem
rem $Id: BuildLib.bat $
rem

:BUILDLIB

   cls
   if /I "%1"=="/C"   call :CLEAN_PATH
   if /I "%1"=="/C"   shift
   if /I "%1"=="HB30" goto :TEST_HB30
   if /I "%1"=="HB32" goto :TEST_HB32

:DETECT_HB30

   if exist buildlib30.bat goto :DETECT_HB32
   if exist buildlib32.bat goto :COMPILE_HB32
   echo File buildlib30.bat not found !!!
   echo File buildlib32.bat not found !!!
   echo.
   echo This file must be executed from SOURCE folder !!!
   echo.
   goto :END

:DETECT_HB32

   if not exist buildlib32.bat goto :COMPILE_HB30
   echo Syntax:
   echo    To build with Harbour 3.0
   echo       buildlib HB30 [options]
   echo   To build with Harbour 3.2
   echo       buildlib HB32 [options]
   echo.
   goto :END

:TEST_HB30

   shift
   if exist buildlib30.bat goto :COMPILE_HB30
   echo File buildlib30.bat not found !!!
   echo.
   echo This file must be executed from SOURCE folder !!!
   echo.
   goto :END

:TEST_HB32

   shift
   if exist buildlib32.bat goto :COMPILE_HB32
   echo File buildlib32.bat not found !!!
   echo.
   echo This file must be executed from SOURCE folder !!!
   echo.
   goto :END

:COMPILE_HB30

   if "%HG_ROOT%"==""  set HG_ROOT=c:\oohg
   if "%HG_HRB%"==""   set HG_HRB=c:\oohg\hb30
   if "%HG_MINGW%"=="" set HG_MINGW=c:\oohg\hb30\comp\mingw
   if "%LIB_GUI%"==""  set LIB_GUI=lib
   if "%LIB_HRB%"==""  set LIB_HRB=lib
   if "%BIN_HRB%"==""  set BIN_HRB=bin
   set HG_CCOMP=%HG_MINGW%
   set HBMK2_WORDIR=-workdir=%HG_ROOT%\%LIB_GUI%\.hbmk
   call BuildLib_hbmk2.bat %1 %2 %3 %4 %5 %6 %7 %8 %9
   set HBMK2_WORDIR=
   goto :END

:COMPILE_HB32

   if "%HG_ROOT%"==""  set HG_ROOT=c:\oohg
   if "%HG_HRB%"==""   set HG_HRB=c:\oohg\hb32
   if "%HG_MINGW%"=="" set HG_MINGW=c:\oohg\hb32\comp\mingw
   if "%LIB_GUI%"==""  set LIB_GUI=lib\hb\mingw
   if "%LIB_HRB%"==""  set LIB_HRB=lib\win\mingw
   if "%BIN_HRB%"==""  set BIN_HRB=bin
   set HG_CCOMP=%HG_MINGW%
   set HBMK2_WORDIR=
   call BuildLib_hbmk2.bat %1 %2 %3 %4 %5 %6 %7 %8 %9
   goto :END

:CLEAN_PATH

   set HG_ROOT=c:\oohg
   set HG_HRB=
   set HG_MINGW=
   set HG_BCC=
   set LIB_GUI=
   set LIB_HRB=
   set BIN_HRB=

:END
