@echo off
rem
rem $Id: makelib.bat,v 1.40 2015-03-18 01:22:30 fyurisich Exp $
rem

:MAKELIB

   cls
   if not exist makelib.bat goto :SYNTAX
   if /I "%1"=="HB30" (
      call :MAKELIB_30 %*
      ) else if /I "%1"=="HB32" (
         call :MAKELIB_32 %* ) else if /I "%1"=="XB" (
            call :MAKELIB_XB %* ) else (
               goto :SYNTAX )
   goto :END

:SYNTAX

   echo Syntax: (folder with makelib.bat)
   echo makelib HB30 [options]   (Harbour 3.0 + mingw)
   echo makelib HB32 [options]   (Harbour 3.2 + mingw)
   echo makelib XB [options]     (XHarbour + bcc)
   echo.
   echo %0
   goto :END

:MAKELIB_XB

   shift /1
   if /I "%1"=="/C" call :CLEAN_PATH
   if /I "%1"=="/C" shift /1
   if "%HG_ROOT%"=="" set HG_ROOT=c:\oohg
   if "%HG_HRB%"==""  set HG_HRB=c:\oohg\xhbcc
   if "%HG_BCC%"==""  set HG_BCC=c:\Borland\BCC55
   if "%LIB_GUI%"=="" set LIB_GUI=lib\xhb\bcc
   if "%LIB_HRB%"=="" set LIB_HRB=lib
   if "%BIN_HRB%"=="" set BIN_HRB=bin
   call makelib_bcc.bat
   goto :END

:MAKELIB_30

   shift /1
   if /I "%1"=="/C" call :CLEAN_PATH
   if /I "%1"=="/C" shift /1
   if "%HG_ROOT%"==""  set HG_ROOT=c:\oohg
   if "%HG_HRB%"==""   set HG_HRB=c:\oohg\hb30
   if "%HG_MINGW%"=="" set HG_MINGW=c:\oohg\hb30\comp\mingw
   if "%LIB_GUI%"==""  set LIB_GUI=lib
   if "%LIB_HRB%"==""  set LIB_HRB=lib
   if "%BIN_HRB%"==""  set BIN_HRB=bin
   call makelib_mingw.bat
   goto :END

:MAKELIB_32

   shift /1
   if /I "%1"=="/C" call :CLEAN_PATH
   if /I "%1"=="/C" shift /1
   if "%HG_ROOT%"==""  set HG_ROOT=c:\oohg
   if "%HG_HRB%"==""   set HG_HRB=c:\oohg\hb32
   if "%HG_MINGW%"=="" set HG_MINGW=c:\oohg\hb32\comp\mingw
   if "%LIB_GUI%"==""  set LIB_GUI=lib\hb\mingw
   if "%LIB_HRB%"==""  set LIB_HRB=lib\win\mingw
   if "%BIN_HRB%"==""  set BIN_HRB=bin
   call makelib_mingw.bat
   goto :END

:CLEAN_PATH

   set HG_ROOT=
   set HG_HRB=
   set HG_MINGW=
   set LIB_GUI=
   set LIB_HRB=
   set BIN_HRB=
   goto :END

:END
