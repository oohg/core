@echo off
rem
rem $Id: compile_vc.bat,v 1.3 2015-03-10 01:58:12 fyurisich Exp $
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
if "%HG_HRB%"==""  set HG_HRB=%HG_ROOT%\harbour
if "%HG_VC%"==""   set HG_VC=%PROGRAMFILES%\Microsoft Visual Studio 9.0\vc

rem *** Set EnvVars ***
if "%LIB_GUI%"=="" set LIB_GUI=lib
if "%LIB_HRB%"=="" set LIB_HRB=lib
if "%BIN_HRB%"=="" set BIN_HRB=bin

rem *** To Build with Nightly Harbour ***
rem *** For 32 bits MSVC ***
rem set LIB_GUI=lib\hb\vc
rem set LIB_HRB=lib\win\vc
rem set BIN_HRB=bin or bin\win\vc

rem *** Set GT and Check for Debug Switch ***
set HG_USE_GT=gtwin
for %%a in ( %2 %3 %4 %5 %6 %7 %8 %9 ) do if "%%a"=="/d" goto DEBUG_COMP
for %%a in ( %2 %3 %4 %5 %6 %7 %8 %9 ) do if "%%a"=="/D" goto DEBUG_COMP

rem *** Set GT and Compile with Harbour ***
if exist %HG_HRB%\%LIB_HRB%\gtgui.lib set HG_USE_GT=gtgui
%HG_HRB%\%BIN_HRB%\harbour %1.prg -n -i%HG_HRB%\include;%HG_ROOT%\include; %2 %3

goto C_COMP


:DEBUG_COMP
rem *** Compile with Harbour Using -b Option ***
echo OPTIONS NORUNATSTARTUP > INIT.CLD
%HG_HRB%\%BIN_HRB%\harbour %1.prg -n -b -i%HG_HRB%\include;%HG_ROOT%\include; %2 %3


:C_COMP
rem *** Check for Errors in Harbour Compilation ***
if errorlevel 1 goto EXIT1

rem *** Change Path, Compile with VC and Check for Errors ***
set TPATH=%PATH%
set PATH="%HG_VC%\bin";%PATH%
if exist "%HG_VC%"\vcvarsall.bat call "%HG_VC%"\vcvarsall.bat
cl /O2 /c /TP /I%HG_HRB%\include /I%HG_ROOT%\include /I. /D__WIN32__ %1.c
if errorlevel 1 goto EXIT2

rem *** Process Resource File and Check for Errors ***
if exist %1.rc rc /Fo%1.res %1.rc
if errorlevel 1 goto EXIT3

rem *** Build Response File ***
echo /OUT:%1.exe > vc.lnk
echo /FORCE:MULTIPLE >> vc.lnk
echo /INCLUDE:__matherr >> vc.lnk
echo %1.obj >> vc.lnk
echo %HG_ROOT%\%LIB_GUI%\oohg.lib >> vc.lnk

rem *** Compiler Libraries ***
for %%a in (rtl vm %HG_USE_GT% lang codepage macro rdd dbfntx dbfcdx dbffpt common debug pp) do echo %HG_HRB%\lib\%%a.lib >> vc.lnk

rem *** Harbour-dependant Libraries ***
if exist %HG_HRB%\%LIB_HRB%\dbfdbt.lib     echo %HG_HRB%\%LIB_HRB%\dbfdbt.lib >> vc.lnk
if exist %HG_HRB%\%LIB_HRB%\hbsix.lib      echo %HG_HRB%\%LIB_HRB%\hbsix.lib >> vc.lnk
if exist %HG_HRB%\%LIB_HRB%\tip.lib        echo %HG_HRB%\%LIB_HRB%\tip.lib >> vc.lnk
if exist %HG_HRB%\%LIB_HRB%\ct.lib         echo %HG_HRB%\%LIB_HRB%\ct.lib >> vc.lnk
if exist %HG_HRB%\%LIB_HRB%\hsx.lib        echo %HG_HRB%\%LIB_HRB%\hsx.lib >> vc.lnk
if exist %HG_HRB%\%LIB_HRB%\pcrepos.lib    echo %HG_HRB%\%LIB_HRB%\pcrepos.lib >> vc.lnk

rem *** Additional Libraries ***
if exist %HG_HRB%\%LIB_HRB%\libct.lib      echo %HG_HRB%\%LIB_HRB%\libct.lib >> vc.lnk
if exist %HG_HRB%\%LIB_HRB%\libmisc.lib    echo %HG_HRB%\%LIB_HRB%\libmisc.lib >> vc.lnk
if exist %HG_HRB%\%LIB_HRB%\hboleaut.lib   echo %HG_HRB%\%LIB_HRB%\hboleaut.lib >> vc.lnk
if exist %HG_HRB%\%LIB_HRB%\dll.lib        echo %HG_HRB%\%LIB_HRB%\dll.lib >> vc.lnk

rem *** "Related" Libraries ***
if exist %HG_HRB%\%LIB_HRB%\socket.lib     echo %HG_HRB%\%LIB_HRB%\socket.lib >> vc.lnk
if exist %HG_ROOT%\%LIB_GUI%\socket.lib    echo %HG_ROOT%\%LIB_GUI%\socket.lib >> vc.lnk
if exist %HG_ROOT%\%LIB_GUI%\hbprinter.lib echo %HG_ROOT%\%LIB_GUI%\hbprinter.lib >> vc.lnk
if exist %HG_ROOT%\%LIB_GUI%\miniprint.lib echo %HG_ROOT%\%LIB_GUI%\miniprint.lib >> vc.lnk

rem *** ODBC Libraries ***
for %%a in ( %2 %3 %4 %5 %6 %7 %8 %9 ) do if "%%a"=="/o" echo %HG_HRB%\%LIB_HRB%\hbodbc.lib >> vc.lnk
for %%a in ( %2 %3 %4 %5 %6 %7 %8 %9 ) do if "%%a"=="/o" echo %HG_HRB%\%LIB_HRB%\odbc32.lib >> vc.lnk
for %%a in ( %2 %3 %4 %5 %6 %7 %8 %9 ) do if "%%a"=="/O" echo %HG_HRB%\%LIB_HRB%\hbodbc.lib >> vc.lnk
for %%a in ( %2 %3 %4 %5 %6 %7 %8 %9 ) do if "%%a"=="/O" echo %HG_HRB%\%LIB_HRB%\odbc32.lib >> vc.lnk

rem *** ZIP Libraries ***
for %%a in ( %2 %3 %4 %5 %6 %7 %8 %9 ) do if "%%a"=="/z" echo %HG_HRB%\%LIB_HRB%\zlib1.lib >> vc.lnk
for %%a in ( %2 %3 %4 %5 %6 %7 %8 %9 ) do if "%%a"=="/z" echo %HG_HRB%\%LIB_HRB%\ziparchive.lib >> vc.lnk
for %%a in ( %2 %3 %4 %5 %6 %7 %8 %9 ) do if "%%a"=="/Z" echo %HG_HRB%\%LIB_HRB%\zlib1.lib >> vc.lnk
for %%a in ( %2 %3 %4 %5 %6 %7 %8 %9 ) do if "%%a"=="/Z" echo %HG_HRB%\%LIB_HRB%\ziparchive.lib >> vc.lnk

rem *** ADS Libraries ***
for %%a in ( %2 %3 %4 %5 %6 %7 %8 %9 ) do if "%%a"=="/a" echo %HG_HRB%\%LIB_HRB%\rddads.lib >> vc.lnk
for %%a in ( %2 %3 %4 %5 %6 %7 %8 %9 ) do if "%%a"=="/a" echo %HG_HRB%\%LIB_HRB%\ace32.lib >> vc.lnk
for %%a in ( %2 %3 %4 %5 %6 %7 %8 %9 ) do if "%%a"=="/A" echo %HG_HRB%\%LIB_HRB%\rddads.lib >> vc.lnk
for %%a in ( %2 %3 %4 %5 %6 %7 %8 %9 ) do if "%%a"=="/A" echo %HG_HRB%\%LIB_HRB%\ace32.lib >> vc.lnk

rem *** MySql Libraries ***
for %%a in ( %2 %3 %4 %5 %6 %7 %8 %9 ) do if "%%a"=="/m" echo %HG_HRB%\%LIB_HRB%\mysql.lib >> vc.lnk
for %%a in ( %2 %3 %4 %5 %6 %7 %8 %9 ) do if "%%a"=="/m" echo %HG_HRB%\%LIB_HRB%\libmysqldll.lib >> vc.lnk
for %%a in ( %2 %3 %4 %5 %6 %7 %8 %9 ) do if "%%a"=="/M" echo %HG_HRB%\%LIB_HRB%\mysql.lib >> vc.lnk
for %%a in ( %2 %3 %4 %5 %6 %7 %8 %9 ) do if "%%a"=="/M" echo %HG_HRB%\%LIB_HRB%\libmysqldll.lib >> vc.lnk

rem *** VC-dependant Libraries ***
for %%a in (user32 ws2_32 winspool ole32 oleaut32 advapi32 winmm mpr) do echo %%a.lib >> vc.lnk
for %%a in (shell32 gdi32 comctl32 comdlg32 wsock32) do echo %%a.lib >> vc.lnk

rem *** Check for Debug Switch ***
for %%a in ( %2 %3 %4 %5 %6 %7 %8 %9 ) do if "%%a"=="/d" goto DEBUG_LINK
for %%a in ( %2 %3 %4 %5 %6 %7 %8 %9 ) do if "%%a"=="/D" goto DEBUG_LINK

rem *** Resource Files ***
if exist %1.res echo %1.res >> vc.lnk
if exist %HG_ROOT%\resources\hbprinter.res echo %HG_ROOT%\resources\hbprinter.res >> vc.lnk
if exist %HG_ROOT%\resources\miniprint.res echo %HG_ROOT%\resources\miniprint.res >> vc.lnk
if exist %HG_ROOT%\resources\oohg.res      echo %HG_ROOT%\resources\oohg.res >> vc.lnk

rem *** Link ***
link /SUBSYSTEM:WINDOWS @vc.lnk

goto CLEANUP


:DEBUG_LINK
rem *** Link ***
link /SUBSYSTEM:CONSOLE @vc.lnk

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
del %1.c
del %1.obj
del vc.lnk
if exist %1.res del %1.res
set PATH=%TPATH%
set TPATH=
set HG_USE_GT=

rem *** Execute ***
%1
goto EXIT


:EXIT4
rem *** Cleanup ***
del vc.lnk
del %1.obj


:EXIT3
rem *** Cleanup ***
if exist %1.res del %1.res


:EXIT2
rem *** Cleanup ***
del %1.c
set PATH=%TPATH%
set TPATH=


:EXIT1
rem *** Cleanup ***
set HG_USE_GT=


:EXIT
if exist init.cld del init.cld
