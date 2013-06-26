@echo off
rem
rem $Id: buildapp.bat,v 1.1 2013-06-26 21:19:42 migsoft Exp $
rem

SET DISCO=%~d1
REM SET OOHGPATH=%~dp0

SET OOHGPATH=%DISCO%\oohg

SET HBPATH=%DISCO%\compilers\hb31
SET MINGWPATH=%DISCO%\hb32\comp\mingw

SET PATH=%HBPATH%\bin;%MINGWPATH%\bin;%PATH%

SET OOHGRPATH=%OOHGPATH%

echo #define OOHGRPATH %OOHGRPATH%\RESOURCES > _oohg_resconfig.h

echo ooHG Building ...

COPY /b %OOHGRPATH%\resources\oohg.rc+%1.rc %OOHGRPATH%\resources\_temp.rc >>NUL
windres -i %OOHGRPATH%\resources\_temp.rc -o %OOHGRPATH%\resources\_temp.o

HBMK2 %1 %2 %3 %4 %5 %6 %7 %8 %OOHGPATH%\oohg.hbc -run

del _oohg_resconfig.h
del %OOHGRPATH%\resources\_temp.*
