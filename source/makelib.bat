@echo off
rem
rem $Id makelib.bat $
rem

:MAKELIB

   cls

   if /I not "%1" == "/C" goto ROOT
   shift
   set HG_ROOT=
   set HG_HRB=
   set HG_MINGW=
   set HG_BCC=
   set HG_CCOMP=
   set LIB_GUI=
   set LIB_HRB=
   set BIN_HRB=

:ROOT

   if not "%HG_ROOT%" == "" goto TEST
   set HG_ROOT=%~dp0..

:TEST

   if /I "%1" == "HB30" goto TEST_HB30
   if /I "%1" == "HB32" goto TEST_HB32
   if /I "%1" == "XB"   goto TEST_XB

:DETECT_HB30

   if not exist "%~dp0.\MakeLib30.bat" goto DETECT_HB32
   if exist "%~dp0.\MakeLib32.bat" goto SYNTAX
   if exist "%~dp0.\MakeLibXB.bat" goto SYNTAX
   goto COMPILE_HB30

:DETECT_HB32

   if not exist "%~dp0.\MakeLib32.bat" goto DETECT_XB
   if exist "%~dp0.\MakeLibXB.bat" goto SYNTAX
   goto COMPILE_HB32

:DETECT_XB

   if exist "%~dp0.\MakeLibXB.bat" goto COMPILE_XB
   echo File %~dp0MakeLib30.bat not found !!!
   echo File %~dp0MakeLib32.bat not found !!!
   echo File %~dp0MakeLibXB.bat not found !!!
   echo.
   echo This file must be executed from SOURCE folder !!!
   echo.
   goto END

:SYNTAX

   echo Syntax:
   echo    To build with Harbour 3.0 and MinGW
   echo       MakeLib HB30 [options]
   echo   To build with Harbour 3.2 and MinGW
   echo       MakeLib HB32 [options]
   echo   To build with xHarbour and BCC
   echo       MakeLib XB [options]
   echo.
   goto END

:TEST_HB30

   shift
   if exist "%~dp0.\MakeLib30.bat" goto COMPILE_HB30
   echo File %~dp0MakeLib30.bat not found !!!
   echo.
   echo This file must be executed from SOURCE folder !!!
   echo.
   goto END

:TEST_HB32

   shift
   if exist "%~dp0.\MakeLib32.bat" goto COMPILE_HB32
   echo File %~dp0MakeLib32.bat not found !!!
   echo.
   echo This file must be executed from SOURCE folder !!!
   echo.
   goto END

:TEST_XB

   shift
   if exist "%~dp0.\MakeLibXB.bat" goto COMPILE_XB
   echo File %~dp0MakeLibXB.bat not found !!!
   echo.
   echo This file must be executed from SOURCE folder !!!
   echo.
   goto END

:COMPILE_HB30

   if "%HG_HRB%   "== "" set HG_HRB=%HG_ROOT%\hb30
   if "%HG_MINGW%" == "" set HG_MINGW=%HG_CCOMP%
   if "%HG_MINGW%" == "" set HG_MINGW=%HG_HRB%\comp\mingw
   if "%HG_CCOMP%" == "" set HG_CCOMP=%HG_MINGW%
   if "%LIB_GUI%"  == "" set LIB_GUI=lib
   if "%LIB_HRB%"  == "" set LIB_HRB=lib
   if "%BIN_HRB%"  == "" set BIN_HRB=bin
   call "%~dp0.\MakeLib_mingw.bat"
   goto END

:COMPILE_HB32

   if "%HG_HRB%"   == "" set HG_HRB=%HG_ROOT%\hb32
   if "%HG_MINGW%" == "" set HG_MINGW=%HG_CCOMP%
   if "%HG_MINGW%" == "" set HG_MINGW=%HG_ROOT%\hb32\comp\mingw
   if "%HG_CCOMP%" == "" set HG_CCOMP=%HG_MINGW%
   if "%LIB_GUI%"  == "" set LIB_GUI=lib\hb\mingw
   if "%LIB_HRB%"  == "" set LIB_HRB=lib\win\mingw
   if "%BIN_HRB%"  == "" set BIN_HRB=bin
   call "%~dp0.\MakeLib_mingw.bat"
   goto END

:COMPILE_XB

   if "%HG_HRB%"   == "" set HG_HRB=%HG_ROOT%\xhbcc
   if "%HG_BCC%"   == "" set HG_BCC=%HG_CCOMP%
   if "%HG_BCC%"   == "" set HG_BCC=c:\Borland\BCC55
   if "%HG_CCOMP%" == "" set HG_CCOMP=%HG_BCC%
   if "%LIB_GUI%"  == "" set LIB_GUI=lib\xhb\bcc
   if "%LIB_HRB%"  == "" set LIB_HRB=lib
   if "%BIN_HRB%"  == "" set BIN_HRB=bin
   call "%~dp0.\MakeLib_bcc.bat"
   goto END

:END
