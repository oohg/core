@echo off
rem
rem $Id: buildapp.bat,v 1.14 2015-03-12 22:35:09 fyurisich Exp $
rem

:BUILDAPP

   cls
   if /I "%1"=="/C" goto :CLEAN_PATH
   if "%HG_ROOT%"=="" set HG_ROOT=c:\oohg
   set HG_CLEAN=
   goto :PARAMS

:CLEAN_PATH

   set HG_ROOT=c:\oohg
   set HG_CLEAN=/C
   shift

:PARAMS

   if /I "%1"=="HB30" goto :CHECK30
   if /I "%1"=="HB32" goto :CHECK32

:NOVERSION

   if exist %HG_ROOT%\buildapp30.bat goto :CONTINUE
   if exist %HG_ROOT%\buildapp32.bat goto :HB32
   echo File buildapp30.bat not found !!!
   echo File buildapp32.bat not found !!!
   echo.
   goto :END

:CONTINUE

   if not exist %HG_ROOT%\buildapp32.bat goto :HB30
   echo Syntax:
   echo    To build with Harbour 3.0
   echo       buildapp [/C] HB30 file [options]
   echo   To build with Harbour 3.2
   echo       buildapp [/C] HB32 file [options]
   echo.
   goto :END

:CHECK30

   shift
   if exist %HG_ROOT%\buildapp30.bat goto :HB30
   echo File buildapp30.bat not found !!!
   echo.
   goto :END

:CHECK32

   shift
   if exist %HG_ROOT%\buildapp32.bat goto :HB32
   echo File buildapp32.bat not found !!!
   echo.
   goto :END

:HB30

   call %HG_ROOT%\buildapp30.bat %HG_CLEAN% %1 %2 %3 %4 %5 %6 %7 %8 %9
   goto :END

:HB32

   call %HG_ROOT%\buildapp32.bat %HG_CLEAN% %1 %2 %3 %4 %5 %6 %7 %8 %9
   goto :END

:END

   set HG_CLEAN=
