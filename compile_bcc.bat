@echo off
rem
rem $Id: compile_bcc.bat,v 1.19 2015-11-07 22:39:57 fyurisich Exp $
rem
cls

REM *** Check for .prg ***
if "%1"=="" goto EXIT
if not exist %1.prg goto ERREXIT1

rem *** Delete Old Executable ***
if exist %1.exe del %1.exe
if exist %1.exe goto ERREXIT2

rem *** Set Paths ***
if "%HG_ROOT%"=="" set HG_ROOT=c:\oohg
if "%HG_HRB%"==""  set HG_HRB=c:\oohg\harbour
if "%HG_BCC%"==""  set HG_BCC=c:\borland\bcc55

rem *** Set EnvVars ***
if "%LIB_GUI%"=="" set LIB_GUI=lib
if "%LIB_HRB%"=="" set LIB_HRB=lib
if "%BIN_HRB%"=="" set BIN_HRB=bin

rem *** To Build with Nightly Harbour ***
rem *** For 32 bits BCC ***
rem set LIB_GUI=lib\hb\bcc
rem set LIB_HRB=lib\win\bcc
rem set BIN_HRB=bin or bin\win\bcc

rem *** Parse Switches ***
set TFILE=%1
set COMP_TYPE=STD
set EXTRA=
set NO_RUN=FALSE
set PRG_LOG=
set C_LOG=
:LOOP_START
if "%2"==""    goto LOOP_END
if "%2"=="/d"  goto COMP_DEBUG
if "%2"=="-d"  goto COMP_DEBUG
if "%2"=="/D"  goto COMP_DEBUG
if "%2"=="-D"  goto COMP_DEBUG
if "%2"=="-p"  goto PPO
if "%2"=="/p"  goto PPO
if "%2"=="-P"  goto PPO
if "%2"=="/P"  goto PPO
if "%2"=="-w3" goto W3
if "%2"=="/w3" goto W3
if "%2"=="-W3" goto W3
if "%2"=="/W3" goto W3
if "%2"=="-nr" goto NORUN
if "%2"=="-Nr" goto NORUN
if "%2"=="-nR" goto NORUN
if "%2"=="-NR" goto NORUN
if "%2"=="/nr" goto NORUN
if "%2"=="/Nr" goto NORUN
if "%2"=="/nR" goto NORUN
if "%2"=="/NR" goto NORUN
if "%2"=="/l"  goto USELOG
if "%2"=="-l"  goto USELOG
if "%2"=="/L"  goto USELOG
if "%2"=="-L"  goto USELOG
set EXTRA=%EXTRA% %2
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
:LOOP_END

rem *** Set GT and Check for Debug Switch ***
set HG_USE_GT=gtwin
if "%COMP_TYPE%"=="DEBUG" goto DEBUG_COMP

rem *** Set GT and Compile with Harbour ***
if exist %HG_HRB%\%LIB_HRB%\gtgui.lib set HG_USE_GT=gtgui
%HG_HRB%\%BIN_HRB%\harbour %TFILE%.prg -n %EXTRA% -i%HG_HRB%\include;%HG_ROOT%\include; %PRG_LOG%

rem *** Continue with .c Compilation ***
goto C_COMP


:DEBUG_COMP
rem *** Compile with Harbour Using -b Option ***
echo OPTIONS NORUNATSTARTUP > INIT.CLD
%HG_HRB%\%BIN_HRB%\harbour %TFILE%.prg -n -b %EXTRA% -i%HG_HRB%\include;%HG_ROOT%\include; %PRG_LOG%


:C_COMP
rem *** Check for Errors in Harbour Compilation ***
if errorlevel 1 goto EXIT1

rem *** Compile with BCC and Check for Errors ***
%HG_BCC%\bin\bcc32 -c -O2 -tW -M -w -I%HG_HRB%\include;%HG_BCC%\include;%HG_ROOT%\include; -L%HG_BCC%\lib; %TFILE%.c %C_LOG%
if errorlevel 1 goto EXIT2

rem *** Process Resource File and Check for Errors ***
if exist %TFILE%.rc %HG_BCC%\bin\brc32 -r %TFILE%.rc %C_LOG%
if errorlevel 1 goto EXIT3

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
for %%a in ( %2 %3 %4 %5 %6 %7 %8 %9 ) do if "%%a"=="/o" echo %HG_HRB%\%LIB_HRB%\hbodbc.lib + >> b32.bc
for %%a in ( %2 %3 %4 %5 %6 %7 %8 %9 ) do if "%%a"=="/o" echo %HG_HRB%\%LIB_HRB%\odbc32.lib + >> b32.bc
for %%a in ( %2 %3 %4 %5 %6 %7 %8 %9 ) do if "%%a"=="/O" echo %HG_HRB%\%LIB_HRB%\hbodbc.lib + >> b32.bc
for %%a in ( %2 %3 %4 %5 %6 %7 %8 %9 ) do if "%%a"=="/O" echo %HG_HRB%\%LIB_HRB%\odbc32.lib + >> b32.bc

rem *** ZIP Libraries ***
for %%a in ( %2 %3 %4 %5 %6 %7 %8 %9 ) do if "%%a"=="/z" echo %HG_HRB%\%LIB_HRB%\zlib1.lib + >> b32.bc
for %%a in ( %2 %3 %4 %5 %6 %7 %8 %9 ) do if "%%a"=="/z" echo %HG_HRB%\%LIB_HRB%\ziparchive.lib + >> b32.bc
for %%a in ( %2 %3 %4 %5 %6 %7 %8 %9 ) do if "%%a"=="/Z" echo %HG_HRB%\%LIB_HRB%\zlib1.lib + >> b32.bc
for %%a in ( %2 %3 %4 %5 %6 %7 %8 %9 ) do if "%%a"=="/Z" echo %HG_HRB%\%LIB_HRB%\ziparchive.lib + >> b32.bc

rem *** ADS Libraries ***
for %%a in ( %2 %3 %4 %5 %6 %7 %8 %9 ) do if "%%a"=="/a" echo %HG_HRB%\%LIB_HRB%\rddads.lib + >> b32.bc
for %%a in ( %2 %3 %4 %5 %6 %7 %8 %9 ) do if "%%a"=="/a" echo %HG_HRB%\%LIB_HRB%\ace32.lib + >> b32.bc
for %%a in ( %2 %3 %4 %5 %6 %7 %8 %9 ) do if "%%a"=="/A" echo %HG_HRB%\%LIB_HRB%\rddads.lib + >> b32.bc
for %%a in ( %2 %3 %4 %5 %6 %7 %8 %9 ) do if "%%a"=="/A" echo %HG_HRB%\%LIB_HRB%\ace32.lib + >> b32.bc

rem *** MySql Libraries ***
for %%a in ( %2 %3 %4 %5 %6 %7 %8 %9 ) do if "%%a"=="/m" echo %HG_HRB%\%LIB_HRB%\mysql.lib + >> b32.bc
for %%a in ( %2 %3 %4 %5 %6 %7 %8 %9 ) do if "%%a"=="/m" echo %HG_HRB%\%LIB_HRB%\libmysqldll.lib + >> b32.bc
for %%a in ( %2 %3 %4 %5 %6 %7 %8 %9 ) do if "%%a"=="/M" echo %HG_HRB%\%LIB_HRB%\mysql.lib + >> b32.bc
for %%a in ( %2 %3 %4 %5 %6 %7 %8 %9 ) do if "%%a"=="/M" echo %HG_HRB%\%LIB_HRB%\libmysqldll.lib + >> b32.bc

rem *** BCC-dependant Libraries ***
echo cw32.lib + >> b32.bc
echo msimg32.lib + >> b32.bc
echo import32.lib, , + >> b32.bc

rem *** Resource Files ***
if exist %TFILE%.res echo %TFILE%.res + >> b32.bc
if exist %HG_ROOT%\resources\oohg.res echo %HG_ROOT%\resources\oohg.res + >> b32.bc

rem *** Check for Debug Switch ***
for %%a in ( %2 %3 %4 %5 %6 %7 %8 %9 ) do if "%%a"=="/d" GOTO DEBUG_LINK
for %%a in ( %2 %3 %4 %5 %6 %7 %8 %9 ) do if "%%a"=="/D" GOTO DEBUG_LINK

rem *** Link ***
%HG_BCC%\bin\ilink32 -Gn -Tpe -aa -L%HG_BCC%\lib;%HG_BCC%\lib\psdk; @b32.bc %C_LOG%

goto CLEANUP


:DEBUG_LINK
rem *** Link ***
%HG_BCC%\bin\ilink32 -Gn -Tpe -ap -L%HG_BCC%\lib;%HG_BCC%\lib\psdk; @b32.bc %C_LOG%

goto CLEANUP


:ERREXIT1
echo FILE %1.PRG NOT FOUND !!!

goto EXIT


:ERREXIT2
echo COMPILE ERROR: IS %1.EXE RUNNING ?

goto EXIT


:CLEANUP
rem *** Check for Errors in Linking ***
if errorlevel 1 goto EXIT4

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
if "%NO_RUN%"=="FALSE" %TFILE%
set TFILE=
set NO_RUN=
goto EXIT


:EXIT4
rem *** Cleanup ***
del b32.bc
del %TFILE%.map
del %TFILE%.obj
del %TFILE%.tds


:EXIT3
rem *** Cleanup ***
if exist %TFILE%.res del %TFILE%.res


:EXIT2
rem *** Cleanup ***
del %TFILE%.c


:EXIT1
rem *** Cleanup ***
set HG_USE_GT=
set EXTRA=
set NO_RUN=
set PRG_LOG=
set C_LOG=


:EXIT
rem *** Cleanup ***
if exist init.cld del init.cld
