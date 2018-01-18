@echo off
rem
rem $Id: compile.bat $
rem

:COMPILE

   cls

   pushd "%~dp0"
   set HG_START_DP_COMPILE_BAT=%CD%
   popd

   if /I not "%1" == "/C" goto ROOT
   shift
   set HG_ROOT=
   set HG_HRB=
   set HG_MINGW=
   set HG_BCC=
   set HG_CCOMP=
   set HG_RC=
   set LIB_GUI=
   set LIB_HRB=
   set BIN_HRB=

:ROOT

   if not "%HG_ROOT%" == "" goto TEST
   set HG_ROOT=%HG_START_DP_COMPILE_BAT%

:TEST

   if /I "%1" == "HB30" goto TEST_HB30
   if /I "%1" == "HB32" goto TEST_HB32
   if /I "%1" == "XB"   goto TEST_XB

:DETECT_HB30

   if not exist "%HG_ROOT%\compile30.bat" goto DETECT_HB32
   if exist "%HG_ROOT%\compile32.bat" goto SYNTAX
   if exist "%HG_ROOT%\compileXB.bat" goto SYNTAX
   goto COMPILE_HB30

:DETECT_HB32

   if not exist "%HG_ROOT%\compile32.bat" goto DETECT_XB
   if exist "%HG_ROOT%\compileXB.bat" goto SYNTAX
   goto COMPILE_HB32

:DETECT_XB

   if exist "%HG_ROOT%\compileXB.bat" goto COMPILE_XB
   echo File %HG_ROOT%\compile30.bat not found !!!
   echo File %HG_ROOT%\compile32.bat not found !!!
   echo File %HG_ROOT%\compileXB.bat not found !!!
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

:TEST_HB30

   shift
   if exist "%HG_ROOT%\compile30.bat" goto COMPILE_HB30
   echo File compile30.bat not found !!!
   echo.
   goto END

:TEST_HB32

   shift
   if exist "%HG_ROOT%\compile32.bat" goto COMPILE_HB32
   echo File compile32.bat not found !!!
   echo.
   goto END

:TEST_XB

   shift
   if exist "%HG_ROOT%\compileXB.bat" goto COMPILE_XB
   echo File compileXB.bat not found !!!
   echo.
   goto END

:COMPILE_HB30

   if "%HG_HRB%"   == "" set HG_HRB=%HG_ROOT%\hb30
   if "%HG_MINGW%" == "" set HG_MINGW=%HG_CCOMP%
   if "%HG_MINGW%" == "" set HG_MINGW=%HG_HRB%\comp\mingw
   if "%HG_CCOMP%" == "" set HG_CCOMP=%HG_MINGW%
   if "%LIB_GUI%"  == "" set LIB_GUI=lib
   if "%LIB_HRB%"  == "" set LIB_HRB=lib
   if "%BIN_HRB%"  == "" set BIN_HRB=bin
   if "%HG_RC%"    == "" set HG_RC=%HG_ROOT%\resources\oohg_hb30.o
   call "%HG_ROOT%\compile_mingw.bat" %1 %2 %3 %4 %5 %6 %7 %8 %9
   goto END

:COMPILE_HB32

   if "%HG_HRB%"   == "" set HG_HRB=%HG_ROOT%\hb32
   if "%HG_MINGW%" == "" set HG_MINGW=%HG_CCOMP%
   if "%HG_MINGW%" == "" set HG_MINGW=%HG_HRB%\comp\mingw
   if "%HG_CCOMP%" == "" set HG_CCOMP=%HG_MINGW%
   if "%LIB_GUI%"  == "" set LIB_GUI=lib\hb\mingw
   if "%LIB_HRB%"  == "" set LIB_HRB=lib\win\mingw
   if "%BIN_HRB%"  == "" set BIN_HRB=bin
   if "%HG_RC%"    == "" set HG_RC=%HG_ROOT%\resources\oohg_hb32.o
   call "%HG_ROOT%\compile_mingw.bat" %1 %2 %3 %4 %5 %6 %7 %8 %9
   goto END

:COMPILE_XB

   if "%HG_HRB%"   == "" set HG_HRB=%HG_ROOT%\xhbcc
   if "%HG_BCC%"   == "" set HG_BCC=%HG_CCOMP%
   if "%HG_BCC%"   == "" set HG_BCC=c:\Borland\BCC55
   if "%HG_CCOMP%" == "" set HG_CCOMP=%HG_BCC%
   if "%LIB_GUI%"  == "" set LIB_GUI=lib\xhb\bcc
   if "%LIB_HRB%"  == "" set LIB_HRB=lib
   if "%BIN_HRB%"  == "" set BIN_HRB=bin
   if "%HG_RC%"    == "" set HG_RC=%HG_ROOT%\resources\oohg.res
   call "%HG_ROOT%\compile_bcc.bat" %1 %2 %3 %4 %5 %6 %7 %8 %9
   goto END

:END

   set HG_START_DP_COMPILE_BAT=
