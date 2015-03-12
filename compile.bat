@echo off
rem
rem $Id: compile.bat,v 1.21 2015-03-12 22:21:57 fyurisich Exp $
rem
cls

:PATH
if /I "%1"=="/C" goto CLEAN_PATH
if "%HG_ROOT%"=="" set HG_ROOT=c:\oohg
set HG_CLEAN=
goto PARAMS

:CLEAN_PATH
set HG_ROOT=c:\oohg
set HG_CLEAN=/C
shift

:PARAMS
if /I "%1"=="HB30" goto CHECK30
if /I "%1"=="HB32" goto CHECK32

:NOVERSION
if exist %HG_ROOT%\compile30.bat goto CONTINUE
if exist %HG_ROOT%\compile32.bat goto HB32
echo File compile30.bat not found !!!
echo File compile32.bat not found !!!
echo.
goto END

:CONTINUE
if not exist %HG_ROOT%\compile32.bat goto HB30
echo Syntax:
echo    To build with Harbour 3.0
echo       compile [/C] HB30 file [options]
echo   To build with Harbour 3.2
echo       compile [/C] HB32 file [options]
echo.
goto END

:CHECK30
shift
if exist %HG_ROOT%\compile30.bat goto HB30
echo File compile30.bat not found !!!
echo.
goto END

:CHECK32
shift
if exist %HG_ROOT%\compile32.bat goto HB32
echo File compile32.bat not found !!!
echo.
goto END

:HB30
call %HG_ROOT%\compile30.bat %HG_CLEAN% %1 %2 %3 %4 %5 %6 %7 %8 %9
goto END

:HB32
call %HG_ROOT%\compile32.bat %HG_CLEAN% %1 %2 %3 %4 %5 %6 %7 %8 %9
goto END

:END
set HG_CLEAN=
