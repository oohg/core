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
   set HG_USE_HBC=%HG_ROOT%\oohg.hbc
   set HG_USE_RC=TRUE
   set HG_NOVER=NO

:LOOP_START

   if    "%2" == ""       goto LOOP_END
   if /I "%2" == "/SL"    goto SUPPRESS_LOG
   if /I "%2" == "-SL"    goto SUPPRESS_LOG
   if /I "%2" == "-NR"    goto SUPPRESS_RUN
   if /I "%2" == "/NR"    goto SUPPRESS_RUN
   if /I "%2" == "-GTWIN" goto SW_CONSOLE
   if /I "%2" == "/GTWIN" goto SW_CONSOLE
   if /I "%2" == "-NOHBC" goto SW_NOHBC
   if /I "%2" == "/NOHBC" goto SW_NOHBC
   if /I "%2" == "/NORC"  goto SW_NORC
   if /I "%2" == "-NORC"  goto SW_NORC
   if /I "%2" == "-NOVER" goto SW_NOVER
   if /I "%2" == "/NOVER" goto SW_NOVER
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

:SW_NOHBC

   set HG_USE_HBC=
   shift
   goto LOOP_START

:SW_NOVER

   set HG_NOVER=YES
   shift
   goto LOOP_START

:SW_NORC

   set HG_USE_RC=FALSE
   shift
   goto LOOP_START

:LOOP_END

   if     "%HG_COMP_TYPE%" == "CONSOLE" set HG_EXTRA=-GTWIN %HG_EXTRA%
   if not "%HG_COMP_TYPE%" == "CONSOLE" set HG_EXTRA=-GTGUI %HG_EXTRA%

   if "%HG_USE_RC%" == "FALSE" goto WITHOUT_HG_RC

   rem *** Process oohg + app resource files ***
   echo #define oohgpath %HG_ROOT%\RESOURCES > _oohg_resconfig.h
   if "%HG_NOVER%" == "YES" echo #define __VERSION_INFO >> _oohg_resconfig.h
   copy /b "%HG_ROOT%\resources\oohg.rc" + "%HG_FILE%.rc" _temp.rc > nul
   if not exist _temp.rc goto ERROR6
   set HG_USE_RC=_temp.rc
   goto BUILD

:WITHOUT_HG_RC

   set HG_USE_RC=
   if not exist %HG_FILE%.rc goto BUILD

   rem *** Process app resource file ***
   copy /b %HG_FILE%.rc _temp.rc > nul
   if not exist _temp.rc goto ERROR6
   set HG_USE_RC=_temp.rc

:BUILD

   rem *** Compile and Link ***
   if     "%HG_NOLOG%" == "YES" hbmk2 %HG_FILE% "%HG_USE_RC%" %HG_USE_HBC% %HG_RUNEXE% -prgflag=-q0 %HG_EXTRA%
   if not "%HG_NOLOG%" == "YES" hbmk2 %HG_FILE% "%HG_USE_RC%" %HG_USE_HBC% %HG_RUNEXE% -prgflag=-q0 %HG_EXTRA% >> output.log 2>&1
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
   set HG_USE_RC=
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
