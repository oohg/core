@echo off
rem
rem $Id: makelib.bat,v 1.40 2015-03-18 01:22:30 fyurisich Exp $
rem

cls

:PARAMS

   if /I "%1"=="HB32" goto MAKELIB32
   if /I "%1"=="XB"   goto MAKELIBXB
   if /I "%1"=="HB30" goto MAKELIB30

:NOPARAM

   echo Syntax:
   echo    To build with Harbour 3.0 and MinGW
   echo       makelib HB30 [options]
   echo   To build with Harbour 3.2 and MinGW
   echo       makelib HB32 [options]
   echo   To build with xHarbour and BCC
   echo       makelib XB [options]
   echo.
   goto END

:MAKELIB30

   cls
   rem *** Set Paths ***
   if "%2"=="/C" goto CLEAN30
   if "%2"=="/c" goto CLEAN30
   if "%HG_ROOT%"==""  set HG_ROOT=c:\oohg
   if "%HG_HRB%"==""   set HG_HRB=c:\oohg\hb30
   if "%HG_MINGW%"=="" set HG_MINGW=c:\oohg\hb30\comp\mingw
   if "%LIB_GUI%"==""  set LIB_GUI=lib
   if "%LIB_HRB%"==""  set LIB_HRB=lib
   if "%BIN_HRB%"==""  set BIN_HRB=bin
   call makelib_mingw.bat
   goto END

:CLEAN30

   set HG_ROOT=c:\oohg
   set HG_HRB=c:\oohg\hb30
   set HG_MINGW=c:\oohg\hb30\comp\mingw
   set LIB_GUI=lib
   set LIB_HRB=lib
   set BIN_HRB=bin
   goto END

:MAKELIB32

   cls
   rem *** Set Paths ***
   if "%2"=="/C" goto CLEAN32
   if "%2"=="/c" goto CLEAN32
   if "%HG_ROOT%"==""  set HG_ROOT=c:\oohg
   if "%HG_HRB%"==""   set HG_HRB=c:\oohg\hb32
   if "%HG_MINGW%"=="" set HG_MINGW=c:\oohg\hb32\comp\mingw
   if "%LIB_GUI%"==""  set LIB_GUI=lib\hb\mingw
   if "%LIB_HRB%"==""  set LIB_HRB=lib\win\mingw
   if "%BIN_HRB%"==""  set BIN_HRB=bin
   call makelib_mingw.bat
   goto END

:CLEAN32

   set HG_ROOT=c:\oohg
   set HG_HRB=c:\oohg\hb32
   set HG_MINGW=c:\oohg\hb32\comp\mingw
   set LIB_GUI=lib\hb\mingw
   set LIB_HRB=lib\win\mingw
   set BIN_HRB=bin
   goto END

:MAKELIBXB

   cls
   rem *** Set Paths ***
   if "%2"=="/C" goto CLEAN_PATH
   if "%2"=="/c" goto CLEAN_PATH
   if "%HG_ROOT%"=="" set HG_ROOT=c:\oohg
   if "%HG_HRB%"==""  set HG_HRB=c:\oohg\xhbcc
   if "%HG_BCC%"==""  set HG_BCC=c:\Borland\BCC55
   if "%LIB_GUI%"=="" set LIB_GUI=lib\xhb\bcc
   if "%LIB_HRB%"=="" set LIB_HRB=lib
   if "%BIN_HRB%"=="" set BIN_HRB=bin
   call makelib_bcc.bat
   goto END

:CLEANXB

   set HG_ROOT=c:\oohg
   set HG_HRB=c:\oohg\xhbcc
   set HG_MINGW=c:\Borland\BCC55
   set LIB_GUI=lib\xhb\bcc
   set LIB_HRB=lib
   set BIN_HRB=bin
   goto END

:END
