@echo off
rem
rem $Id: compileXB.bat,v 1.2 2015-03-18 23:58:18 fyurisich Exp $
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
   goto COMPILE

:CLEAN_PATH

   set HG_ROOT=c:\oohg
   set HG_HRB=c:\oohg\xhbcc
   set HG_MINGW=c:\Borland\BCC55
   set LIB_GUI=lib\xhb\bcc
   set LIB_HRB=lib
   set BIN_HRB=bin
   shift

:COMPILE

   rem *** Call Compiler Specific Batch File ***
   call %HG_ROOT%\compile_bcc.bat %1 %2 %3 %4 %5 %6 %7 %8 %9
