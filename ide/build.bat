@echo off
rem
rem $Id: build.bat,v 1.3 2016-06-01 00:50:37 fyurisich Exp $
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
if /I "%1"=="HB30" goto CALL30
if /I "%1"=="HB32" goto CALL32

:NOVERSION
if exist %HG_ROOT%\buildapp30.bat goto CONTINUE
if exist %HG_ROOT%\buildapp32.bat goto CALL32
echo File %HG_ROOT%\buildapp30.bat not found !!!
echo File %HG_ROOT%\buildapp32.bat not found !!!
echo.
goto END

:CONTINUE
if not exist %HG_ROOT%\buildapp32.bat goto CALL30
echo Syntax:
echo    To build with Harbour 3.0
echo       build [/C] HB30
echo   To build with Harbour 3.2
echo       build [/C] HB32
echo.
goto END

rem *** Call Compiler Specific Batch File ***
:CALL30
call %HG_ROOT%\buildapp.bat %HG_CLEAN% HB30 mgide %2 %3
goto END

:CALL32
call %HG_ROOT%\buildapp.bat %HG_CLEAN% HB32 mgide %2 %3
goto END

:END
