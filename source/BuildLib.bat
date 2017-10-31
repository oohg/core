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
   if exist buildlib32.bat goto HB32
   echo File buildlib30.bat not found !!!
   echo File buildlib32.bat not found !!!
   echo.
   echo This file must be executed from SOURCE folder !!!
   echo.
   goto :END

:CONTINUE

   if not exist buildlib32.bat goto :HB30
   echo Syntax:
   echo    To build with Harbour 3.0
   echo       buildlib HB30 [options]
   echo   To build with Harbour 3.2
   echo       buildlib HB32 [options]
   echo.
   goto :END

:CHECK30

   shift
   if exist buildlib30.bat goto :HB30
   echo File buildlib30.bat not found !!!
   echo.
   echo This file must be executed from SOURCE folder !!!
   echo.
   goto :END

:CHECK32

   shift
   if exist buildlib32.bat goto :HB32
   echo File buildlib32.bat not found !!!
   echo.
   echo This file must be executed from SOURCE folder !!!
   echo.
   goto :END

:HB30

   call buildlib30.bat %1 %2 %3 %4 %5 %6 %7 %8 %9
   goto :END

:HB32

   call buildlib32.bat %1 %2 %3 %4 %5 %6 %7 %8 %9
   goto :END

:END
