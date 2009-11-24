@echo off
rem
rem $Id: compile_vc.bat,v 1.1 2009-11-24 02:55:18 guerra000 Exp $
rem
cls

Rem Set Paths

IF "%HG_VC%"==""   SET HG_VC=%Program Files%\Microsoft Visual Studio 9.0\vc
IF "%HG_ROOT%"=="" SET HG_ROOT=C:\OOHG
IF "%HG_HRB%"==""  SET HG_HRB=C:\OOHG\HARBOUR

if exist %1.exe del %1.exe
SET HG_USE_GT=gtwin

Rem Debug Compile

for %%a in ( %2 %3 %4 %5 %6 %7 %8 ) do if "%%a"=="/d" GOTO DEBUG_COMP
for %%a in ( %2 %3 %4 %5 %6 %7 %8 ) do if "%%a"=="/D" GOTO DEBUG_COMP

if exist %HG_HRB%\lib\gtgui.lib SET HG_USE_GT=gtgui
%HG_HRB%\bin\harbour %1.prg -n -i%HG_HRB%\include;%HG_ROOT%\include; %2 %3

GOTO C_COMP

:DEBUG_COMP

ECHO OPTIONS NORUNATSTARTUP > INIT.CLD

%HG_HRB%\bin\harbour %1.prg -n -b -i%HG_HRB%\include;%HG_ROOT%\include; %2 %3

:C_COMP

if errorlevel 1 goto exit1

SET _PATH=%PATH%
SET PATH="%HG_VC%\bin";%PATH%
IF EXIST "%HG_VC%"\vcvarsall.bat CALL "%HG_VC%"\vcvarsall.bat

cl /O2 /c /TP /I%hg_hrb%\include /I%hg_root%\include /I. /D__WIN32__ %1.c

if errorlevel 1 goto exit2

if exist %1.rc rc /Fo%1.res %1.rc
if errorlevel 1 goto exit3

echo /OUT:%1.exe > vc.lnk
echo /FORCE:MULTIPLE >> vc.lnk
echo /INCLUDE:__matherr >> vc.lnk
echo %1.obj >> vc.lnk
echo %HG_ROOT%\lib\oohg.lib >> vc.lnk

Rem *** Compiler libraries ***
for %%a in (rtl vm %HG_USE_GT% lang codepage macro rdd dbfntx dbfcdx dbffpt common debug pp) do echo %HG_HRB%\lib\%%a.lib >> vc.lnk

Rem *** Compiler-dependant libraries ***
if exist %HG_HRB%\lib\dbfdbt.lib  echo %HG_HRB%\lib\dbfdbt.lib >> vc.lnk
if exist %HG_HRB%\lib\hbsix.lib   echo %HG_HRB%\lib\hbsix.lib >> vc.lnk
if exist %HG_HRB%\lib\tip.lib     echo %HG_HRB%\lib\tip.lib >> vc.lnk
if exist %HG_HRB%\lib\ct.lib      echo %HG_HRB%\lib\ct.lib >> vc.lnk
if exist %HG_HRB%\lib\hsx.lib     echo %HG_HRB%\lib\hsx.lib >> vc.lnk
if exist %HG_HRB%\lib\pcrepos.lib echo %HG_HRB%\lib\pcrepos.lib >> vc.lnk

Rem *** Additional libraries ***
if exist %HG_HRB%\lib\libct.lib   echo %HG_HRB%\lib\libct.lib >> vc.lnk
if exist %HG_HRB%\lib\libmisc.lib echo %HG_HRB%\lib\libmisc.lib >> vc.lnk
if exist %HG_HRB%\lib\hboleaut.lib   echo %HG_HRB%\lib\hboleaut.lib >> vc.lnk
if exist %HG_HRB%\lib\dll.lib     echo %HG_HRB%\lib\dll.lib >> vc.lnk

Rem *** "Related" libraries ***
if exist %HG_HRB%\lib\socket.lib     echo %HG_HRB%\lib\socket.lib >> vc.lnk
if exist %HG_ROOT%\lib\socket.lib    echo %HG_ROOT%\lib\socket.lib >> vc.lnk
if exist %HG_ROOT%\lib\hbprinter.lib echo %HG_ROOT%\lib\hbprinter.lib >> vc.lnk
if exist %HG_ROOT%\lib\miniprint.lib echo %HG_ROOT%\lib\miniprint.lib >> vc.lnk

Rem *** ODBC Libraries Link ***
for %%a in ( %2 %3 %4 %5 %6 %7 %8 ) do if "%%a"=="/o" echo %HG_HRB%\lib\hbodbc.lib >> vc.lnk
for %%a in ( %2 %3 %4 %5 %6 %7 %8 ) do if "%%a"=="/o" echo %HG_HRB%\lib\odbc32.lib >> vc.lnk
for %%a in ( %2 %3 %4 %5 %6 %7 %8 ) do if "%%a"=="/O" echo %HG_HRB%\lib\hbodbc.lib >> vc.lnk
for %%a in ( %2 %3 %4 %5 %6 %7 %8 ) do if "%%a"=="/O" echo %HG_HRB%\lib\odbc32.lib >> vc.lnk

Rem *** ZIP Libraries Linking ***
for %%a in ( %2 %3 %4 %5 %6 %7 %8 ) do if "%%a"=="/z" echo %HG_HRB%\lib\zlib1.lib >> vc.lnk
for %%a in ( %2 %3 %4 %5 %6 %7 %8 ) do if "%%a"=="/z" echo %HG_HRB%\lib\ziparchive.lib >> vc.lnk
for %%a in ( %2 %3 %4 %5 %6 %7 %8 ) do if "%%a"=="/Z" echo %HG_HRB%\lib\zlib1.lib >> vc.lnk
for %%a in ( %2 %3 %4 %5 %6 %7 %8 ) do if "%%a"=="/Z" echo %HG_HRB%\lib\ziparchive.lib >> vc.lnk

Rem *** ADS Libraries Linking ***
for %%a in ( %2 %3 %4 %5 %6 %7 %8 ) do if "%%a"=="/a" echo %HG_HRB%\lib\rddads.lib >> vc.lnk
for %%a in ( %2 %3 %4 %5 %6 %7 %8 ) do if "%%a"=="/a" echo %HG_HRB%\lib\ace32.lib >> vc.lnk
for %%a in ( %2 %3 %4 %5 %6 %7 %8 ) do if "%%a"=="/A" echo %HG_HRB%\lib\rddads.lib >> vc.lnk
for %%a in ( %2 %3 %4 %5 %6 %7 %8 ) do if "%%a"=="/A" echo %HG_HRB%\lib\ace32.lib >> vc.lnk

Rem *** MySql Libraries Linking ***
for %%a in ( %2 %3 %4 %5 %6 %7 %8 ) do if "%%a"=="/m" echo %HG_HRB%\lib\mysql.lib >> vc.lnk
for %%a in ( %2 %3 %4 %5 %6 %7 %8 ) do if "%%a"=="/m" echo %HG_HRB%\lib\libmysqldll.lib >> vc.lnk
for %%a in ( %2 %3 %4 %5 %6 %7 %8 ) do if "%%a"=="/M" echo %HG_HRB%\lib\mysql.lib >> vc.lnk
for %%a in ( %2 %3 %4 %5 %6 %7 %8 ) do if "%%a"=="/M" echo %HG_HRB%\lib\libmysqldll.lib >> vc.lnk

Rem *** MSVC libraries ***
for %%a in (user32 ws2_32 winspool ole32 oleaut32 advapi32 winmm mpr) do echo %%a.lib >> vc.lnk
for %%a in (shell32 gdi32 comctl32 comdlg32 wsock32) do echo %%a.lib >> vc.lnk

Rem Debug Link

for %%a in ( %2 %3 %4 %5 %6 %7 %8 ) do if "%%a"=="/d" GOTO DEBUG_LINK
for %%a in ( %2 %3 %4 %5 %6 %7 %8 ) do if "%%a"=="/D" GOTO DEBUG_LINK

if exist %1.res echo %1.res >> vc.lnk
if exist %HG_ROOT%\resources\hbprinter.res echo %HG_ROOT%\resources\hbprinter.res >> vc.lnk
if exist %HG_ROOT%\resources\miniprint.res echo %HG_ROOT%\resources\miniprint.res >> vc.lnk
if exist %HG_ROOT%\resources\oohg.res      echo %HG_ROOT%\resources\oohg.res >> vc.lnk

link /SUBSYSTEM:WINDOWS @vc.lnk

GOTO CLEANUP

:DEBUG_LINK

link /SUBSYSTEM:CONSOLE @vc.lnk

:CLEANUP

if errorlevel 1 goto exit4

del %1.c
del %1.obj
del vc.lnk
if exist %1.res del %1.res
PATH %_PATH%
%1
goto exit1

:EXIT4
del vc.lnk
del %1.obj

:EXIT3
if exist %1.res del %1.res

:EXIT2
PATH %_PATH%
del %1.c

:EXIT1
