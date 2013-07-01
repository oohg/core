@echo off
rem
rem $Id: buildapp.bat,v 1.2 2013-07-01 19:34:25 migsoft Exp $
rem

rem detects current disk
SET DISCO=%~d1

rem detects current path
rem SET OOHGPATH=%~dp0

rem to use default paths ooHG
SET OOHGPATH=c:\oohg
SET HBPATH=%OOHGPATH%\harbour
SET MINGWPATH=%OOHGPATH%\mingw

rem uncomment for use different paths
rem SET OOHGPATH=%DISCO%\oohg
rem SET HBPATH=%DISCO%\hb32
rem SET MINGWPATH=%DISCO%\hb32\comp\mingw

SET PATH=%HBPATH%\bin;%MINGWPATH%\bin;%PATH%

if "%1"=="" goto EXIT

if exist output.log del output.log

echo #define oohgpath %OOHGPATH%\RESOURCES > %OOHGPATH%\RESOURCES\_oohg_resconfig.h

echo ooHG Building ...

COPY /b %OOHGPATH%\resources\oohg.rc+%1.rc %OOHGPATH%\resources\_temp.rc >>NUL
windres -i %OOHGPATH%\resources\_temp.rc -o %OOHGPATH%\resources\_temp.o

HBMK2 %1 %2 %3 %4 %5 %6 %7 %8 %OOHGPATH%\oohg.hbc >> output.log 2>&1 -run

del %OOHGPATH%\resources\_oohg_resconfig.h
del %OOHGPATH%\resources\_temp.*

:EXIT
