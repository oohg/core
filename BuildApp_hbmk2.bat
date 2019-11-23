@echo off
rem
rem $Id: BuildApp_hbmk2.bat $
rem

:BUILDAPP_HBMK2

   if "%HG_ROOT%"  == "" goto ERROR1
   if "%HG_HRB%"   == "" goto ERROR1
   if "%HG_CCOMP%" == "" goto ERROR1
   if "%LIB_GUI%"  == "" goto ERROR1
   if "%LIB_HRB%"  == "" goto ERROR1
   if "%BIN_HRB%"  == "" goto ERROR1

:CHECK

   if "%1" == "" goto ERROR2
   set HG_FILE=%1
   if exist %1.prg goto CONTINUE
   if exist %1.hbp goto CONTINUE
   set HG_FILE=%~n1
   if /I "%~x1" == ".PRG" goto CONTINUE
   if /I "%~x1" == ".HBP" goto CONTINUE
   set HG_FILE=
   goto ERROR3

:CONTINUE

   if exist %HG_FILE%.exe del %HG_FILE%.exe
   if exist %HG_FILE%.exe goto ERROR4
   if exist output.log del output.log
   if exist output.log goto ERROR5

:MORE_SETS

   rem *** Set PATH ***
   set "HG_PATH=%PATH%"
   set "PATH=%HG_CCOMP%\bin;%HG_HRB%\%BIN_HRB%"

:PARSE_SWITCHES

   set HG_NOLOG=NO
   set HG_RUNEXE=-run
   set HG_EXTRA=
   set HG_COMP_TYPE=STD

:LOOP_START

   if    "%2" == ""       goto LOOP_END
   if /I "%2" == "/SL"    goto SUPPRESS_LOG
   if /I "%2" == "-SL"    goto SUPPRESS_LOG
   if /I "%2" == "-NR"    goto SUPPRESS_RUN
   if /I "%2" == "/NR"    goto SUPPRESS_RUN
   if /I "%2" == "-GTWIN" goto SW_CONSOLE
   set HG_EXTRA=%HG_EXTRA% %2
   shift
   goto LOOP_START

:SW_CONSOLE

   set HG_COMP_TYPE=CONSOLE
   set HG_EXTRA=%HG_EXTRA% -D_OOHG_CONSOLEMODE_
   shift
   goto LOOP_START

:SUPPRESS_LOG

   set HG_NOLOG=YES
   shift
   goto LOOP_START

:SUPPRESS_RUN

   set HG_RUNEXE=-run-
   shift
   goto LOOP_START

:LOOP_END

   if     "%HG_COMP_TYPE%" == "CONSOLE" set HG_EXTRA=-GTWIN %HG_EXTRA%
   if not "%HG_COMP_TYPE%" == "CONSOLE" set HG_EXTRA=-GTGUI %HG_EXTRA%

   rem *** Process Resource File ***
   echo Compiling %HG_FILE% ...
   echo #define oohgpath %HG_ROOT%\RESOURCES > _oohg_resconfig.h
   copy /b "%HG_ROOT%\resources\oohg.rc" + "%HG_FILE%.rc" _temp.rc > nul
   if exist _temp.rc goto BUILD
   copy /b %HG_FILE%.rc _temp.rc > nul
   if not exist _temp.rc goto ERROR6

:BUILD

   rem *** Compile and Link ***
   if     "%HG_NOLOG%" == "YES" hbmk2 %HG_FILE% _temp.rc %HG_ROOT%\oohg.hbc %HG_RUNEXE% -prgflag=-q0 %HG_EXTRA%
   if not "%HG_NOLOG%" == "YES" hbmk2 %HG_FILE% _temp.rc %HG_ROOT%\oohg.hbc %HG_RUNEXE% -prgflag=-q0 %HG_EXTRA% >> output.log 2>&1
   if exist output.log type output.log

:CLEANUP

   rem *** Cleanup ***
   if exist _oohg_resconfig.h del _oohg_resconfig.h
   if exist _temp.* del _temp.*
   set "PATH=%HG_PATH%"
   set HG_PATH=
   set HG_FILE=
   set HG_RUNEXE=
   set HG_NOLOG=
   set HG_EXTRA=
   goto END

:ERROR1

   echo This file must be called from BUILDAPP.BAT !!!
   goto END

:ERROR2

   echo COMPILE ERROR: No file specified !!!
   goto END

:ERROR3

   echo COMPILE ERROR: Neither file %HG_FILE%.prg nor %HG_FILE%.hbp were found !!!
   goto END

:ERROR4

   echo COMPILE ERROR: Is %HG_FILE%.exe running ?
   goto END

:ERROR5

   echo COMPILE ERROR: Can't delete output.log !!!
   goto END

:ERROR6

   echo COMPILE ERROR: Neither file %HG_FILE%.rc nor oohg.rc were found !!!
   goto END

:END

   echo.
