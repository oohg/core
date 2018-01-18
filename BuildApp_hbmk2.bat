@echo off
rem
rem $Id: BuildApp_hbmk2.bat $
rem

:BUILDAPP_HBMK2

   if not "%HG_ROOT%" == "" goto CHECK

   pushd "%~dp0"
   set HG_ROOT=%CD%
   popd

:CHECK

   if "%1" == "" goto ERROR1
   if exist %1.prg goto CONTINUE
   if not exist %1.hbp goto ERROR2

:CONTINUE

   rem TODO: test for BuildApp30.bat and/or BuildApp32.bat ?

   if "%HG_HRB%"   == "" set HG_HRB=%HG_ROOT%\hb32
   if "%HG_MINGW%" == "" set HG_MINGW=%HG_CCOMP%
   if "%HG_MINGW%" == "" set HG_MINGW=%HG_HRB%\comp\mingw
   if "%HG_CCOMP%" == "" set HG_CCOMP=%HG_MINGW%
   if "%LIB_GUI%"  == "" set LIB_GUI=lib\hb\mingw
   if "%LIB_HRB%"  == "" set LIB_HRB=lib\win\mingw
   if "%BIN_HRB%"  == "" set BIN_HRB=bin

:CLEAN_EXE

   if exist %1.exe del %1.exe
   if exist %1.exe goto ERROR3
   if exist output.log del output.log
   if exist output.log goto ERROR4

:MORE_SETS

   rem *** Set PATH ***
   set TPATH=%PATH%
   set PATH=%HG_CCOMP%\bin;%HG_HRB%\%BIN_HRB%

:PARSE_SWITCHES

   set TFILE=%1
   set NO_LOG=NO
   set RUNEXE=-run
   set EXTRA=

:LOOP_START

   if    "%2" == ""    goto LOOP_END
   if /I "%2" == "/SL" goto SUPPRESS_LOG
   if /I "%2" == "-SL" goto SUPPRESS_LOG
   if /I "%2" == "-NR" goto SUPPRESS_RUN
   if /I "%2" == "/NR" goto SUPPRESS_RUN
   set EXTRA=%EXTRA% %2
   shift
   goto LOOP_START

:SUPPRESS_LOG

   set NO_LOG=YES
   shift
   goto LOOP_START

:SUPPRESS_RUN

   set RUNEXE=-run-
   shift
   goto LOOP_START

:LOOP_END

   rem *** Process Resource File ***
   echo Compiling %TFILE% ...
   echo #define oohgpath %HG_ROOT%\RESOURCES > _oohg_resconfig.h
   copy /b "%HG_ROOT%\resources\oohg.rc" + "%TFILE%.rc" _temp.rc > nul
   if exist _temp.rc goto BUILD
   copy /b %TFILE%.rc _temp.rc > nul
   if not exist _temp.rc goto ERROR5

:BUILD

   rem *** Compile and Link ***
   if     "%NO_LOG%" == "YES" hbmk2 %TFILE% _temp.rc %HG_ROOT%\oohg.hbc %RUNEXE% -prgflag=-q0 %EXTRA%
   if not "%NO_LOG%" == "YES" hbmk2 %TFILE% _temp.rc %HG_ROOT%\oohg.hbc %RUNEXE% -prgflag=-q0 %EXTRA% >> output.log 2>&1
   if exist output.log type output.log

:CLEANUP

   rem *** Cleanup ***
   if exist _oohg_resconfig.h del _oohg_resconfig.h
   if exist _temp.* del _temp.*
   set PATH=%TPATH%
   set TPATH=
   set TFILE=
   set RUNEXE=
   set NO_LOG=
   set EXTRA=
   goto END

:ERROR1

   echo COMPILE ERROR: No file specified !!!
   goto END

:ERROR2

   echo COMPILE ERROR: Neither file %TFILE%.prg nor %TFILE%.hbp were found !!!
   goto END

:ERROR3

   echo COMPILE ERROR: Is %TFILE%.exe running ?
   goto END

:ERROR4

   echo COMPILE ERROR: Can't delete output.log !!!
   goto END

:ERROR5

   echo COMPILE ERROR: Neither file %TFILE%.rc nor oohg.rc were found !!!
   goto END

:END
