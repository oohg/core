@echo off
rem
rem $Id: compile30.bat,v 1.2 2017-08-23 00:10:47 fyurisich Exp $
rem

:MAIN

   cls

   rem *** Set Paths ***
   if "%1"=="/C" goto CLEAN_PATH
   if "%1"=="/c" goto CLEAN_PATH
   if "%HG_ROOT%"==""  set HG_ROOT=c:\oohg
   if "%HG_HRB%"==""   set HG_HRB=c:\oohg\hb30
   if "%HG_MINGW%"=="" set HG_MINGW=c:\oohg\hb30\comp\mingw
   if "%LIB_GUI%"==""  set LIB_GUI=lib
   if "%LIB_HRB%"==""  set LIB_HRB=lib
   if "%BIN_HRB%"==""  set BIN_HRB=bin
   goto COMPILE

:CLEAN_PATH

   set HG_ROOT=c:\oohg
   set HG_HRB=c:\oohg\hb30
   set HG_MINGW=c:\oohg\hb30\comp\mingw
   set LIB_GUI=lib
   set LIB_HRB=lib
   set BIN_HRB=bin
   shift

:COMPILE

   rem *** Call Compiler Specific Batch File ***
   set HG_RC=%HG_ROOT%\resources\oohg_hb30.o
   call %HG_ROOT%\compile_mingw.bat %1 %2 %3 %4 %5 %6 %7 %8 %9
