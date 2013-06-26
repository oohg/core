@echo off
rem
rem $Id: BuildLib.bat,v 1.1 2013-06-26 21:20:58 migsoft Exp $
rem

SET DISCO=%~d1
SET OOHGPATH=%~dp0

REM SET OOHGPATH=c:\oohg

SET HBPATH=%DISCO%\compilers\hb31
SET MINGWPATH=%HBPATH%\comp\mingw

SET PATH=%HBPATH%\bin;%MINGWPATH%\bin;%PATH%

hbmk2 oohg.hbp
hbmk2 miniprint.hbp
hbmk2 hbprinter.hbp