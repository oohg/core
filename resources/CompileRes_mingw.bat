@echo off
rem
rem $Id: CompileRes_mingw.bat,v 1.1 2015-03-18 01:22:30 fyurisich Exp $
rem

if /I not "%1%"=="/NOCLS" cls
if /I "%1%"=="/NOCLS" shift

echo Compiling oohg.o ...
if "%HG_MINGW%"=="" set HG_MINGW=c:\oohg\mingw
if not exist %HG_MINGW%\bin\windres.exe goto NO_MINGW
if exist _oohg_resconfig.h del _oohg_resconfig.h
if exist _oohg_resconfig.h goto ERROR2
if "%HG_ROOT%"=="" set HG_ROOT=c:\oohg
echo #define oohgpath %HG_ROOT%\RESOURCES > _oohg_resconfig.h
if not exist _oohg_resconfig.h goto ERROR3
if exist oohg.o del oohg.o
if exist oohg.o goto ERROR4
%HG_MINGW%\bin\windres -i ooHG.rc -o ooHG.o
rem Do not delete _oohg_resconfig.h, QAC/QPM need it
if exist oohg.o echo Done.
if not exist oohg.o echo Not done.
echo.
goto EXIT

:NO_MINGW
echo MINGW not found !!!
echo.
goto EXIT

:ERROR2
echo Can not delete old _oohg_resconfig.h !!!
goto EXIT

:ERROR3
echo Can not create new _oohg_resconfig.h !!!
goto EXIT

:ERROR4
echo Can not delete old oohg.o !!!
goto EXIT

:EXIT
