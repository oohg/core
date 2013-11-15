@echo off
rem
rem $Id: mymakelib.bat,v 1.1 2013-11-15 19:31:16 migsoft Exp $
rem
cls

rem *** Set Paths ***
set HG_ROOT=c:\oohg
set HG_HRB=c:\hb32
set HG_MINGW=%HG_HRB%\comp\mingw

call BuildLib.bat

