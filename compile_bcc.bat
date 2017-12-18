@echo off
rem
rem $Id: compile_bcc.bat $
rem

:COMPILE_BCC

   if not "%HG_ROOT%" == "" goto CHECK

   set THIS_DRIVE_AND_PATH=%~dp0
   set HG_ROOT=%THIS_DRIVE_AND_PATH%
   if "%THIS_DRIVE_AND_PATH:~-1%" == "\" set HG_ROOT=%THIS_DRIVE_AND_PATH:~0,-1%
   set THIS_DRIVE_AND_PATH=

:CHECK

   if "%1" == "" goto END
   if not exist %1.prg goto ERROR1

   if "%HG_HRB%"   == "" set HG_HRB=%HG_ROOT%\xhbcc
   if "%HG_BCC%"   == "" set HG_BCC=%HG_CCOMP%
   if "%HG_BCC%"   == "" set HG_BCC=c:\Borland\BCC55
   if "%HG_CCOMP%" == "" set HG_CCOMP=%HG_BCC%
   if "%LIB_GUI%"  == "" set LIB_GUI=lib\xhb\bcc
   if "%LIB_HRB%"  == "" set LIB_HRB=lib
   if "%BIN_HRB%"  == "" set BIN_HRB=bin
   if "%HG_RC%"    == "" set HG_RC=%HG_ROOT%\resources\oohg.res

:CLEAN_EXE

   if exist %1.exe del %1.exe
   if exist %1.exe goto ERROR2

:PARSE_SWITCHES

   set TFILE=%1
   set COMP_TYPE=STD
   set EXTRA=
   set NO_RUN=FALSE
   set PRG_LOG=
   set C_LOG=
   set C_DEFXHB=TRUE

:LOOP_START

   if    "%2" == ""    goto LOOP_END
   if /I "%2" == "-c"  goto COMP_CONSOLE
   if /I "%2" == "/c"  goto COMP_CONSOLE
   if /I "%2" == "-d"  goto COMP_DEBUG
   if /I "%2" == "/d"  goto COMP_DEBUG
   if /I "%2" == "-p"  goto PPO
   if /I "%2" == "/p"  goto PPO
   if /I "%2" == "-w3" goto W3
   if /I "%2" == "/w3" goto W3
   if /I "%2" == "-nr" goto NORUN
   if /I "%2" == "/nr" goto NORUN
   if /I "%2" == "-l"  goto USELOG
   if /I "%2" == "/l"  goto USELOG
   if /I "%2" == "-h"  goto ISNOTXHB
   if /I "%2" == "/h"  goto ISNOTXHB
   set EXTRA=%EXTRA% %2
   shift
   goto LOOP_START

:COMP_CONSOLE

   set COMP_TYPE=CONSOLE
   shift
   goto LOOP_START

:COMP_DEBUG

   set COMP_TYPE=DEBUG
   shift
   goto LOOP_START

:PPO

   set EXTRA=%EXTRA% -p
   shift
   goto LOOP_START

:W3

   set EXTRA=%EXTRA% -w3
   shift
   goto LOOP_START

:NORUN

   set NO_RUN=TRUE
   shift
   goto LOOP_START

:USELOG

   set PRG_LOG=-q0 1^>error.lst 2^>^&1
   set C_LOG=>error.lst
   shift
   goto LOOP_START

:ISNOTXHB

   set C_DEFXHB=FALSE

:LOOP_END

   rem *** Set GT and Check for Debug or Console Switch ***
   set HG_USE_GT=gtwin gtgui
   if "%COMP_TYPE%" == "DEBUG" goto DEBUG_COMP
   if "%COMP_TYPE%" == "CONSOLE" goto PRG_COMP
   set HG_USE_GT=gtgui gtwin

:PRG_COMP

   rem *** Compile with (x)Harbour ***
   %HG_HRB%\%BIN_HRB%\harbour %TFILE%.prg -n1 %EXTRA% -i%HG_HRB%\include;%HG_ROOT%\include; %PRG_LOG%

   rem *** Continue with .c Compilation ***
   goto C_COMP

:DEBUG_COMP

   rem *** Compile with Harbour Using -b Option ***
   echo OPTIONS NORUNATSTARTUP > INIT.CLD
   %HG_HRB%\%BIN_HRB%\harbour %TFILE%.prg -n1 -b %EXTRA% -i%HG_HRB%\include;%HG_ROOT%\include; %PRG_LOG%

:C_COMP

   rem *** Check for Errors in Harbour Compilation ***
   if errorlevel 1 goto CLEANUP1

   rem *** Compile with BCC and Check for Errors ***
   if     "%C_DEFXHB%" == "TRUE" %HG_BCC%\bin\bcc32 -c -O2 -tW -M -w -I%HG_HRB%\include;%HG_BCC%\include;%HG_ROOT%\include; -L%HG_BCC%\lib; -D__XHARBOUR__ %TFILE%.c %C_LOG%
   if not "%C_DEFXHB%" == "TRUE" %HG_BCC%\bin\bcc32 -c -O2 -tW -M -w -I%HG_HRB%\include;%HG_BCC%\include;%HG_ROOT%\include; -L%HG_BCC%\lib;                %TFILE%.c %C_LOG%
   if errorlevel 1 goto CLEANUP2

   rem *** Process Resource File and Check for Errors ***
   if exist %TFILE%.rc %HG_BCC%\bin\brc32 -r %TFILE%.rc %C_LOG%
   if errorlevel 1 goto CLEANUP3

   rem *** Build Response File ***
   echo c0w32.obj + > b32.bc
   echo %TFILE%.obj, + >> b32.bc
   echo %TFILE%.exe, + >> b32.bc
   echo %TFILE%.map, + >> b32.bc
   echo %HG_ROOT%\%LIB_GUI%\oohg.lib + >> b32.bc

   rem *** Compiler Libraries ***
   for %%a in ( rtl   vm   %HG_USE_GT% lang   codepage macro   rdd   dbfntx dbfcdx dbffpt common   debug   pp   ct             ) do if exist %HG_HRB%\%LIB_HRB%\%%a.lib echo %HG_HRB%\%LIB_HRB%\%%a.lib + >> b32.bc
   for %%a in ( hbrtl hbvm %HG_USE_GT% hblang hbcpage  hbmacro hbrdd rddntx rddcdx rddfpt hbcommon hbdebug hbpp hbct hbwin xhb ) do if exist %HG_HRB%\%LIB_HRB%\%%a.lib echo %HG_HRB%\%LIB_HRB%\%%a.lib + >> b32.bc

   rem *** Harbour-dependant Libraries ***
   for %%a in (dbfdbt hbsix tip hsx pcrepos) do if exist %HG_HRB%\%LIB_HRB%\%%a.lib echo %HG_HRB%\%LIB_HRB%\%%a.lib + >> b32.bc

   rem *** Additional Libraries ***
   if exist %HG_HRB%\%LIB_HRB%\libmisc.lib    echo %HG_HRB%\%LIB_HRB%\libmisc.lib + >> b32.bc
   if exist %HG_HRB%\%LIB_HRB%\hboleaut.lib   echo %HG_HRB%\%LIB_HRB%\hboleaut.lib + >> b32.bc
   if exist %HG_HRB%\%LIB_HRB%\dll.lib        echo %HG_HRB%\%LIB_HRB%\dll.lib + >> b32.bc

   rem *** "Related" Libraries ***
   if exist %HG_HRB%\%LIB_HRB%\socket.lib     echo %HG_HRB%\%LIB_HRB%\socket.lib + >> b32.bc
   if exist %HG_ROOT%\%LIB_GUI%\socket.lib    echo %HG_ROOT%\%LIB_GUI%\socket.lib + >> b32.bc
   if exist %HG_ROOT%\%LIB_GUI%\bostaurus.lib echo %HG_ROOT%\%LIB_GUI%\bostaurus.lib + >> b32.bc
   if exist %HG_ROOT%\%LIB_GUI%\hbprinter.lib echo %HG_ROOT%\%LIB_GUI%\hbprinter.lib + >> b32.bc
   if exist %HG_ROOT%\%LIB_GUI%\miniprint.lib echo %HG_ROOT%\%LIB_GUI%\miniprint.lib + >> b32.bc

   rem *** ODBC Libraries ***
   for %%a in ( %2 %3 %4 %5 %6 %7 %8 %9 ) do if /I "%%a" == "/o" echo %HG_HRB%\%LIB_HRB%\hbodbc.lib + >> b32.bc
   for %%a in ( %2 %3 %4 %5 %6 %7 %8 %9 ) do if /I "%%a" == "/o" echo %HG_HRB%\%LIB_HRB%\odbc32.lib + >> b32.bc

   rem *** ZIP Libraries ***
   for %%a in ( %2 %3 %4 %5 %6 %7 %8 %9 ) do if /I "%%a" == "/z" echo %HG_HRB%\%LIB_HRB%\zlib1.lib + >> b32.bc
   for %%a in ( %2 %3 %4 %5 %6 %7 %8 %9 ) do if /I "%%a" == "/z" echo %HG_HRB%\%LIB_HRB%\ziparchive.lib + >> b32.bc

   rem *** ADS Libraries ***
   for %%a in ( %2 %3 %4 %5 %6 %7 %8 %9 ) do if /I "%%a" == "/a" echo %HG_HRB%\%LIB_HRB%\rddads.lib + >> b32.bc
   for %%a in ( %2 %3 %4 %5 %6 %7 %8 %9 ) do if /I "%%a" == "/a" echo %HG_HRB%\%LIB_HRB%\ace32.lib + >> b32.bc

   rem *** MySql Libraries ***
   for %%a in ( %2 %3 %4 %5 %6 %7 %8 %9 ) do if /I "%%a" == "/m" echo %HG_HRB%\%LIB_HRB%\mysql.lib + >> b32.bc
   for %%a in ( %2 %3 %4 %5 %6 %7 %8 %9 ) do if /I "%%a" == "/m" echo %HG_HRB%\%LIB_HRB%\libmysqldll.lib + >> b32.bc

   rem *** BCC-dependant Libraries ***
   echo cw32.lib + >> b32.bc
   echo msimg32.lib + >> b32.bc
   echo import32.lib, , + >> b32.bc

   rem *** Resource Files ***
   if exist %TFILE%.res echo %TFILE%.res + >> b32.bc
   if exist %HG_RC% echo %HG_RC% + >> b32.bc

   rem *** Check for Debug Switch ***
   for %%a in ( %2 %3 %4 %5 %6 %7 %8 %9 ) do if "%%a" == "/d" GOTO DEBUG_LINK
   for %%a in ( %2 %3 %4 %5 %6 %7 %8 %9 ) do if "%%a" == "/D" GOTO DEBUG_LINK

   rem *** Link ***
   %HG_BCC%\bin\ilink32 -Gn -Tpe -aa -L%HG_BCC%\lib;%HG_BCC%\lib\psdk; @b32.bc %C_LOG%

   goto CLEANUP5

:DEBUG_LINK

   rem *** Link ***
   %HG_BCC%\bin\ilink32 -Gn -Tpe -ap -L%HG_BCC%\lib;%HG_BCC%\lib\psdk; @b32.bc %C_LOG%

   goto CLEANUP5

:ERROR1

   echo File %1.prg not found !!!
   goto END

:ERROR2

   echo COMPILE ERROR: Is %1.exe running ?
   goto END

:CLEANUP5

   rem *** Check for Errors in Linking ***
   if errorlevel 1 goto CLEANUP4

   rem *** Cleanup ***
   del *.tds
   del %TFILE%.c
   del %TFILE%.map
   del %TFILE%.obj
   del b32.bc
   if exist %TFILE%.res del %TFILE%.res
   set HG_USE_GT=
   set EXTRA=
   set PRG_LOG=
   set C_LOG=

   rem *** Execute ***
   if "%NO_RUN%" == "FALSE" %TFILE%
   set TFILE=
   set NO_RUN=
   goto END

:CLEANUP4

   rem *** Cleanup ***
   del b32.bc
   del %TFILE%.map
   del %TFILE%.obj
   del %TFILE%.tds

:CLEANUP3

   rem *** Cleanup ***
   if exist %TFILE%.res del %TFILE%.res

:CLEANUP2

   rem *** Cleanup ***
   del %TFILE%.c

:CLEANUP1

   rem *** Cleanup ***
   set HG_USE_GT=
   set EXTRA=
   set NO_RUN=
   set PRG_LOG=
   set C_LOG=

:END

   rem *** Cleanup ***
   if exist init.cld del init.cld
