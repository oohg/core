@echo off
rem
rem $Id: compile.bat,v 1.22 2015-03-18 01:22:29 fyurisich Exp $
rem

:COMPILE

   cls
   if not exist compile.bat goto :SYNTAX
   if /I "%1"=="/C" call :CLEAN_ALL
   if /I "%1"=="/C" shift

   if /I "%1"=="HB30" (
      call ::COMPILE_HB30 %1 %2 %3 %4 %5 %6 %7 %8 %9 ) ^
   else if /I "%1"=="HB32" (
      call ::COMPILE_HB32 %1 %2 %3 %4 %5 %6 %7 %8 %9 ) ^
   else if /I "%1"=="XB"   (
      call ::COMPILE_XB %1 %2 %3 %4 %5 %6 %7 %8 %9 ) ^
   else (
      goto :SYNTAX )
   goto :END

:AUTODETECT

   if exist %HRB%\hbmake.exe             call :COMPILE XB
   if exist %HRB%\hbmk2.exe              call :COMPILE HB32
   if exist c:\oohg\hb30\bin\hbmk2.exe   call :COMPILE /C HB30
   if exist c:\oohg\hb32\bin\hbmk2.exe   call :COMPILE /C HB32
   if exist c:\oohg\xhbcc\bin\hbmake.exe call :COMPILE /C XB
   goto :END

:SYNTAX

   echo.
   echo Syntax to build (run inside compile.bat folder):
   echo.
   echo compile [/C] HB30 file [options]  (Harbour 3.0 + Mingw)
   echo compile [/C] HB32 file [options]  (Harbour 3.2 + Mingw)
   echo compile [/C] XB   file [options]  (XHarbour + Bcc)
   echo.
   goto :END

:COMPILE_HB30

   shift
   if "%HG_ROOT%"==""  set HG_ROOT=c:\oohg
   if "%HG_HRB%"==""   set HG_HRB=c:\oohg\hb30
   if "%HG_MINGW%"=="" set HG_MINGW=c:\oohg\hb30\comp\mingw
   if "%LIB_GUI%"==""  set LIB_GUI=lib
   if "%LIB_HRB%"==""  set LIB_HRB=lib
   if "%BIN_HRB%"==""  set BIN_HRB=bin
   set HG_RC=%HG_ROOT%\resources\oohg_hb30.o
   call %HG_ROOT%\compile_mingw.bat %1 %2 %3 %4 %5 %6 %7 %8 %9
   goto :END

:COMPILE_HB32

   shift
   if "%HG_ROOT%"==""  set HG_ROOT=c:\oohg
   if "%HG_HRB%"==""   set HG_HRB=c:\oohg\hb32
   if "%HG_MINGW%"=="" set HG_MINGW=c:\oohg\hb32\comp\mingw
   if "%LIB_GUI%"==""  set LIB_GUI=lib\hb\mingw
   if "%LIB_HRB%"==""  set LIB_HRB=lib\win\mingw
   if "%BIN_HRB%"==""  set BIN_HRB=bin
   set HG_RC=%HG_ROOT%\resources\oohg_hb32.o
   call %HG_ROOT%\compile_mingw.bat %1 %2 %3 %4 %5 %6 %7 %8 %9
   goto :END

:COMPILE_XB

   shift
   if "%HG_ROOT%"==""  set HG_ROOT=c:\oohg
   if "%HG_HRB%"==""   set HG_HRB=c:\oohg\xhbcc
   if "%HG_BCC%"==""   set HG_BCC=c:\Borland\BCC55
   if "%HG_MINGW%"=="" set HG_MINGW=c:\Borland\BCC55
   if "%LIB_GUI%"==""  set LIB_GUI=lib\xhb\bcc
   if "%LIB_HRB%"==""  set LIB_HRB=lib
   if "%BIN_HRB%"==""  set BIN_HRB=bin
   call %HG_ROOT%\compile_bcc.bat %1 %2 %3 %4 %5 %6 %7 %8 %9
   goto :END

:CLEAN_ALL

   set HG_ROOT=
   set HG_HRB=
   set HG_MINGW=
   set HG_BCC=
   set LIB_GUI=
   set LIB_HRB=
   set BIN_HRB=
   goto :END

:END
