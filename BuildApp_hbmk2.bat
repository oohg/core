@echo off
rem
rem $Id: BuildApp_hbmk2.bat $
rem

:MAIN

   REM *** Check for .prg ***
   if "%1"=="" goto :END
   if exist %1.prg goto :CONTINUE
   if not exist %1.hbp goto :ERROR1

:CONTINUE

   rem *** Delete Old Executable and Log ***
   if exist %1.exe     del %1.exe
   if exist %1.exe     goto :ERROR2
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

   if "%2"==""       goto :LOOP_END
   if /I "%2"=="/SL" goto :SUPPRESS_LOG
   if /I "%2"=="-SL" goto :SUPPRESS_LOG
   if /I "%2"=="-NR" goto :SUPPRESS_RUN
   if /I "%2"=="/NR" goto :SUPPRESS_RUN
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
   copy /b %HG_ROOT%\resources\oohg.rc + %TFILE%.rc _temp.rc > nul
   if exist _temp.rc goto :BUILD
   copy /b %TFILE%.rc _temp.rc > nul
   if not exist _temp.rc goto :ERROR3

:BUILD

   rem *** Compile and Link ***
   if     "%NO_LOG%"=="YES" hbmk2 %EXTRA% %TFILE% _temp.rc %HG_ROOT%\oohg.hbc %RUNEXE% -prgflag=-q0
   if not "%NO_LOG%"=="YES" hbmk2 %EXTRA% %TFILE% _temp.rc %HG_ROOT%\oohg.hbc %RUNEXE% -prgflag=-q0 >> output.log 2>&1
   if exist output.log type output.log

   rem *** Cleanup ***
   if exist _oohg_resconfig.h del _oohg_resconfig.h
   if exist _temp.* del _temp.*
   set PATH=%TPATH%
   set TPATH=
   set TFILE=
   set RUNEXE=
   set NO_LOG=
   set EXTRA=
   goto :END

:ERROR1

   echo COMPILE ERROR: Neither file %TFILE%.prg nor %TFILE%.hbp were found !!!
   goto :END

:ERROR2

   echo COMPILE ERROR: is %TFILE%.exe running ?
   goto :END

:ERROR3

   echo COMPILE ERROR: Neither file %TFILE%.rc nor oohg.rc were found !!!
   goto :END

:END
