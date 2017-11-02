@echo off
rem
rem $Id: buildapp.bat $
rem

:BUILDAPP

   cls
   if /I "%1"=="/C" call :CLEAN_PATH
   if /I "%1"=="/C" shift

   if "%HG_ROOT%"=="" set HG_ROOT=c:\oohg

   if /I "%1"=="HB30" goto :TEST_HB30
   if /I "%1"=="HB32" goto :TEST_HB32

:DETECT_HB30

   if exist %HG_ROOT%\BuildApp30.bat goto :DETECT_HB32
   if exist %HG_ROOT%\BuildApp32.bat goto :COMPILE_HB32
   echo File %HG_ROOT%\BuildApp30.bat not found !!!
   echo File %HG_ROOT%\BuildApp32.bat not found !!!
   echo.
   goto :END

:DETECT_HB32

   if not exist %HG_ROOT%\BuildApp32.bat goto :COMPILE_HB30
   echo Syntax:
   echo    To build with Harbour 3.0
   echo       buildapp [/C] HB30 file [options]
   echo   To build with Harbour 3.2
   echo       buildapp [/C] HB32 file [options]
   echo.
   goto :END

:TEST_HB30

   shift
   if exist %HG_ROOT%\BuildApp30.bat goto :COMPILE_HB30
   echo File %HG_ROOT%\BuildApp30.bat not found !!!
   echo.
   goto :END

:TEST_HB32

   shift
   if exist %HG_ROOT%\BuildApp32.bat goto :COMPILE_HB32
   echo File %HG_ROOT%\BuildApp32.bat not found !!!
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
   call %HG_ROOT%\BuildApp_hbmk2.bat %1 %2 %3 %4 %5 %6 %7 %8 %9
   goto :END

:COMPILE_HB32

   if "%HG_ROOT%"==""  set HG_ROOT=c:\oohg
   if "%HG_HRB%"==""   set HG_HRB=c:\oohg\hb32
   if "%HG_MINGW%"=="" set HG_MINGW=c:\oohg\hb32\comp\mingw
   if "%LIB_GUI%"==""  set LIB_GUI=lib\hb\mingw
   if "%LIB_HRB%"==""  set LIB_HRB=lib\win\mingw
   if "%BIN_HRB%"==""  set BIN_HRB=bin
   set HG_CCOMP=%HG_MINGW%
   call %HG_ROOT%\BuildApp_hbmk2.bat %1 %2 %3 %4 %5 %6 %7 %8 %9
   goto :END

:CLEAN_PATH

   set HG_ROOT=c:\oohg
   set HG_HRB=
   set HG_MINGW=
   set HG_BCC=
   set LIB_GUI=
   set LIB_HRB=
   set BIN_HRB=
   goto :END

:END
