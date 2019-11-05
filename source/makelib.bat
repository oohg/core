@echo off
rem
rem $Id makelib.bat $
rem

:MAKELIB

   cls

   pushd "%~dp0"
   set HG_START_DP_MAKELIB_BAT=%CD%
   popd

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
   pushd "%HG_START_DP_MAKELIB_BAT%\.."
   set HG_ROOT=%CD%
   popd

:TEST

   if /I "%1" == "HM30" goto TEST_HM30
   if /I "%1" == "HM32" goto TEST_HM32
   if /I "%1" == "HM34" goto TEST_HM34
   if /I "%1" == "XB55" goto TEST_XB
   if /I "%1" == "XB58" goto TEST_XB
   if /I "%1" == "XM"   goto TEST_XM

:DETECT_HM30

   if not exist "%HG_START_DP_MAKELIB_BAT%\MakeLib30.bat" goto DETECT_HM32
   if exist "%HG_START_DP_MAKELIB_BAT%\MakeLib32.bat" goto SYNTAX
   if exist "%HG_START_DP_MAKELIB_BAT%\MakeLib34.bat" goto SYNTAX
   if exist "%HG_START_DP_MAKELIB_BAT%\MakeLibXB.bat" goto SYNTAX
   if exist "%HG_START_DP_MAKELIB_BAT%\MakeLibXM.bat" goto SYNTAX
   goto MAKELIB_HM30

:DETECT_HM32

   if not exist "%HG_START_DP_MAKELIB_BAT%\MakeLib32.bat" goto DETECT_HM34
   if exist "%HG_START_DP_MAKELIB_BAT%\MakeLib34.bat" goto SYNTAX
   if exist "%HG_START_DP_MAKELIB_BAT%\MakeLibXB.bat" goto SYNTAX
   if exist "%HG_START_DP_MAKELIB_BAT%\MakeLibXM.bat" goto SYNTAX
   goto MAKELIB_HM32

:DETECT_HM34

   if not exist "%HG_START_DP_MAKELIB_BAT%\MakeLib34.bat" goto DETECT_XB
   if exist "%HG_START_DP_MAKELIB_BAT%\MakeLibXB.bat" goto SYNTAX
   if exist "%HG_START_DP_MAKELIB_BAT%\MakeLibXM.bat" goto SYNTAX
   goto MAKELIB_HM34

:DETECT_XB

   if not exist "%HG_START_DP_MAKELIB_BAT%\MakeLibXB.bat" goto DETECT_XM
   if exist "%HG_START_DP_MAKELIB_BAT%\MakeLibXM.bat" goto SYNTAX
   goto MAKELIB_XB

:DETECT_XM

   if exist "%HG_START_DP_MAKELIB_BAT%\MakeLibXM.bat" goto MAKELIB_XM
   echo File %HG_START_DP_MAKELIB_BAT%\MakeLib30.bat not found !!!
   echo File %HG_START_DP_MAKELIB_BAT%\MakeLib32.bat not found !!!
   echo File %HG_START_DP_MAKELIB_BAT%\MakeLib34.bat not found !!!
   echo File %HG_START_DP_MAKELIB_BAT%\MakeLibXB.bat not found !!!
   echo File %HG_START_DP_MAKELIB_BAT%\MakeLibXM.bat not found !!!
   echo.
   echo This file must be executed from SOURCE folder !!!
   echo.
   goto END

:SYNTAX

   echo Syntax:
   echo    To build with Harbour 3.0 and MinGW
   echo       MakeLib HM30 [options]
   echo   To build with Harbour 3.2 and MinGW
   echo       MakeLib HM32 [options]
   echo   To build with Harbour 3.4 and MinGW
   echo       MakeLib HM34 [options]
   echo   To build with xHarbour and BCC 5.5.1
   echo       MakeLib XB55 [options]
   echo   To build with xHarbour and BCC 5.8.2
   echo       MakeLib XB58 [options]
   echo   To build with xHarbour and MinGW
   echo       MakeLib XM [options]
   echo.
   goto END

:TEST_HM30

   shift
   if exist "%HG_START_DP_MAKELIB_BAT%\MakeLib30.bat" goto MAKELIB_HM30
   echo File %HG_START_DP_MAKELIB_BAT%\MakeLib30.bat not found !!!
   echo.
   echo This file must be executed from SOURCE folder !!!
   echo.
   goto END

:TEST_HM32

   shift
   if exist "%HG_START_DP_MAKELIB_BAT%\MakeLib32.bat" goto MAKELIB_HM32
   echo File %HG_START_DP_MAKELIB_BAT%\MakeLib32.bat not found !!!
   echo.
   echo This file must be executed from SOURCE folder !!!
   echo.
   goto END

:TEST_HM34

   shift
   if exist "%HG_START_DP_MAKELIB_BAT%\MakeLib34.bat" goto MAKELIB_HM34
   echo File %HG_START_DP_MAKELIB_BAT%\MakeLib34.bat not found !!!
   echo.
   echo This file must be executed from SOURCE folder !!!
   echo.
   goto END

:TEST_XB

   shift
   if exist "%HG_START_DP_MAKELIB_BAT%\MakeLibXB.bat" goto MAKELIB_XB
   echo File %HG_START_DP_MAKELIB_BAT%\MakeLibXB.bat not found !!!
   echo.
   echo This file must be executed from SOURCE folder !!!
   echo.
   goto END

:TEST_XM

   shift
   if exist "%HG_START_DP_MAKELIB_BAT%\MakeLibXM.bat" goto MAKELIB_XM
   echo File %HG_START_DP_MAKELIB_BAT%\MakeLibXM.bat not found !!!
   echo.
   echo This file must be executed from SOURCE folder !!!
   echo.
   goto END

:MAKELIB_HM30

   if "%HG_HRB%"   == "" set HG_HRB=%HG_ROOT%\hb30
   if "%HG_MINGW%" == "" set HG_MINGW=%HG_CCOMP%
   if "%HG_MINGW%" == "" set HG_MINGW=%HG_HRB%\comp\mingw
   set HG_CCOMP=%HG_MINGW%
   if "%LIB_GUI%"  == "" set LIB_GUI=lib
   if "%LIB_HRB%"  == "" set LIB_HRB=lib
   if "%BIN_HRB%"  == "" set BIN_HRB=bin
   call "%HG_START_DP_MAKELIB_BAT%\MakeLib_mingw.bat"
   goto END

:MAKELIB_HM32

   if "%HG_HRB%"   == "" set HG_HRB=%HG_ROOT%\hb32
   if "%HG_MINGW%" == "" set HG_MINGW=%HG_CCOMP%
   if "%HG_MINGW%" == "" set HG_MINGW=%HG_HRB%\comp\mingw
   set HG_CCOMP=%HG_MINGW%
   if "%LIB_GUI%"  == "" set LIB_GUI=lib\hb\mingw
   if "%LIB_HRB%"  == "" set LIB_HRB=lib\win\mingw
   if "%BIN_HRB%"  == "" set BIN_HRB=bin
   call "%HG_START_DP_MAKELIB_BAT%\MakeLib_mingw.bat"
   goto END

:MAKELIB_HM34

   if "%HG_HRB%"   == "" set HG_HRB=%HG_ROOT%\hb34
   if "%HG_MINGW%" == "" set HG_MINGW=%HG_CCOMP%
   if "%HG_MINGW%" == "" set HG_MINGW=%HG_HRB%\comp\mingw
   set HG_CCOMP=%HG_MINGW%
   if "%LIB_GUI%"  == "" set LIB_GUI=lib\hb34\mingw
   if "%LIB_HRB%"  == "" set LIB_HRB=lib\win\clang
   if "%BIN_HRB%"  == "" set BIN_HRB=bin
   call "%HG_START_DP_MAKELIB_BAT%\MakeLib_mingw.bat"
   goto END

:MAKELIB_XB

   if "%HG_HRB%"   == "" set HG_HRB=%HG_ROOT%\xhbcc
   if "%HG_BCC%"   == "" set HG_BCC=%HG_CCOMP%
   if "%HG_BCC%"   == "" if /I "%1" == "XB58" set HG_BCC=c:\Borland\BCC58
   if "%HG_BCC%"   == "" set HG_BCC=c:\Borland\BCC55
   set HG_CCOMP=%HG_BCC%
   if "%LIB_GUI%"  == "" set LIB_GUI=lib\xhb\bcc
   if "%LIB_HRB%"  == "" set LIB_HRB=lib
   if "%BIN_HRB%"  == "" set BIN_HRB=bin
   call "%HG_START_DP_MAKELIB_BAT%\MakeLib_bcc.bat"
   goto END

:MAKELIB_XM

   if "%HG_HRB%"   == "" set HG_HRB=%HG_ROOT%\xhmingw
   if "%HG_MINGW%" == "" set HG_MINGW=%HG_CCOMP%
   if "%HG_MINGW%" == "" set HG_MINGW=%HG_HRB%\comp\mingw
   set HG_CCOMP=%HG_MINGW%
   if "%LIB_GUI%"  == "" set LIB_GUI=lib\xhb\mingw
   if "%LIB_HRB%"  == "" set LIB_HRB=lib
   if "%BIN_HRB%"  == "" set BIN_HRB=bin
   call "%HG_START_DP_MAKELIB_BAT%\MakeLib_mingw.bat"
   goto END

:END

   set HG_START_DP_MAKELIB_BAT=
