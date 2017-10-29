@echo off
rem
rem $Id: makelib.bat,v 1.40 2015-03-18 01:22:30 fyurisich Exp $
rem
cls

:PARAMS

   if /I "%1"=="HB30" goto CHECK30
   if /I "%1"=="HB32" goto CHECK32
   if /I "%1"=="XB"   goto CHECKXB

:NOVERSION

   if not exist makelib30.bat goto NOVERSION2
   if exist makelib32.bat goto SYNTAX
   if exist makelibXB.bat goto SYNTAX
   goto HB30

:NOVERSION2

   if not exist makelib32.bat goto NOVERSION3
   if exist makelibXB.bat goto SYNTAX
   goto HB32

:NOVERSION3

   if exist makelibXB.bat goto XB
   echo File makelib30.bat not found !!!
   echo File makelib32.bat not found !!!
   echo File makelibXB.bat not found !!!
   echo.
   echo This file must be executed from SOURCE folder !!!
   echo.
   goto END

:SYNTAX

   echo Syntax:
   echo    To build with Harbour 3.0 and MinGW
   echo       makelib HB30 [options]
   echo   To build with Harbour 3.2 and MinGW
   echo       makelib HB32 [options]
   echo   To build with xHarbour and BCC
   echo       makelib XB [options]
   echo.
   goto END

:CHECK30

   shift
   if exist makelib30.bat goto HB30
   echo File makelib30.bat not found !!!
   echo.
   echo This file must be executed from SOURCE folder !!!
   echo.
   goto END

:CHECK32

   shift
   if exist makelib32.bat goto HB32
   echo File makelib32.bat not found !!!
   echo.
   echo This file must be executed from SOURCE folder !!!
   echo.
   goto END

:CHECKXB

   shift
   if exist makelibXB.bat goto XB
   echo File makelibXB.bat not found !!!
   echo.
   echo This file must be executed from SOURCE folder !!!
   echo.
   goto END

:HB30

   call makelib30.bat %1 %2 %3 %4 %5 %6 %7 %8 %9
   goto END

:HB32

   call makelib32.bat %1 %2 %3 %4 %5 %6 %7 %8 %9
   goto END

:XB

   call makelibXB.bat %1 %2 %3 %4 %5 %6 %7 %8 %9
   goto END

:END
