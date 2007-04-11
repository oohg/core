@echo off
rem
rem $Id: compile_pc.bat,v 1.3 2007-04-11 14:30:20 guerra000 Exp $
rem
cls

Rem Set Paths 

IF "%HG_PC%"==""   SET HG_PC=c:\pellesc
IF "%HG_ROOT%"=="" SET HG_ROOT=c:\oohg
IF "%HG_HRB%"==""  SET HG_HRB=c:\oohg\harbour

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

%HG_PC%\bin\pocc /Ze /Zx /Go /Tx86-coff /I%hg_pc%\include /I%hg_pc%\include\Win /I%hg_hrb%\include /D__WIN32__ %1.c

if errorlevel 1 goto exit2

if exist %1.rc %HG_PC%\bin\porc /Fo%1.res %1.rc
if errorlevel 1 goto exit3

echo /OUT:%1.exe > pc.lnk
echo /FORCE:MULTIPLE >> pc.lnk
echo /LIBPATH:%HG_PC%\lib >> pc.lnk
echo /LIBPATH:%HG_PC%\lib\win >> pc.lnk
echo %1.obj >> pc.lnk
echo %HG_ROOT%\lib\oohg.lib >> pc.lnk

Rem *** Compiler libraries ***
for %%a in (rtl vm %HG_USE_GT% lang codepage macro rdd dbfntx dbfcdx dbffpt common debug pp) do echo %HG_HRB%\lib\%%a.lib >> pc.lnk

Rem *** Compiler-dependant libraries ***
if exist %HG_HRB%\lib\dbfdbt.lib  echo %HG_HRB%\lib\dbfdbt.lib >> pc.lnk
if exist %HG_HRB%\lib\hbsix.lib   echo %HG_HRB%\lib\hbsix.lib >> pc.lnk
if exist %HG_HRB%\lib\tip.lib     echo %HG_HRB%\lib\tip.lib >> pc.lnk
if exist %HG_HRB%\lib\ct.lib      echo %HG_HRB%\lib\ct.lib >> pc.lnk
if exist %HG_HRB%\lib\hsx.lib     echo %HG_HRB%\lib\hsx.lib >> pc.lnk
if exist %HG_HRB%\lib\pcrepos.lib echo %HG_HRB%\lib\pcrepos.lib >> pc.lnk

Rem *** Additional libraries ***
if exist %HG_HRB%\lib\libct.lib   echo %HG_HRB%\lib\libct.lib >> pc.lnk
if exist %HG_HRB%\lib\libmisc.lib echo %HG_HRB%\lib\libmisc.lib >> pc.lnk
if exist %HG_HRB%\lib\hbole.lib   echo %HG_HRB%\lib\hbole.lib >> pc.lnk
if exist %HG_HRB%\lib\dll.lib     echo %HG_HRB%\lib\dll.lib >> pc.lnk

Rem *** "Related" libraries ***
if exist %HG_HRB%\lib\socket.lib     echo %HG_HRB%\lib\socket.lib >> pc.lnk
if exist %HG_ROOT%\lib\socket.lib    echo %HG_ROOT%\lib\socket.lib >> pc.lnk
if exist %HG_ROOT%\lib\hbprinter.lib echo %HG_ROOT%\lib\hbprinter.lib >> pc.lnk
if exist %HG_ROOT%\lib\miniprint.lib echo %HG_ROOT%\lib\miniprint.lib >> pc.lnk

Rem *** ODBC Libraries Link ***
for %%a in ( %2 %3 %4 %5 %6 %7 %8 ) do if "%%a"=="/o" echo %HG_HRB%\lib\hbodbc.lib >> pc.lnk
for %%a in ( %2 %3 %4 %5 %6 %7 %8 ) do if "%%a"=="/o" echo %HG_HRB%\lib\odbc32.lib >> pc.lnk
for %%a in ( %2 %3 %4 %5 %6 %7 %8 ) do if "%%a"=="/O" echo %HG_HRB%\lib\hbodbc.lib >> pc.lnk
for %%a in ( %2 %3 %4 %5 %6 %7 %8 ) do if "%%a"=="/O" echo %HG_HRB%\lib\odbc32.lib >> pc.lnk

Rem *** ZIP Libraries Linking ***
for %%a in ( %2 %3 %4 %5 %6 %7 %8 ) do if "%%a"=="/z" echo %HG_HRB%\lib\zlib1.lib >> pc.lnk
for %%a in ( %2 %3 %4 %5 %6 %7 %8 ) do if "%%a"=="/z" echo %HG_HRB%\lib\ziparchive.lib >> pc.lnk
for %%a in ( %2 %3 %4 %5 %6 %7 %8 ) do if "%%a"=="/Z" echo %HG_HRB%\lib\zlib1.lib >> pc.lnk
for %%a in ( %2 %3 %4 %5 %6 %7 %8 ) do if "%%a"=="/Z" echo %HG_HRB%\lib\ziparchive.lib >> pc.lnk

Rem *** ADS Libraries Linking ***
for %%a in ( %2 %3 %4 %5 %6 %7 %8 ) do if "%%a"=="/a" echo %HG_HRB%\lib\rddads.lib >> pc.lnk
for %%a in ( %2 %3 %4 %5 %6 %7 %8 ) do if "%%a"=="/a" echo %HG_HRB%\lib\ace32.lib >> pc.lnk
for %%a in ( %2 %3 %4 %5 %6 %7 %8 ) do if "%%a"=="/A" echo %HG_HRB%\lib\rddads.lib >> pc.lnk
for %%a in ( %2 %3 %4 %5 %6 %7 %8 ) do if "%%a"=="/A" echo %HG_HRB%\lib\ace32.lib >> pc.lnk

Rem *** MySql Libraries Linking ***
for %%a in ( %2 %3 %4 %5 %6 %7 %8 ) do if "%%a"=="/m" echo %HG_HRB%\lib\mysql.lib >> pc.lnk
for %%a in ( %2 %3 %4 %5 %6 %7 %8 ) do if "%%a"=="/m" echo %HG_HRB%\lib\libmysqldll.lib >> pc.lnk
for %%a in ( %2 %3 %4 %5 %6 %7 %8 ) do if "%%a"=="/M" echo %HG_HRB%\lib\mysql.lib >> pc.lnk
for %%a in ( %2 %3 %4 %5 %6 %7 %8 ) do if "%%a"=="/M" echo %HG_HRB%\lib\libmysqldll.lib >> pc.lnk

Rem *** PellesC libraries ***
for %%a in (crt kernel32 winspool user32 advapi32 ole32 uuid oleaut32 mpr) do echo %%a.lib >> pc.lnk
for %%a in (comdlg32 comctl32 gdi32 olepro32 shell32 winmm vfw32) do echo %%a.lib >> pc.lnk

if exist %1.res echo %1.res >> pc.lnk
if exist %HG_ROOT%\resources\hbprinter.res echo %HG_ROOT%\resources\hbprinter.res >> pc.lnk
if exist %HG_ROOT%\resources\miniprint.res echo %HG_ROOT%\resources\miniprint.res >> pc.lnk
if exist %HG_ROOT%\resources\oohg.res      echo %HG_ROOT%\resources\oohg.res >> pc.lnk

Rem Debug Link

for %%a in ( %2 %3 %4 %5 %6 %7 %8 ) do if "%%a"=="/d" GOTO DEBUG_LINK
for %%a in ( %2 %3 %4 %5 %6 %7 %8 ) do if "%%a"=="/D" GOTO DEBUG_LINK

%HG_PC%\bin\polink /SUBSYSTEM:WINDOWS @pc.lnk

GOTO CLEANUP

:DEBUG_LINK

%HG_PC%\bin\polink /SUBSYSTEM:CONSOLE @pc.lnk

:CLEANUP

if errorlevel 1 goto exit4

del %1.c
del %1.obj
del pc.lnk
if exist %1.res del %1.res
%1
goto exit1

:EXIT4
rem del pc.lnk
del %1.obj

:EXIT3
if exist %1.res del %1.res

:EXIT2
del %1.c

:EXIT1
