@echo off
rem   auxiliar batch to organize all batch files
rem
rem   OOHG Variables
rem
rem   HG_ROOT, HG_HRB, HG_BCC, HG_VC, HG_PC, HG_MINGW, LIB_GUI, LIB_HRB, BIN_HRB
rem

:OPTIONS

   if "%1"=="SETUPNONE" goto SETUPNONE
   if "%1"=="SETUPXHB"  goto SETUPXHB
   goto END

:SETUPNONE

   set HG_ROOT=
   set HG_HRB=
   set HG_BCC=
   set LIB_GUI=
   set LIB_HRB=
   set BIN_HRB=
   goto END

:SETUPXHB

   if "%HG_ROOT%"=="" set HG_ROOT=c:\oohg
   if "%HG_HRB%"==""  set HG_HRB=c:\oohg\xhbcc
   if "%HG_BCC%"==""  set HG_BCC=c:\Borland\BCC55
   if "%LIB_GUI%"=="" set LIB_GUI=lib\xhb\bcc
   if "%LIB_HRB%"=="" set LIB_HRB=lib
   if "%BIN_HRB%"=="" set BIN_HRB=bin
   goto END

