@echo off
rem
rem $Id: compile.bat,v 1.2 2015-03-18 23:58:18 fyurisich Exp $
rem

if /I not "%1%"=="/NOCLS" cls
if /I not "%1%"=="/NOCLS" shift

if exist mgide.rc goto PATH
echo This file must be executed from IDE folder !!!
echo.
goto EXIT

:PATH
if /I "%1"=="/C" goto CLEAN_PATH
if "%HG_ROOT%"=="" set HG_ROOT=c:\oohg
if "%HG_HRB%"==""  set HG_HRB=c:\xhbcc
if "%HG_BCC%"==""  set HG_BCC=c:\Borland\BCC55
if "%LIB_GUI%"=="" set LIB_GUI=lib\xhb\bcc
if "%LIB_HRB%"=="" set LIB_HRB=lib
if "%BIN_HRB%"=="" set BIN_HRB=bin
goto CLEAN_EXE

:ERREXIT1
echo COMPILE ERROR: IS OIDE.EXE RUNNING ?
goto EXIT

:CLEAN_PATH
set HG_ROOT=c:\oohg
set HG_HRB=c:\xhbcc
set HG_BCC=c:\Borland\BCC55
set LIB_GUI=lib\xhb\bcc
set LIB_HRB=lib
set BIN_HRB=bin
shift

:CLEAN_EXE
if exist oide.exe del oide.exe
if exist oide.exe goto ERREXIT1

:RESOURCES
echo BRC32: Compiling resources...
md auxdir
cd auxdir
xcopy %HG_ROOT%\resources\*.* /q > nul
md imgs
cd imgs
xcopy ..\..\imgs\*.* /q > nul
cd ..
copy /b oohg_bcc.rc + ..\mgide.rc oide.rc /y > nul
%HG_BCC%\bin\brc32 -r oide.rc > nul
copy oide.res .. /y > nul
cd ..
rd auxdir /s /q

:COMPILE
echo Harbour: Compiling sources...
%HG_HRB%\%BIN_HRB%\harbour prgs\mgide prgs\dbucvc prgs\formedit prgs\menued prgs\toolbed -q0 -n -i%HG_HRB%\include;%HG_ROOT%\include;fmgs
echo BCC32: Compiling...
%HG_BCC%\bin\bcc32 -c -O2 -tW -M -I%HG_HRB%\include;%HG_BCC%\include;%HG_ROOT%\include; -L%HG_BCC%\lib; mgide.c > nul
%HG_BCC%\bin\bcc32 -c -O2 -tW -M -I%HG_HRB%\include;%HG_BCC%\include;%HG_ROOT%\include; -L%HG_BCC%\lib; dbucvc.c > nul
%HG_BCC%\bin\bcc32 -c -O2 -tW -M -I%HG_HRB%\include;%HG_BCC%\include;%HG_ROOT%\include; -L%HG_BCC%\lib; formedit.c > nul
%HG_BCC%\bin\bcc32 -c -O2 -tW -M -I%HG_HRB%\include;%HG_BCC%\include;%HG_ROOT%\include; -L%HG_BCC%\lib; menued.c > nul
%HG_BCC%\bin\bcc32 -c -O2 -tW -M -I%HG_HRB%\include;%HG_BCC%\include;%HG_ROOT%\include; -L%HG_BCC%\lib; toolbed.c > nul

:LINK
echo ILINK32: Linking... oide.exe
echo c0w32.obj + > b32.bc
echo mgide.obj dbucvc.obj formedit.obj menued.obj toolbed.obj, + >> b32.bc
echo oide.exe, + >> b32.bc
echo oide.map, + >> b32.bc
echo %HG_ROOT%\%LIB_GUI%\oohg.lib + >> b32.bc
for %%a in ( rtl vm gtgui lang codepage macro rdd dbfntx dbfcdx dbffpt common debug pp ct dbfdbt hbsix tip hsx xhb ) do if exist %HG_HRB%\%LIB_HRB%\%%a.lib echo %HG_HRB%\%LIB_HRB%\%%a.lib + >> b32.bc
for %%a in ( hbrtl hbvm hblang hbcpage hbmacro hbrdd rddntx rddcdx rddfpt hbcommon hbdebug hbpp hbct hbwin pcrepos ) do if exist %HG_HRB%\%LIB_HRB%\%%a.lib echo %HG_HRB%\%LIB_HRB%\%%a.lib + >> b32.bc
if exist %HG_HRB%\%LIB_HRB%\libmisc.lib    echo %HG_HRB%\%LIB_HRB%\libmisc.lib + >> b32.bc
if exist %HG_HRB%\%LIB_HRB%\hboleaut.lib   echo %HG_HRB%\%LIB_HRB%\hboleaut.lib + >> b32.bc
if exist %HG_HRB%\%LIB_HRB%\dll.lib        echo %HG_HRB%\%LIB_HRB%\dll.lib + >> b32.bc
if exist %HG_HRB%\%LIB_HRB%\socket.lib     echo %HG_HRB%\%LIB_HRB%\socket.lib + >> b32.bc
if exist %HG_ROOT%\%LIB_GUI%\socket.lib    echo %HG_ROOT%\%LIB_GUI%\socket.lib + >> b32.bc
if exist %HG_ROOT%\%LIB_GUI%\hbprinter.lib echo %HG_ROOT%\%LIB_GUI%\hbprinter.lib + >> b32.bc
if exist %HG_ROOT%\%LIB_GUI%\miniprint.lib echo %HG_ROOT%\%LIB_GUI%\miniprint.lib + >> b32.bc
echo cw32.lib + >> b32.bc
echo msimg32.lib + >> b32.bc
echo import32.lib, , + >> b32.bc
echo oide.res + >> b32.bc
%HG_BCC%\bin\ilink32 -Gn -Tpe -aa -L%HG_BCC%\lib;%HG_BCC%\lib\psdk; @b32.bc > nul

:CLEAN
del *.tds
del *.c
del *.map
del *.obj
del b32.bc
del *.res

:EXIT
