@echo off
rem
rem $Id: compile32.bat,v 1.3 2017-08-23 00:10:47 fyurisich Exp $
rem

:MAIN

   cls

   rem *** Set Paths ***
   if "%1"=="/C" goto CLEAN_PATH
   if "%1"=="/c" goto CLEAN_PATH
   if "%HG_ROOT%"==""  set HG_ROOT=c:\oohg
   if "%HG_HRB%"==""   set HG_HRB=c:\oohg\hb32
   if "%HG_MINGW%"=="" set HG_MINGW=c:\oohg\hb32\comp\mingw
   if "%LIB_GUI%"==""  set LIB_GUI=lib\hb\mingw
   if "%LIB_HRB%"==""  set LIB_HRB=lib\win\mingw
   if "%BIN_HRB%"==""  set BIN_HRB=bin
   goto COMPILE

:CLEAN_PATH

   set HG_ROOT=c:\oohg
   set HG_HRB=c:\oohg\hb32
   set HG_MINGW=c:\oohg\hb32\comp\mingw
   set LIB_GUI=lib\hb\mingw
   set LIB_HRB=lib\win\mingw
   set BIN_HRB=bin
   shift

:COMPILE

   rem *** Call Compiler Specific Batch File ***
   set HG_RC=%HG_ROOT%\resources\oohg_hb32.o
   call %HG_ROOT%\compile_mingw.bat %1 %2 %3 %4 %5 %6 %7 %8 %9
