@echo off
rem
rem $Id: mymakelib.bat,v 1.2 2015-03-09 22:29:21 fyurisich Exp $
rem
cls

rem *** Set Paths ***
set HG_ROOT=c:\oohg
set HG_HRB=C:\hb32
set HG_MINGW=c:\hb32\comp\mingw
set LIB_GUI=lib\hb\mingw
set LIB_HRB=lib\win\mingw
set BIN_HRB=bin

call BuildLib.bat %1 %2 %3 %4 %5 %6 %7 %8 %9
