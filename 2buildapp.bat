@echo off
rem
rem $Id: 2buildapp.bat,v 1.1 2013-11-13 18:06:43 migsoft Exp $
rem
cls

rem *** Set Paths ***
set HG_ROOT=c:\oohg
set HG_HRB=c:\hb32
set HG_MINGW=%HG_HRB%\comp\mingw

call %HG_ROOT%\buildapp.bat %*

