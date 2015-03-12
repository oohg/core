@echo off
rem
rem $Id: buildapp.bat,v 1.12 2015-03-12 00:58:16 fyurisich Exp $
rem

REM *** Check for .prg ***
if "%1"=="" goto EXIT
if exist %1.prg goto CONTINUE
if not exist %1.hbp goto ERREXIT1

:CONTINUE

rem *** Delete Old Executable and Log ***
if exist %1.exe     del %1.exe
if exist %1.exe     goto ERREXIT2
if exist output.log del output.log

rem *** Set Paths ***
if "%HG_ROOT%"==""  set HG_ROOT=c:\oohg
if "%HG_HRB%"==""   set HG_HRB=c:\oohg\harbour
if "%HG_CCOMP%"=="" set HG_CCOMP=c:\oohg\mingw

rem *** To Build with Nightly Harbour ***
rem set HG_HRB=c:\hb32
rem *** For 32 bits MinGW ***
rem set HG_CCOMP=c:\hb32\comp\mingw
rem *** For 64 bits MinGW ***
rem set HG_CCOMP=c:\hb32\comp\mingw64

rem *** Set EnvVars ***
if "%LIB_GUI%"=="" set LIB_GUI=lib
if "%LIB_HRB%"=="" set LIB_HRB=lib
if "%BIN_HRB%"=="" set BIN_HRB=bin

rem *** To Build with Nightly Harbour ***
rem *** For 32 bits MinGW ***
rem set LIB_GUI=lib\hb\mingw
rem set LIB_HRB=lib\win\mingw
rem set BIN_HRB=bin or bin\win\mingw
rem *** For 64 bits MinGW ***
rem set LIB_GUI=lib\hb\mingw64
rem set LIB_HRB=lib\win\mingw64
rem set BIN_HRB=bin or bin\win\mingw64

rem *** Parse Switches ***
set TFILE=%1
set NO_LOG=NO
set RUNEXE=-run
set EXTRA=
:LOOP_START
if "%2"==""    goto LOOP_END
if "%2"=="/sl" goto SUPPRESS_LOG
if "%2"=="/sL" goto SUPPRESS_LOG
if "%2"=="/Sl" goto SUPPRESS_LOG
if "%2"=="/SL" goto SUPPRESS_LOG
if "%2"=="-sl" goto SUPPRESS_LOG
if "%2"=="-sL" goto SUPPRESS_LOG
if "%2"=="-Sl" goto SUPPRESS_LOG
if "%2"=="-SL" goto SUPPRESS_LOG
if "%2"=="-nr" goto SUPPRESS_RUN
if "%2"=="-nR" goto SUPPRESS_RUN
if "%2"=="-Nr" goto SUPPRESS_RUN
if "%2"=="-NR" goto SUPPRESS_RUN
if "%2"=="/nr" goto SUPPRESS_RUN
if "%2"=="/nR" goto SUPPRESS_RUN
if "%2"=="/Nr" goto SUPPRESS_RUN
if "%2"=="/NR" goto SUPPRESS_RUN
set EXTRA=%EXTRA% %2
shift
goto LOOP_START
:SUPPRESS_LOG
set NO_LOG=YES
shift
goto LOOP_START
:SUPPRESS_RUN
set RUNEXE=-norun
shift
goto LOOP_START
:LOOP_END

rem *** Set PATH ***
set TPATH=%PATH%
set PATH=%HG_CCOMP%\bin;%HG_HRB%\%BIN_HRB%

rem *** Process Resource File ***
echo Compiling %TFILE% ...
echo #define oohgpath %HG_ROOT%\RESOURCES > _oohg_resconfig.h
copy /b %HG_ROOT%\resources\oohg.rc+%TFILE%.rc _temp.rc > nul
windres -i _temp.rc -o _temp.o

rem *** Compile and Link ***
if "%NO_LOG%"=="YES" hbmk2 %TFILE% %EXTRA% %HG_ROOT%\oohg.hbc %RUNEXE%
if not "%NO_LOG%"=="YES" hbmk2 %TFILE% %EXTRA% %HG_ROOT%\oohg.hbc >> output.log 2>&1 %RUNEXE% -prgflag=-q
if exist output.log type output.log

rem *** Cleanup ***
if exist _oohg_resconfig.h del _oohg_resconfig.h
if exist _temp.* del _temp.*
set PATH=%TPATH%
set TPATH=
goto EXIT

:ERREXIT1
echo FILE %TFILE%.prg OR %TFILE%.hbp NOT FOUND !!!
goto EXIT

:ERREXIT2
echo COMPILE ERROR: IS %TFILE%.EXE RUNNING ?

:EXIT
