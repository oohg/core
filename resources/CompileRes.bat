@echo off
rem
rem $Id: CompileRes.bat,v 1.5 2011-08-05 19:36:31 fyurisich Exp $
rem

cls

:BCC
echo Compiling oohg.res ...
if "%HG_BCC%"=="" set HG_BCC=c:\borland\bcc55
if not exist %HG_BCC%\bin\brc32.exe goto NO_BCC
if exist oohg.res del oohg.res
if exist oohg.res goto ERROR1
%HG_BCC%\bin\brc32 -r -fooohg.res oohg_bcc.rc
if exist oohg.res echo Done.
if not exist oohg.res echo Not done.
echo.
goto MINGW

:NO_BCC
echo BCC not found !!!
echo.
goto MINGW

:MINGW
echo Compiling oohg.o ...
if "%MINGW%"=="" set MINGW=c:\oohg\mingw
if not exist %MINGW%\bin\windres.exe goto NO_MINGW
if exist _oohg_resconfig.h del _oohg_resconfig.h
if exist _oohg_resconfig.h goto ERROR2
if "%ooHG_INSTALL%"=="" set ooHG_INSTALL=c:\oohg
echo #define oohgpath %oohg_INSTALL%\RESOURCES > _oohg_resconfig.h
if not exist _oohg_resconfig.h goto ERROR3
if exist oohg.o del oohg.o
if exist oohg.o goto ERROR4
%MINGW%\bin\windres -i ooHG.rc -o ooHG.o
if exist _oohg_resconfig.h del _oohg_resconfig.h
if exist oohg.o echo Done.
if not exist oohg.o echo Not done.
goto EXIT

:NO_MINGW
echo MINGW not found !!!
echo.
goto EXIT

:ERROR1
echo Can not delete old oohg.res !!!
goto MINGW

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
