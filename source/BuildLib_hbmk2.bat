@echo off
rem
rem $Id: BuildLib_hbmk2.bat,v 1.2 2015-11-07 22:39:57 fyurisich Exp $
rem
rem Build ooHG libraries from official distro
rem
rem Use: BuildLib [f] [hbmk2 options]
rem f parameter redirectes all output to a file named error.log
rem
rem hbmk2 usefull options:
rem -rebuild to force compiling of all sources
rem -trace to see the commands generated by hbmk2
rem -info to see informational messages
cls

rem *** Set Paths ***
if "%HG_ROOT%"==""  set HG_ROOT=c:\oohg
if "%HG_HRB%"==""   set HG_HRB=c:\oohg\harbour
if "%HG_CCOMP%"=="" set HG_CCOMP=c:\oohg\mingw

rem *** To Build with Nightly Harbour ***
rem set HG_HRB=c:\hb32
rem *** For 32 bits MinGW ***
rem set HG_CCOMP=%HG_HRB%\comp\mingw
rem *** For 64 bits MinGW ***
rem set HG_CCOMP=%HG_HRB%\comp\mingw64

rem *** Set EnvVars ***
if "%LIB_GUI%"=="" set LIB_GUI=lib
if "%BIN_HRB%"=="" set BIN_HRB=bin

rem *** To Build with Nightly Harbour ***
rem *** For 32 bits MinGW ***
rem set LIB_GUI=lib\hb\mingw
rem set BIN_HRB=bin or bin\win\mingw
rem *** For 64 bits MinGW ***
rem set LIB_GUI=lib\hb\mingw64
rem set BIN_HRB=bin or bin\win\mingw64

rem *** Set PATH ***
set TPATH=%PATH%
set PATH=%HG_CCOMP%\bin;%HG_HRB%\%BIN_HRB%

rem *** Delete Old Log ***
if exist error.log del error.log

rem *** Check for Log Messages Switch ***
if .%1.==.f. goto FILE
if .%1.==.F. goto FILE

rem For Harbour 3.0 only
rem set HBMK2_WORDIR=-workdir=%HG_ROOT%\%LIB_GUI%\.hbmk
rem For other versions:
rem set HBMK2_WORDIR=
rem See Build30.bat and Build32.bat
rem Warning: different versions must use different folders.

:SCREEN

   rem *** Build Libraries ***
   hbmk2 oohg.hbp      %HBMK2_WORDIR% %1 %2 %3 %4 %5 %6 %7 %8 %9
   hbmk2 miniprint.hbp %HBMK2_WORDIR% %1 %2 %3 %4 %5 %6 %7 %8 %9
   hbmk2 hbprinter.hbp %HBMK2_WORDIR% %1 %2 %3 %4 %5 %6 %7 %8 %9
   hbmk2 bostaurus.hbp %HBMK2_WORDIR% %1 %2 %3 %4 %5 %6 %7 %8 %9
   goto EXIT

:FILE

   rem *** Build Libraries ***
   hbmk2 oohg.hbp      %HBMK2_WORDIR% %2 %3 %4 %5 %6 %7 %8 %9 >> error.log 2>&1
   hbmk2 miniprint.hbp %HBMK2_WORDIR% %2 %3 %4 %5 %6 %7 %8 %9 >> error.log 2>&1
   hbmk2 hbprinter.hbp %HBMK2_WORDIR% %2 %3 %4 %5 %6 %7 %8 %9 >> error.log 2>&1
   hbmk2 bostaurus.hbp %HBMK2_WORDIR% %2 %3 %4 %5 %6 %7 %8 %9 >> error.log 2>&1
   goto EXIT

:EXIT

   rem *** Restore PATH ***
   set PATH=%TPATH%
   set TPATH=
