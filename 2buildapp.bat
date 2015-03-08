@echo off
rem
rem $Id: 2buildapp.bat,v 1.2 2015-03-08 15:25:34 fyurisich Exp $
rem
cls

rem *** Set Paths ***
set HG_ROOT=c:\oohg
set HG_HRB=%HG_ROOT%\hb32
set HG_CCOMP=%HG_HRB%\comp\mingw

call %HG_ROOT%\buildapp.bat %*

