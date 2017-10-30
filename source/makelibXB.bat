@echo off
rem
rem $Id: makelibXB.bat,v 1.2 2015-03-18 23:58:18 fyurisich Exp $
rem

:MAIN

   cls
   rem *** Set Paths ***
   if "%1"=="/C" goto CLEAN_PATH
   if "%1"=="/c" goto CLEAN_PATH
   if "%HG_ROOT%"=="" set HG_ROOT=c:\oohg
   if "%HG_HRB%"==""  set HG_HRB=c:\oohg\xhbcc
   if "%HG_BCC%"==""  set HG_BCC=c:\Borland\BCC55
   if "%LIB_GUI%"=="" set LIB_GUI=lib\xhb\bcc
   if "%LIB_HRB%"=="" set LIB_HRB=lib
   if "%BIN_HRB%"=="" set BIN_HRB=bin
   goto BUILD

:CLEAN_PATH

   set HG_ROOT=c:\oohg
   set HG_HRB=c:\oohg\xhbcc
   set HG_MINGW=c:\Borland\BCC55
   set LIB_GUI=lib\xhb\bcc
   set LIB_HRB=lib
   set BIN_HRB=bin
   shift

:BUILD

   call makelib_bcc.bat
