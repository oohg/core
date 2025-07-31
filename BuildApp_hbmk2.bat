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
   if exist oohglog.txt del oohglog.txt
   if exist oohglog.txt goto ERROR5

:MORE_SETS

   rem *** Set PATH ***
   set "HG_PATH=%PATH%"
   set "PATH=%HG_CCOMP%\bin;%HG_HRB%\%BIN_HRB%;%PATH%"

:PARSE_SWITCHES

   set HG_COMP_TYPE=STD
   set HG_EXTRA=
   set HG_LOG=1^>nul
   set HG_RUNEXE=-run
   set HG_STRIP=-strip
   set HG_TRACE=
   set HG_USE_HBC=%HG_ROOT%\oohg.hbc
   set HG_USE_RC=TRUE

:LOOP_START

   if    "%2" == ""         goto LOOP_END
   if /I "%2" == "/C"       goto SW_CONSOLE
   if /I "%2" == "/D"       goto SW_DEBUG
   if /I "%2" == "/GTWIN"   goto SW_CONSOLE
   if /I "%2" == "/L"       goto SW_USELOG
   if /I "%2" == "/LOG"     goto SW_USELOG
   if /I "%2" == "/NOHBC"   goto SW_NOHBC
   if /I "%2" == "/NORC"    goto SW_NORC
   if /I "%2" == "/NOSTRIP" goto SW_NOSTRIP
   if /I "%2" == "/NR"      goto SUPPRESS_RUN
   if /I "%2" == "/S"       goto SUPPRESS_LOG
   if /I "%2" == "/SL"      goto SUPPRESS_LOG
   if /I "%2" == "/T"       goto SW_TRACE
   if /I "%2" == "/V"       goto SW_VERBOSE
   if /I "%2" == "-C"       goto SW_CONSOLE
   if /I "%2" == "-D"       goto SW_DEBUG
   if /I "%2" == "-GTWIN"   goto SW_CONSOLE
   if /I "%2" == "-L"       goto SW_USELOG
   if /I "%2" == "-LOG"     goto SW_USELOG
   if /I "%2" == "-NOHBC"   goto SW_NOHBC
   if /I "%2" == "-NORC"    goto SW_NORC
   if /I "%2" == "-NR"      goto SUPPRESS_RUN
   if /I "%2" == "-NOSTRIP" goto SW_NOSTRIP
   if /I "%2" == "-S"       goto SUPPRESS_LOG
   if /I "%2" == "-SL"      goto SUPPRESS_LOG
   if /I "%2" == "-T"       goto SW_TRACE
   if /I "%2" == "-V"       goto SW_VERBOSE
   set HG_EXTRA=%HG_EXTRA% %2
   shift
   goto LOOP_START

:SUPPRESS_LOG

   set HG_LOG=1^>nul 2^>^&1
   shift
   goto LOOP_START

:SUPPRESS_RUN

   set HG_RUNEXE=-run-
   shift
   goto LOOP_START

:SW_CONSOLE

   set HG_COMP_TYPE=CONSOLE
   set HG_EXTRA=%HG_EXTRA% -D_OOHG_CONSOLEMODE_
   shift
   goto LOOP_START

:SW_DEBUG

   set HG_COMP_TYPE=DEBUG
   set HG_EXTRA=%HG_EXTRA% -D_OOHG_CONSOLEMODE_
   shift
   goto LOOP_START

:SW_NOHBC

   set HG_USE_HBC=
   shift
   goto LOOP_START

:SW_NORC

   set HG_USE_RC=FALSE
   shift
   goto LOOP_START

:SW_NOSTRIP

   set HG_STRIP=
   shift
   goto LOOP_START

:SW_USELOG

   set HG_LOG=1^>^>oohglog.txt 2^>^>^&1
   shift
   goto LOOP_START

:SW_TRACE

   set HG_TRACE=-trace
   shift
   goto LOOP_START

:SW_VERBOSE

   set HG_LOG=
   shift
   goto LOOP_START

:LOOP_END

   if     "%HG_COMP_TYPE%" == "CONSOLE" set HG_EXTRA=-GTWIN %HG_EXTRA%
   if not "%HG_COMP_TYPE%" == "CONSOLE" set HG_EXTRA=-GTGUI %HG_EXTRA%
   if "%HG_COMP_TYPE%" == "DEBUG" echo OPTIONS NORUNATSTARTUP > init.cld
   if "%HG_COMP_TYPE%" == "DEBUG" set %HG_EXTRA%=-b %HG_EXTRA%

   echo #define oohgpath %HG_ROOT%\RESOURCES > _oohg_resconfig.h

   if "%HG_USE_RC%" == "FALSE" goto WITHOUT_HG_RC

   rem *** Process oohg + app resource files ***
   echo. > "%HG_ROOT%\resources\filler"
   if     exist %HG_FILE%.rc copy /b %HG_FILE%.rc + %HG_ROOT%\resources\filler + %HG_ROOT%\resources\oohg.rc _temp.rc %HG_LOG%
   if not exist %HG_FILE%.rc copy /b %HG_ROOT%\resources\oohg.rc _temp.rc %HG_LOG%
   if not exist _temp.rc echo COMPILE ERROR: Error creating file _temp.rc !!!
   if not exist _temp.rc goto CLEANUP
   set HG_USE_RC=_temp.rc
   goto BUILD

:WITHOUT_HG_RC

   set HG_USE_RC=
   if not exist %HG_FILE%.rc goto BUILD

   rem *** Process app resource file ***
   copy /b %HG_FILE%.rc _temp.rc %HG_LOG%
   if not exist _temp.rc echo COMPILE ERROR: Error creating file _temp.rc !!!
   if not exist _temp.rc goto CLEANUP
   set HG_USE_RC=_temp.rc

:BUILD

   rem *** Compile and Link ***
   hbmk2 %HG_FILE% "%HG_USE_RC%" %HG_USE_HBC% %HG_RUNEXE% -prgflag=-q0 %HG_STRIP% %HG_EXTRA% %HG_LOG% %HG_TRACE%
   if exist oohglog.txt type oohglog.txt

:CLEANUP

   rem *** Cleanup ***
   if exist _oohg_resconfig.h del _oohg_resconfig.h
   if exist _temp.* del _temp.*
   set "PATH=%HG_PATH%"
   set HG_PATH=
   set HG_FILE=
   set HG_RUNEXE=
   set HG_LOG=
   set HG_EXTRA=
   set HG_TRACE=
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

   echo COMPILE ERROR: Can't delete oohglog.txt !!!
   goto END

:END

   echo.
