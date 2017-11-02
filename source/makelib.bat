@echo off
rem
rem $Id: makelib.bat,v 1.40 2015-03-18 01:22:30 fyurisich Exp $
rem

rem todo: not to check makelib30.bat, makelib32.bat, makelibxb.bat

:MAKELIB

   cls
   if /I "%1"=="/C"   call :CLEAN_PATH
   if /I "%1"=="/C"   shift
   if /I "%1"=="HB30" goto :TEST_HB30
   if /I "%1"=="HB32" goto :TEST_HB32
   if /I "%1"=="XB"   goto :TEST_XB

:DETECT_HB30

   if not exist ..\compile30.bat goto :DETECT_HB32
   if exist ..\compile32.bat goto :SYNTAX
   if exist ..\compilexb.bat goto :SYNTAX
   goto :COMPILE_HB30

:DETECT_HB32

   if not exist ..\compile32.bat goto :DETECT_XB
   if exist ..\compilexb.bat goto :SYNTAX
   goto :COMPILE_HB32

:DETECT_XB

   if exist ..\compilexb.bat goto :COMPILE_XB
   echo File ..\compile30.bat not found !!!
   echo File ..zcompile32.bat not found !!!
   echo File ..xcompilexb.bat not found !!!
   echo.
   echo This file must be executed from SOURCE folder !!!
   echo.
   goto :END

:SYNTAX

   echo Syntax:
   echo    To build with Harbour 3.0 and MinGW
   echo       makelib HB30 [options]
   echo   To build with Harbour 3.2 and MinGW
   echo       makelib HB32 [options]
   echo   To build with xHarbour and BCC
   echo       makelib XB [options]
   echo.
   goto :END

:TEST_HB30

   shift
   if exist ..\compile30.bat goto :COMPILE_HB30
   echo File ..\makelib30.bat not found !!!
   echo.
   echo This file must be executed from SOURCE folder !!!
   echo.
   goto :END

:TEST_HB32

   shift
   if exist compile32.bat goto :COMPILE_HB32
   echo File ..\compile32.bat not found !!!
   echo.
   echo This file must be executed from SOURCE folder !!!
   echo.
   goto :END

:TEST_XB

   shift
   if exist compilexb.bat goto :COMPILE_XB
   echo File ..\compilexb.bat not found !!!
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
   call makelib_mingw.bat
   goto :END

:COMPILE_HB32

   if "%HG_ROOT%"==""  set HG_ROOT=c:\oohg
   if "%HG_HRB%"==""   set HG_HRB=c:\oohg\hb32
   if "%HG_MINGW%"=="" set HG_MINGW=c:\oohg\hb32\comp\mingw
   if "%LIB_GUI%"==""  set LIB_GUI=lib\hb\mingw
   if "%LIB_HRB%"==""  set LIB_HRB=lib\win\mingw
   if "%BIN_HRB%"==""  set BIN_HRB=bin
   call makelib_mingw.bat
   goto :END

:COMPILE_XB

   if "%HG_ROOT%"=="" set HG_ROOT=c:\oohg
   if "%HG_HRB%"==""  set HG_HRB=c:\oohg\xhbcc
   if "%HG_BCC%"==""  set HG_BCC=c:\Borland\BCC55
   if "%LIB_GUI%"=="" set LIB_GUI=lib\xhb\bcc
   if "%LIB_HRB%"=="" set LIB_HRB=lib
   if "%BIN_HRB%"=="" set BIN_HRB=bin
   call makelib_bcc.bat
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
