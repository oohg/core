@echo off
rem
rem $Id: compile.bat,v 1.22 2015-03-18 01:22:29 fyurisich Exp $
rem

:MAIN

   cls
   if /I "%1"=="/C" goto CLEAN_PATH
   if "%HG_ROOT%"=="" set HG_ROOT=c:\oohg
   set HG_CLEAN=
   goto PARAMS

:CLEAN_PATH

   set HG_ROOT=c:\oohg
   set HG_CLEAN=/C
   shift

:PARAMS

   if /I "%1"=="HB30" goto CHECK30
   if /I "%1"=="HB32" goto CHECK32
   if /I "%1"=="XB"   goto CHECKXB

:NOVERSION

   if not exist %HG_ROOT%\compile30.bat goto NOVERSION2
   if exist %HG_ROOT%\compile32.bat goto SYNTAX
   if exist %HG_ROOT%\compileXB.bat goto SYNTAX
   goto HB30

:NOVERSION2

   if not exist %HG_ROOT%\compile32.bat goto NOVERSION3
   if exist %HG_ROOT%\compileXB.bat goto SYNTAX
   goto HB32

:NOVERSION3

   if exist %HG_ROOT%\compileXB.bat goto XB
   echo File compile30.bat not found !!!
   echo File compile32.bat not found !!!
   echo File compileXB.bat not found !!!
   echo.
   goto END

:SYNTAX

   echo Syntax:
   echo    To build with Harbour 3.0 and MinGW
   echo       compile [/C] HB30 file [options]
   echo   To build with Harbour 3.2 and MinGW
   echo       compile [/C] HB32 file [options]
   echo   To build with xHarbour and BCC
   echo       compile [/C] XB file [options]
   echo.
   goto END

:CHECK30

   shift
   if exist %HG_ROOT%\compile30.bat goto HB30
   echo File compile30.bat not found !!!
   echo.
   goto END

:CHECK32

   shift
   if exist %HG_ROOT%\compile32.bat goto HB32
   echo File compile32.bat not found !!!
   echo.
   goto END

:CHECKXB

   shift
   if exist %HG_ROOT%\compileXB.bat goto XB
   echo File compileXB.bat not found !!!
   echo.
   goto END

:HB30

   call %HG_ROOT%\compile30.bat %HG_CLEAN% %1 %2 %3 %4 %5 %6 %7 %8 %9
   goto END

:HB32

   call %HG_ROOT%\compile32.bat %HG_CLEAN% %1 %2 %3 %4 %5 %6 %7 %8 %9
   goto END

:XB

   call %HG_ROOT%\compileXB.bat %HG_CLEAN% %1 %2 %3 %4 %5 %6 %7 %8 %9
   goto END

:END

   set HG_CLEAN=
