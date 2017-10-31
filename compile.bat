@echo off
rem
rem $Id: compile.bat,v 1.22 2015-03-18 01:22:29 fyurisich Exp $
rem

:MAIN

   cls
   if /I "%1"=="/C" set HG_ROOT=c:\oohg
   if /I "%1"=="/C" set HB_CLEAN=/C
   if /I "%1"=="/C" shift
   if not exist compile.bat goto :SYNTAX

   if /I "%1"=="HB30" (
      call ::COMPILE30 %HG_CLEAN% %1 %2 %3 %4 %5 %6 %7 %8 %9 ) ^
   else if /I "%1"=="HB32" (
      call ::COMPILE32 %HG_CLEAN% %1 %2 %3 %4 %5 %6 %7 %8 %9 ) ^
   else if /I "%1"=="XB"   (
      call ::COMPILEXB %HG_CLEAN% %1 %2 %3 %4 %5 %6 %7 %8 %9 ) ^
   else (
      goto :SYNTAX )
   set HG_CLEAN=
   goto :END

:SYNTAX

   echo.
   echo Syntax to build (from compile.bat folder):
   echo.
   echo compile [/C] HB30 file [options]  (Harbour 3.0 + Mingw)
   echo compile [/C] HB32 file [options]  (Harbour 3.2 + Mingw)
   echo compile [/C] XB   file [options]  (XHarbour + Bcc)
   echo.
   goto :END

:COMPILE30

   shift
   if /I "%1"=="/C" call :CLEAR_ALL
   if /I "%1"=="/C" shift
   if "%HG_ROOT%"==""  set HG_ROOT=c:\oohg
   if "%HG_HRB%"==""   set HG_HRB=c:\oohg\hb30
   if "%HG_MINGW%"=="" set HG_MINGW=c:\oohg\hb30\comp\mingw
   if "%LIB_GUI%"==""  set LIB_GUI=lib
   if "%LIB_HRB%"==""  set LIB_HRB=lib
   if "%BIN_HRB%"==""  set BIN_HRB=bin
   set HG_RC=%HG_ROOT%\resources\oohg_hb30.o
   call %HG_ROOT%\compile_mingw.bat %1 %2 %3 %4 %5 %6 %7 %8 %9
   goto :END

:COMPILE32

   shift
   if /I "%1"=="/C" call :CLEAR_ALL
   if /I "%1"=="/C" shift
   if "%HG_ROOT%"==""  set HG_ROOT=c:\oohg
   if "%HG_HRB%"==""   set HG_HRB=c:\oohg\hb32
   if "%HG_MINGW%"=="" set HG_MINGW=c:\oohg\hb32\comp\mingw
   if "%LIB_GUI%"==""  set LIB_GUI=lib\hb\mingw
   if "%LIB_HRB%"==""  set LIB_HRB=lib\win\mingw
   if "%BIN_HRB%"==""  set BIN_HRB=bin
   set HG_RC=%HG_ROOT%\resources\oohg_hb32.o
   call %HG_ROOT%\compile_mingw.bat %1 %2 %3 %4 %5 %6 %7 %8 %9
   goto :END

:COMPILEXB

   shift
   if /I "%1"=="/C" call :CLEAR_ALL
   if /I "%1"=="/C" shift
   if "%HG_ROOT%"==""  set HG_ROOT=c:\oohg
   if "%HG_HRB%"==""   set HG_HRB=c:\oohg\xhbcc
   if "%HG_BCC%"==""   set HG_BCC=c:\Borland\BCC55
   if "%HG_MINGW%"=="" set HG_MINGW=c:\Borland\BCC55
   if "%LIB_GUI%"==""  set LIB_GUI=lib\xhb\bcc
   if "%LIB_HRB%"==""  set LIB_HRB=lib
   if "%BIN_HRB%"==""  set BIN_HRB=bin
   call %HG_ROOT%\compile_bcc.bat %1 %2 %3 %4 %5 %6 %7 %8 %9
   goto :END

:CLEAR_ALL

   set HG_ROOT=
   set HG_HRB=
   set HG_MINGW=
   set HG_BCC=
   set LIB_GUI=
   set LIB_HRB=
   set BIN_HRB=
   goto :END

:END
