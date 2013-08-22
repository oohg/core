@echo off
rem
rem $Id: compile_pc.bat,v 1.8 2013-08-22 22:25:02 fyurisich Exp $
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
if "%HG_PC%"==""   set HG_PC=c:\pellesc

rem *** Set EnvVars ***
if "%LIB_GUI%"=="" set LIB_GUI=lib
if "%LIB_HRB%"=="" set LIB_HRB=lib
if "%BIN_HRB%"=="" set BIN_HRB=bin

rem *** To Build with Nightly Harbour ***
rem *** For 32 bits MSVC ***
rem set LIB_GUI=lib\hb\pocc
rem set LIB_HRB=lib\win\pocc
rem set BIN_HRB=bin\win\pocc

rem *** Set GT and Check for Debug Switch ***
set HG_USE_GT=gtwin
for %%a in ( %2 %3 %4 %5 %6 %7 %8 %9 %9 ) do if "%%a"=="/d" goto DEBUG_COMP
for %%a in ( %2 %3 %4 %5 %6 %7 %8 %9 ) do if "%%a"=="/D" goto DEBUG_COMP

rem *** Set GT and Compile with Harbour ***
if exist %HG_HRB%\%LIB_HRB%\gtgui.lib set HG_USE_GT=gtgui
%HG_HRB%\%BIN_HRB%\harbour %1.prg -n -i%HG_HRB%\include;%HG_ROOT%\include; %2 %3

goto C_COMP


:DEBUG_COMP
rem *** Compile with Harbour Using -b Option ***
ECHO OPTIONS NORUNATSTARTUP > INIT.CLD
%HG_HRB%\%BIN_HRB%\harbour %1.prg -n -b -i%HG_HRB%\include;%HG_ROOT%\include; %2 %3


:C_COMP
rem *** Check for Errors in Harbour Compilation ***
if errorlevel 1 goto EXIT1

rem *** Compile with PC and Check for Errors ***
%HG_PC%\bin\pocc /Ze /Zx /Go /Tx86-coff /I%hg_pc%\include /I%hg_pc%\include\Win /I%hg_hrb%\include /I%hg_root%\include /D__WIN32__ %1.c
if errorlevel 1 goto EXIT2

rem *** Process Resource File and Check for Errors ***
if exist %1.rc %HG_PC%\bin\porc /Fo%1.res %1.rc
if errorlevel 1 goto EXIT3

rem *** Build Response File ***
echo /OUT:%1.exe > pc.lnk
echo /FORCE:MULTIPLE >> pc.lnk
echo /LIBPATH:%HG_PC%\lib >> pc.lnk
echo /LIBPATH:%HG_PC%\lib\win >> pc.lnk
echo %1.obj >> pc.lnk
echo %HG_ROOT%\%LIB_GUI%\oohg.lib >> pc.lnk

rem *** Compiler libraries ***
for %%a in (rtl vm %HG_USE_GT% lang codepage macro rdd dbfntx dbfcdx dbffpt common debug pp) do echo %HG_HRB%\lib\%%a.lib >> pc.lnk

rem *** Harbour-dependant Libraries ***
if exist %HG_HRB%\%LIB_HRB%\dbfdbt.lib     echo %HG_HRB%\%LIB_HRB%\dbfdbt.lib >> pc.lnk
if exist %HG_HRB%\%LIB_HRB%\hbsix.lib      echo %HG_HRB%\%LIB_HRB%\hbsix.lib >> pc.lnk
if exist %HG_HRB%\%LIB_HRB%\tip.lib        echo %HG_HRB%\%LIB_HRB%\tip.lib >> pc.lnk
if exist %HG_HRB%\%LIB_HRB%\ct.lib         echo %HG_HRB%\%LIB_HRB%\ct.lib >> pc.lnk
if exist %HG_HRB%\%LIB_HRB%\hsx.lib        echo %HG_HRB%\%LIB_HRB%\hsx.lib >> pc.lnk
if exist %HG_HRB%\%LIB_HRB%\pcrepos.lib    echo %HG_HRB%\%LIB_HRB%\pcrepos.lib >> pc.lnk

rem *** Additional Libraries ***
if exist %HG_HRB%\%LIB_HRB%\libct.lib      echo %HG_HRB%\%LIB_HRB%\libct.lib >> pc.lnk
if exist %HG_HRB%\%LIB_HRB%\libmisc.lib    echo %HG_HRB%\%LIB_HRB%\libmisc.lib >> pc.lnk
if exist %HG_HRB%\%LIB_HRB%\hboleaut.lib   echo %HG_HRB%\%LIB_HRB%\hboleaut.lib >> pc.lnk
if exist %HG_HRB%\%LIB_HRB%\dll.lib        echo %HG_HRB%\%LIB_HRB%\dll.lib >> pc.lnk

rem *** "Related" Libraries ***
if exist %HG_HRB%\%LIB_HRB%\socket.lib     echo %HG_HRB%\%LIB_HRB%\socket.lib >> pc.lnk
if exist %HG_ROOT%\%LIB_GUI%\socket.lib    echo %HG_ROOT%\%LIB_GUI%\socket.lib >> pc.lnk
if exist %HG_ROOT%\%LIB_GUI%\hbprinter.lib echo %HG_ROOT%\%LIB_GUI%\hbprinter.lib >> pc.lnk
if exist %HG_ROOT%\%LIB_GUI%\miniprint.lib echo %HG_ROOT%\%LIB_GUI%\miniprint.lib >> pc.lnk

rem *** ODBC Libraries ***
for %%a in ( %2 %3 %4 %5 %6 %7 %8 %9 ) do if "%%a"=="/o" echo %HG_HRB%\%LIB_HRB%\hbodbc.lib >> pc.lnk
for %%a in ( %2 %3 %4 %5 %6 %7 %8 %9 ) do if "%%a"=="/o" echo %HG_HRB%\%LIB_HRB%\odbc32.lib >> pc.lnk
for %%a in ( %2 %3 %4 %5 %6 %7 %8 %9 ) do if "%%a"=="/O" echo %HG_HRB%\%LIB_HRB%\hbodbc.lib >> pc.lnk
for %%a in ( %2 %3 %4 %5 %6 %7 %8 %9 ) do if "%%a"=="/O" echo %HG_HRB%\%LIB_HRB%\odbc32.lib >> pc.lnk

rem *** ZIP Libraries ***
for %%a in ( %2 %3 %4 %5 %6 %7 %8 %9 ) do if "%%a"=="/z" echo %HG_HRB%\%LIB_HRB%\zlib1.lib >> pc.lnk
for %%a in ( %2 %3 %4 %5 %6 %7 %8 %9 ) do if "%%a"=="/z" echo %HG_HRB%\%LIB_HRB%\ziparchive.lib >> pc.lnk
for %%a in ( %2 %3 %4 %5 %6 %7 %8 %9 ) do if "%%a"=="/Z" echo %HG_HRB%\%LIB_HRB%\zlib1.lib >> pc.lnk
for %%a in ( %2 %3 %4 %5 %6 %7 %8 %9 ) do if "%%a"=="/Z" echo %HG_HRB%\%LIB_HRB%\ziparchive.lib >> pc.lnk

rem *** ADS Libraries ***
for %%a in ( %2 %3 %4 %5 %6 %7 %8 %9 ) do if "%%a"=="/a" echo %HG_HRB%\%LIB_HRB%\rddads.lib >> pc.lnk
for %%a in ( %2 %3 %4 %5 %6 %7 %8 %9 ) do if "%%a"=="/a" echo %HG_HRB%\%LIB_HRB%\ace32.lib >> pc.lnk
for %%a in ( %2 %3 %4 %5 %6 %7 %8 %9 ) do if "%%a"=="/A" echo %HG_HRB%\%LIB_HRB%\rddads.lib >> pc.lnk
for %%a in ( %2 %3 %4 %5 %6 %7 %8 %9 ) do if "%%a"=="/A" echo %HG_HRB%\%LIB_HRB%\ace32.lib >> pc.lnk

rem *** MySql Libraries ***
for %%a in ( %2 %3 %4 %5 %6 %7 %8 %9 ) do if "%%a"=="/m" echo %HG_HRB%\%LIB_HRB%\mysql.lib >> pc.lnk
for %%a in ( %2 %3 %4 %5 %6 %7 %8 %9 ) do if "%%a"=="/m" echo %HG_HRB%\%LIB_HRB%\libmysqldll.lib >> pc.lnk
for %%a in ( %2 %3 %4 %5 %6 %7 %8 %9 ) do if "%%a"=="/M" echo %HG_HRB%\%LIB_HRB%\mysql.lib >> pc.lnk
for %%a in ( %2 %3 %4 %5 %6 %7 %8 %9 ) do if "%%a"=="/M" echo %HG_HRB%\%LIB_HRB%\libmysqldll.lib >> pc.lnk

rem *** PC-dependant Libraries ***
for %%a in (crt kernel32 winspool user32 advapi32 ole32 uuid oleaut32 mpr) do echo %%a.lib >> pc.lnk
for %%a in (comdlg32 comctl32 gdi32 olepro32 shell32 winmm vfw32 wsock32) do echo %%a.lib >> pc.lnk

rem *** Resource Files ***
if exist %1.res echo %1.res >> pc.lnk
if exist %HG_ROOT%\resources\hbprinter.res echo %HG_ROOT%\resources\hbprinter.res >> pc.lnk
if exist %HG_ROOT%\resources\miniprint.res echo %HG_ROOT%\resources\miniprint.res >> pc.lnk
if exist %HG_ROOT%\resources\oohg.res      echo %HG_ROOT%\resources\oohg.res >> pc.lnk

rem *** Check for Debug Switch ***
for %%a in ( %2 %3 %4 %5 %6 %7 %8 %9 ) do if "%%a"=="/d" goto DEBUG_LINK
for %%a in ( %2 %3 %4 %5 %6 %7 %8 %9 ) do if "%%a"=="/D" goto DEBUG_LINK

rem *** Link ***
%HG_PC%\bin\polink /SUBSYSTEM:WINDOWS @pc.lnk

goto CLEANUP


:DEBUG_LINK
rem *** Link ***
%HG_PC%\bin\polink /SUBSYSTEM:CONSOLE @pc.lnk

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
del pc.lnk
if exist %1.res del %1.res
set HG_USE_GT=

rem *** Execute ***
%1
goto EXIT


:EXIT4
rem *** Cleanup ***
del pc.lnk
del %1.obj


:EXIT3
rem *** Cleanup ***
if exist %1.res del %1.res


:EXIT2
rem *** Cleanup ***
del %1.c


:EXIT1
rem *** Cleanup ***
set HG_USE_GT=


:EXIT
if exist init.cld del init.cld
