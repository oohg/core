@echo off
rem
rem $Id: buildapp.bat,v 1.4 2013-08-22 22:25:02 fyurisich Exp $
rem

REM *** Check for .prg ***
if "%1"=="" goto EXIT
if not exist %1.prg goto ERREXIT1

rem *** Delete Old Executable and Log ***
if exist %1.exe     del %1.exe
if exist %1.exe     goto ERREXIT1
if exist output.log del output.log

rem *** Set Paths ***
if "%HG_ROOT%"==""  set HG_ROOT=c:\oohg
if "%HG_HRB%"==""   set HG_HRB=%HG_ROOT%\harbour
if "%HG_MINGW%"=="" set HG_MINGW=%HG_ROOT%\mingw

rem *** To Build with Nightly Harbour ***
rem set HG_HRB=c:\hb32
rem *** For 32 bits MinGW ***
rem set HG_MINGW=%HG_HRB%\comp\mingw
rem *** For 64 bits MinGW ***
rem set HG_MINGW=%HG_HRB%\comp\mingw64

rem *** Set EnvVars ***
if "%LIB_GUI%"=="" set LIB_GUI=lib
if "%LIB_HRB%"=="" set LIB_HRB=lib
if "%BIN_HRB%"=="" set BIN_HRB=bin

rem *** To Build with Nightly Harbour ***
rem *** For 32 bits MinGW ***
rem set LIB_GUI=lib\hb\mingw
rem set LIB_HRB=lib\win\mingw
rem set BIN_HRB=bin\win\mingw
rem *** For 64 bits MinGW ***
rem set LIB_GUI=lib\hb\mingw64
rem set LIB_HRB=lib\win\mingw64
rem set BIN_HRB=bin\win\mingw64

rem *** Set PATH ***
set TPATH=%PATH%
set PATH=%HG_MINGW%\bin;%HG_HRB%\%BIN_HRB%

rem *** Process Resource File ***
echo #define oohgpath %HG_ROOT%\RESOURCES > _oohg_resconfig.h
copy /b %HG_ROOT%\resources\oohg.rc+%1.rc _temp.rc > nul
windres -i _temp.rc -o _temp.o

rem *** Compile and Link ***
hbmk2 %1 %2 %3 %4 %5 %6 %7 %8 %9 %HG_ROOT%\oohg.hbc >> output.log 2>&1 -run

rem *** Cleanup ***
if exist _oohg_resconfig.h del _oohg_resconfig.h
if exist _temp.* del _temp.*
set PATH=%TPATH%
set TPATH=
goto EXIT


:ERREXIT1
echo FILE %1.PRG NOT FOUND !!!

goto EXIT


:ERREXIT2
echo COMPILE ERROR: IS %1.EXE RUNNING ?


:EXIT
