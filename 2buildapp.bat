@echo off
rem
rem $Id: 2buildapp.bat,v 1.3 2015-03-12 00:58:16 fyurisich Exp $
rem
cls

rem *** Set Paths ***
set HG_ROOT=c:\oohg
set HG_HRB=c:\oohg\hb32
set HG_CCOMP=c:\oohg\comp\mingw

call %HG_ROOT%\buildapp.bat %*

