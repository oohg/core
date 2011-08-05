@echo off
rem
rem $Id: CompileRes.bat,v 1.4 2011-08-05 19:23:58 fyurisich Exp $
rem

cls

echo Compiling oohg.res ...
if exist oohg.res del oohg.res
if exist oohg.res goto ERROR1
if "%HG_BCC%"=="" set HG_BCC=c:\borland\bcc55
%HG_BCC%\bin\brc32 -r -fooohg.res oohg_bcc.rc
if exist oohg.res echo Done.
if not exist oohg.res echo Not done.
echo.

echo Compiling oohg.o ...
if exist _oohg_resconfig.h del _oohg_resconfig.h
if exist _oohg_resconfig.h goto ERROR2
if "%ooHG_INSTALL%"=="" set ooHG_INSTALL=c:\oohg
echo #define oohgpath %oohg_INSTALL%\RESOURCES > _oohg_resconfig.h
if not exist _oohg_resconfig.h goto ERROR3
if exist oohg.o del oohg.o
if exist oohg.o goto ERROR4
if "%MINGW%"=="" set MINGW=c:\oohg\mingw
%MINGW%\bin\windres -i ooHG.rc -o ooHG.o
if exist _oohg_resconfig.h del _oohg_resconfig.h
if exist oohg.o echo Done.
if not exist oohg.o echo Not done.
goto EXIT

:ERROR1
echo Can not delete old oohg.res !!!
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
