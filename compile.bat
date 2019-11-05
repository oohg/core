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
   set HG_ADDLIBS=
   set HG_FLAVOR=

:ROOT

   if not "%HG_ROOT%" == "" goto TEST
   set HG_ROOT=%HG_START_DP_COMPILE_BAT%

:TEST

   if /I "%1" == "HM30" goto TEST_HM30
   if /I "%1" == "HM32" goto TEST_HM32
   if /I "%1" == "HM34" goto TEST_HM34
   if /I "%1" == "XB55" goto TEST_XB
   if /I "%1" == "XB58" goto TEST_XB
   if /I "%1" == "XM"   goto TEST_XM

:DETECT_HM30

   if not exist "%HG_ROOT%\compile30.bat" goto DETECT_HM32
   if exist "%HG_ROOT%\compile32.bat" goto SYNTAX
   if exist "%HG_ROOT%\compile34.bat" goto SYNTAX
   if exist "%HG_ROOT%\compileXB.bat" goto SYNTAX
   if exist "%HG_ROOT%\compileXM.bat" goto SYNTAX
   goto COMPILE_HM30

:DETECT_HM32

   if not exist "%HG_ROOT%\compile32.bat" goto DETECT_HM34
   if exist "%HG_ROOT%\compile34.bat" goto SYNTAX
   if exist "%HG_ROOT%\compileXB.bat" goto SYNTAX
   if exist "%HG_ROOT%\compileXM.bat" goto SYNTAX
   goto COMPILE_HM32

:DETECT_HM34

   if not exist "%HG_ROOT%\compile34.bat" goto DETECT_XB
   if exist "%HG_ROOT%\compileXB.bat" goto SYNTAX
   if exist "%HG_ROOT%\compileXM.bat" goto SYNTAX
   goto COMPILE_HM34

:DETECT_XB

   if not exist "%HG_ROOT%\compileXB.bat" goto DETECT_XM
   if exist "%HG_ROOT%\compileXM.bat" goto SYNTAX
   goto COMPILE_XB

:DETECT_XM

   if exist "%HG_ROOT%\compileXM.bat" goto COMPILE_XM
   echo File %HG_ROOT%\compile30.bat not found !!!
   echo File %HG_ROOT%\compile32.bat not found !!!
   echo File %HG_ROOT%\compile34.bat not found !!!
   echo File %HG_ROOT%\compileXB.bat not found !!!
   echo File %HG_ROOT%\compileXM.bat not found !!!
   echo.
   goto END

:SYNTAX

   echo Syntax:
   echo    To build with Harbour 3.0 and MinGW
   echo       compile [/C] HM30 file [options]
   echo   To build with Harbour 3.2 and MinGW
   echo       compile [/C] HM32 file [options]
   echo   To build with Harbour 3.4 and MinGW
   echo       compile [/C] HM34 file [options]
   echo   To build with xHarbour and BCC 5.5.1
   echo       compile [/C] XB55 file [options]
   echo   To build with xHarbour and BCC 5.8.2
   echo       compile [/C] XB58 file [options]
   echo   To build with xHarbour and MinGW
   echo       compile [/C] XM file [options]
   echo.
   goto END

:TEST_HM30

   shift
   if exist "%HG_ROOT%\compile30.bat" goto COMPILE_HM30
   echo File compile30.bat not found !!!
   echo.
   goto END

:TEST_HM32

   shift
   if exist "%HG_ROOT%\compile32.bat" goto COMPILE_HM32
   echo File compile32.bat not found !!!
   echo.
   goto END

:TEST_HM34

   shift
   if exist "%HG_ROOT%\compile34.bat" goto COMPILE_HM34
   echo File compile34.bat not found !!!
   echo.
   goto END

:TEST_XB

   shift
   if exist "%HG_ROOT%\compileXB.bat" goto COMPILE_XB
   echo File compileXB.bat not found !!!
   echo.
   goto END

:TEST_XM

   shift
   if exist "%HG_ROOT%\compileXM.bat" goto COMPILE_XM
   echo File compileXM.bat not found !!!
   echo.
   goto END

:COMPILE_HM30

   if "%HG_HRB%"     == "" set HG_HRB=%HG_ROOT%\hb30
   if "%HG_MINGW%"   == "" set HG_MINGW=%HG_CCOMP%
   if "%HG_MINGW%"   == "" set HG_MINGW=%HG_HRB%\comp\mingw
   set HG_CCOMP=%HG_MINGW%
   if "%LIB_GUI%"    == "" set LIB_GUI=lib
   if "%LIB_HRB%"    == "" set LIB_HRB=lib
   if "%BIN_HRB%"    == "" set BIN_HRB=bin
   if "%HG_RC%"      == "" set HG_RC=%HG_ROOT%\resources\oohg_hb30.o
   if "%HG_ADDLIBS%" == "" set HG_ADDLIBS=-lhbpcre -lhbhpdf -llibhpdf -lhbuddall -lrddads
   set HG_FLAVOR=HARBOUR
   call "%HG_ROOT%\compile_mingw.bat" %1 %2 %3 %4 %5 %6 %7 %8 %9
   goto END

:COMPILE_HM32

   if "%HG_HRB%"     == "" set HG_HRB=%HG_ROOT%\hb32
   if "%HG_MINGW%"   == "" set HG_MINGW=%HG_CCOMP%
   if "%HG_MINGW%"   == "" set HG_MINGW=%HG_HRB%\comp\mingw
   set HG_CCOMP=%HG_MINGW%
   if "%LIB_GUI%"    == "" set LIB_GUI=lib\hb\mingw
   if "%LIB_HRB%"    == "" set LIB_HRB=lib\win\mingw
   if "%BIN_HRB%"    == "" set BIN_HRB=bin
   if "%HG_RC%"      == "" set HG_RC=%HG_ROOT%\resources\oohg_hb32.o
   if "%HG_ADDLIBS%" == "" set HG_ADDLIBS=-lhbpcre -lhbhpdf -llibhpdf -lhbuddall -lrddads
   set HG_FLAVOR=HARBOUR
   call "%HG_ROOT%\compile_mingw.bat" %1 %2 %3 %4 %5 %6 %7 %8 %9
   goto END

:COMPILE_HM34

   if "%HG_HRB%"     == "" set HG_HRB=%HG_ROOT%\hb34
   if "%HG_MINGW%"   == "" set HG_MINGW=%HG_CCOMP%
   if "%HG_MINGW%"   == "" set HG_MINGW=%HG_HRB%\comp\mingw
   set HG_CCOMP=%HG_MINGW%
   if "%LIB_GUI%"    == "" set LIB_GUI=lib\hb34\mingw
   if "%LIB_HRB%"    == "" set LIB_HRB=lib\win\clang
   if "%BIN_HRB%"    == "" set BIN_HRB=bin
   if "%HG_RC%"      == "" set HG_RC=%HG_ROOT%\resources\oohg_hb34.o
   if "%HG_ADDLIBS%" == "" set HG_ADDLIBS=-lhbpcre2 -lhpdf -lhbhpdf
   set HG_FLAVOR=HARBOUR
   call "%HG_ROOT%\compile_mingw.bat" %1 %2 %3 %4 %5 %6 %7 %8 %9
   goto END

:COMPILE_XB

   if "%HG_HRB%"   == "" set HG_HRB=%HG_ROOT%\xhbcc
   if "%HG_BCC%"   == "" set HG_BCC=%HG_CCOMP%
   if "%HG_BCC%"   == "" if /I "%1" == "XB58" set HG_BCC=c:\Borland\BCC58
   if "%HG_BCC%"   == "" set HG_BCC=c:\Borland\BCC55
   set HG_CCOMP=%HG_BCC%
   if "%LIB_GUI%"  == "" set LIB_GUI=lib\xhb\bcc
   if "%LIB_HRB%"  == "" set LIB_HRB=lib
   if "%BIN_HRB%"  == "" set BIN_HRB=bin
   if "%HG_RC%"    == "" set HG_RC=%HG_ROOT%\resources\oohg.res
   if "%HG_ADDLIBS%" == "" set HG_ADDLIBS=pcrepos hbhpdf libharu
   set HG_FLAVOR=XHARBOUR
   call "%HG_ROOT%\compile_bcc.bat" %1 %2 %3 %4 %5 %6 %7 %8 %9
   goto END

:COMPILE_XM

   if "%HG_HRB%"   == "" set HG_HRB=%HG_ROOT%\xhmingw
   if "%HG_MINGW%" == "" set HG_MINGW=%HG_CCOMP%
   if "%HG_MINGW%" == "" set HG_MINGW=%HG_HRB%\comp\mingw
   set HG_CCOMP=%HG_MINGW%
   if "%LIB_GUI%"  == "" set LIB_GUI=lib\xhb\mingw
   if "%LIB_HRB%"  == "" set LIB_HRB=lib
   if "%BIN_HRB%"  == "" set BIN_HRB=bin
   if "%HG_RC%"    == "" set HG_RC=%HG_ROOT%\resources\oohg.res
   if "%HG_ADDLIBS%" == "" set HG_ADDLIBS=-lpcrepos -lhbhpdf -llibharu
   set HG_FLAVOR=XHARBOUR
   call "%HG_ROOT%\compile_mingw.bat" %1 %2 %3 %4 %5 %6 %7 %8 %9
   goto END

:END

   set HG_START_DP_COMPILE_BAT=
