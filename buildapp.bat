rem @echo off
rem
rem $Id: buildapp.bat,v 1.14 2015-03-12 22:35:09 fyurisich Exp $
rem

:BUILDAPP

   cls
   if /I "%1"=="/c" call :CLEAN_PATH
   if /I "%1"=="/c" shift
   if /I "%1"=="HB30" (
      call :SETUP_HB30 ) ^
   else if /I "%1"=="HB32" (
      call :SETUPHB32 ) ^
   else ( ^
      goto :INVALID )

   shift
   call BUILDAPP_HBMK2 %1 %2 %3 %4 %5 %6 %7 %8 %9
   goto :END

:INVALID

   echo Syntax:
   echo.
   echo buildapp [/C] HB30 file [options]   (Harbour 3.0 + mingw)
   echo buildapp [/C] HB32 file [options]   (Harbour 3.2 + mingw)
   echo.
   goto :END

:CLEAN_PATH

   set HG_ROOT=
   set HG_HRB=
   set HG_MINGW=
   set LIB_GUI=
   set LIB_HRB=
   set BIN_HRB=
   goto :END

:SETUP_HB30

   if "%HG_ROOT%"==""  set HG_ROOT=c:\oohg
   if "%HG_HRB%"==""   set HG_HRB=c:\oohg\hb30
   if "%HG_CCOMP%"=="" set HG_MINGW=c:\oohg\hb30\comp\mingw
   if "%LIB_GUI%"==""  set LIB_GUI=lib
   if "%LIB_HRB%"==""  set LIB_HRB=lib
   if "%BIN_HRB%"==""  set BIN_HRB=bin
   goto :END

:SETUP_HB32

   if "%HG_ROOT%"==""  set HG_ROOT=c:\oohg
   if "%HG_HRB%"==""   set HG_HRB=c:\oohg\hb32
   if "%HG_CCOMP%"=="" set HG_MINGW=c:\oohg\hb32\comp\mingw
   if "%LIB_GUI%"==""  set LIB_GUI=lib\hb\mingw
   if "%LIB_HRB%"==""  set LIB_HRB=lib\win\mingw
   if "%BIN_HRB%"==""  set BIN_HRB=bin
   goto :END

:BUILDAPP_HBMK2

   REM *** Check for .prg ***
   if "%1"=="" goto :EXIT
   if exist %1.prg goto :CONTINUE
   if not exist %1.hbp goto :ERREXIT1

:CONTINUE

   rem *** Delete Old Executable and Log ***
   if exist %1.exe     del %1.exe
   if exist %1.exe     goto :ERREXIT2
   if exist output.log del output.log

   rem *** Set Paths ***
   if "%HG_ROOT%"==""  set HG_ROOT=c:\oohg
   if "%HG_HRB%"==""   set HG_HRB=c:\oohg\hb30
   if "%HG_CCOMP%"=="" set HG_CCOMP=c:\oohg\hb30\comp\mingw

   rem *** To Build with Nightly Harbour ***
   rem set HG_HRB=c:\oohg\hb32
   rem *** For 32 bits MinGW ***
   rem set HG_CCOMP=c:\oohg\hb32\comp\mingw
   rem *** For 64 bits MinGW ***
   rem set HG_CCOMP=c:\oohg\hb3264\comp\mingw

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

   if "%2"==""    goto :LOOP_END
   if "%2"=="/sl" goto :SUPPRESS_LOG
   if "%2"=="/sL" goto :SUPPRESS_LOG
   if "%2"=="/Sl" goto :SUPPRESS_LOG
   if "%2"=="/SL" goto :SUPPRESS_LOG
   if "%2"=="-sl" goto :SUPPRESS_LOG
   if "%2"=="-sL" goto :SUPPRESS_LOG
   if "%2"=="-Sl" goto :SUPPRESS_LOG
   if "%2"=="-SL" goto :SUPPRESS_LOG
   if "%2"=="-nr" goto :SUPPRESS_RUN
   if "%2"=="-nR" goto :SUPPRESS_RUN
   if "%2"=="-Nr" goto :SUPPRESS_RUN
   if "%2"=="-NR" goto :SUPPRESS_RUN
   if "%2"=="/nr" goto :SUPPRESS_RUN
   if "%2"=="/nR" goto :SUPPRESS_RUN
   if "%2"=="/Nr" goto :SUPPRESS_RUN
   if "%2"=="/NR" goto :SUPPRESS_RUN
   set EXTRA=%EXTRA% %2
   shift
   goto :LOOP_START

:SUPPRESS_LOG

   set NO_LOG=YES
   shift
   goto :LOOP_START

:SUPPRESS_RUN

   set RUNEXE=-run-
   shift
   goto :LOOP_START

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
   if "%NO_LOG%"=="YES" hbmk2 %EXTRA% %TFILE% %HG_ROOT%\oohg.hbc %RUNEXE%
   if not "%NO_LOG%"=="YES" hbmk2 %EXTRA% %TFILE% %HG_ROOT%\oohg.hbc >> output.log 2>&1 %RUNEXE% -prgflag=-q0
   if exist output.log type output.log

   rem *** Cleanup ***
   if exist _oohg_resconfig.h del _oohg_resconfig.h
   if exist _temp.* del _temp.*
   set PATH=%TPATH%
   set TPATH=
   goto :END

:ERREXIT1

   echo FILE %TFILE%.prg OR %TFILE%.hbp NOT FOUND !!!
   goto :END

:ERREXIT2

   echo COMPILE ERROR: IS %TFILE%.EXE RUNNING ?

:END

   set HG_CLEAN=
