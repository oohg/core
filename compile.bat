@echo off
CLS

Rem Set Paths 

SET MG_BCC=c:\borland\bcc55
SET MG_ROOT=c:\minioop
SET MG_HRB=c:\miniexp\harbour

if exist %1.exe del %1.exe

Rem Debug Compile

if "%2"=="/d" GOTO DEBUG_COMP
if "%2"=="/D" GOTO DEBUG_COMP
if "%3"=="/d" GOTO DEBUG_COMP
if "%3"=="/D" GOTO DEBUG_COMP
if "%4"=="/d" GOTO DEBUG_COMP
if "%4"=="/D" GOTO DEBUG_COMP
if "%5"=="/d" GOTO DEBUG_COMP
if "%5"=="/D" GOTO DEBUG_COMP
if "%6"=="/d" GOTO DEBUG_COMP
if "%6"=="/D" GOTO DEBUG_COMP

%MG_HRB%\bin\harbour %1.prg -n -i%MG_HRB%\include;%MG_ROOT%\include; %2 %3

GOTO C_COMP

:DEBUG_COMP

ECHO OPTIONS NORUNATSTARTUP > INIT.CLD

%MG_HRB%\bin\harbour %1.prg -n -b -i%MG_HRB%\include;%MG_ROOT%\include; %2 %3

:C_COMP

%MG_BCC%\bin\bcc32 -c -M -O2 -tW -I%MG_HRB%\include;%MG_BCC%\include; -L%MG_BCC%\lib; %1.c

if exist %1.rc %MG_BCC%\bin\brc32 -r %1.rc

echo c0w32.obj + > b32.bc
echo %1.obj, + >> b32.bc
echo %1.exe, + >> b32.bc
echo %1.map, + >> b32.bc

echo %MG_HRB%\lib\socket.lib + >> b32.bc
echo %MG_ROOT%\lib\oohg.lib + >> b32.bc
echo %MG_HRB%\lib\dll.lib + >> b32.bc
echo %MG_HRB%\lib\rtl.lib + >> b32.bc
echo %MG_HRB%\lib\vm.lib + >> b32.bc
echo %MG_HRB%\lib\gtwin.lib + >> b32.bc
echo %MG_HRB%\lib\lang.lib + >> b32.bc
echo %MG_HRB%\lib\codepage.lib + >> b32.bc
echo %MG_HRB%\lib\macro.lib + >> b32.bc
echo %MG_HRB%\lib\rdd.lib + >> b32.bc
echo %MG_HRB%\lib\dbfntx.lib + >> b32.bc
echo %MG_HRB%\lib\dbfcdx.lib + >> b32.bc
rem echo %MG_HRB%\lib\dbfdbt.lib + >> b32.bc
echo %MG_HRB%\lib\dbffpt.lib + >> b32.bc
echo %MG_HRB%\lib\hsx.lib + >> b32.bc
echo %MG_HRB%\lib\hbsix.lib + >> b32.bc
echo %MG_HRB%\lib\common.lib + >> b32.bc
echo %MG_HRB%\lib\debug.lib + >> b32.bc
echo %MG_HRB%\lib\pp.lib + >> b32.bc
echo %MG_HRB%\lib\libct.lib + >> b32.bc
echo %MG_HRB%\lib\libmisc.lib + >> b32.bc
echo %MG_HRB%\lib\hbole.lib + >> b32.bc
echo %MG_ROOT%\lib\hbprinter.lib + >> b32.bc
echo %MG_ROOT%\lib\miniprint.lib + >> b32.bc


Rem ODBC Libraries Link

if "%2"=="/O" echo %MG_HRB%\lib\hbodbc.lib + >> b32.bc
if "%2"=="/O" echo %MG_HRB%\lib\odbc32.lib + >> b32.bc
if "%2"=="/o" echo %MG_HRB%\lib\hbodbc.lib + >> b32.bc
if "%2"=="/o" echo %MG_HRB%\lib\odbc32.lib + >> b32.bc

if "%3"=="/O" echo %MG_HRB%\lib\hbodbc.lib + >> b32.bc
if "%3"=="/O" echo %MG_HRB%\lib\odbc32.lib + >> b32.bc
if "%3"=="/o" echo %MG_HRB%\lib\hbodbc.lib + >> b32.bc
if "%3"=="/o" echo %MG_HRB%\lib\odbc32.lib + >> b32.bc

if "%4"=="/O" echo %MG_HRB%\lib\hbodbc.lib + >> b32.bc
if "%4"=="/O" echo %MG_HRB%\lib\odbc32.lib + >> b32.bc
if "%4"=="/o" echo %MG_HRB%\lib\hbodbc.lib + >> b32.bc
if "%4"=="/o" echo %MG_HRB%\lib\odbc32.lib + >> b32.bc

if "%5"=="/O" echo %MG_HRB%\lib\hbodbc.lib + >> b32.bc
if "%5"=="/O" echo %MG_HRB%\lib\odbc32.lib + >> b32.bc
if "%5"=="/o" echo %MG_HRB%\lib\hbodbc.lib + >> b32.bc
if "%5"=="/o" echo %MG_HRB%\lib\odbc32.lib + >> b32.bc

if "%6"=="/O" echo %MG_HRB%\lib\hbodbc.lib + >> b32.bc
if "%6"=="/O" echo %MG_HRB%\lib\odbc32.lib + >> b32.bc
if "%6"=="/o" echo %MG_HRB%\lib\hbodbc.lib + >> b32.bc
if "%6"=="/o" echo %MG_HRB%\lib\odbc32.lib + >> b32.bc

Rem ZIP Libraries Linking

if "%2"=="/Z" echo %MG_HRB%\lib\zlib1.lib + >> b32.bc
if "%2"=="/Z" echo %MG_HRB%\lib\ziparchive.lib + >> b32.bc
if "%2"=="/z" echo %MG_HRB%\lib\zlib1.lib + >> b32.bc
if "%2"=="/z" echo %MG_HRB%\lib\ziparchive.lib + >> b32.bc

if "%3"=="/Z" echo %MG_HRB%\lib\zlib1.lib + >> b32.bc
if "%3"=="/Z" echo %MG_HRB%\lib\ziparchive.lib + >> b32.bc
if "%3"=="/z" echo %MG_HRB%\lib\zlib1.lib + >> b32.bc
if "%3"=="/z" echo %MG_HRB%\lib\ziparchive.lib + >> b32.bc

if "%4"=="/Z" echo %MG_HRB%\lib\zlib1.lib + >> b32.bc
if "%4"=="/Z" echo %MG_HRB%\lib\ziparchive.lib + >> b32.bc
if "%4"=="/z" echo %MG_HRB%\lib\zlib1.lib + >> b32.bc
if "%4"=="/z" echo %MG_HRB%\lib\ziparchive.lib + >> b32.bc

if "%5"=="/Z" echo %MG_HRB%\lib\zlib1.lib + >> b32.bc
if "%5"=="/Z" echo %MG_HRB%\lib\ziparchive.lib + >> b32.bc
if "%5"=="/z" echo %MG_HRB%\lib\zlib1.lib + >> b32.bc
if "%5"=="/z" echo %MG_HRB%\lib\ziparchive.lib + >> b32.bc

if "%6"=="/Z" echo %MG_HRB%\lib\zlib1.lib + >> b32.bc
if "%6"=="/Z" echo %MG_HRB%\lib\ziparchive.lib + >> b32.bc
if "%6"=="/z" echo %MG_HRB%\lib\zlib1.lib + >> b32.bc
if "%6"=="/z" echo %MG_HRB%\lib\ziparchive.lib + >> b32.bc

Rem ADS Libraries Linking

if "%2"=="/A" echo %MG_HRB%\lib\rddads.lib + >> b32.bc
if "%2"=="/A" echo %MG_HRB%\lib\ace32.lib + >> b32.bc
if "%2"=="/a" echo %MG_HRB%\lib\rddads.lib + >> b32.bc
if "%2"=="/a" echo %MG_HRB%\lib\ace32.lib + >> b32.bc

if "%3"=="/A" echo %MG_HRB%\lib\rddads.lib + >> b32.bc
if "%3"=="/A" echo %MG_HRB%\lib\ace32.lib + >> b32.bc
if "%3"=="/a" echo %MG_HRB%\lib\rddads.lib + >> b32.bc
if "%3"=="/a" echo %MG_HRB%\lib\ace32.lib + >> b32.bc

if "%4"=="/A" echo %MG_HRB%\lib\rddads.lib + >> b32.bc
if "%4"=="/A" echo %MG_HRB%\lib\ace32.lib + >> b32.bc
if "%4"=="/a" echo %MG_HRB%\lib\rddads.lib + >> b32.bc
if "%4"=="/a" echo %MG_HRB%\lib\ace32.lib + >> b32.bc

if "%5"=="/A" echo %MG_HRB%\lib\rddads.lib + >> b32.bc
if "%5"=="/A" echo %MG_HRB%\lib\ace32.lib + >> b32.bc
if "%5"=="/a" echo %MG_HRB%\lib\rddads.lib + >> b32.bc
if "%5"=="/a" echo %MG_HRB%\lib\ace32.lib + >> b32.bc

if "%6"=="/A" echo %MG_HRB%\lib\rddads.lib + >> b32.bc
if "%6"=="/A" echo %MG_HRB%\lib\ace32.lib + >> b32.bc
if "%6"=="/a" echo %MG_HRB%\lib\rddads.lib + >> b32.bc
if "%6"=="/a" echo %MG_HRB%\lib\ace32.lib + >> b32.bc

Rem MySql Libraries Linking

if "%2"=="/M" echo %MG_HRB%\lib\mysql.lib + >> b32.bc
if "%2"=="/M" echo %MG_HRB%\lib\libmysql.lib + >> b32.bc
if "%2"=="/m" echo %MG_HRB%\lib\mysql.lib + >> b32.bc
if "%2"=="/m" echo %MG_HRB%\lib\libmysql.lib + >> b32.bc

if "%3"=="/M" echo %MG_HRB%\lib\mysql.lib + >> b32.bc
if "%3"=="/M" echo %MG_HRB%\lib\libmysql.lib + >> b32.bc
if "%3"=="/m" echo %MG_HRB%\lib\mysql.lib + >> b32.bc
if "%3"=="/m" echo %MG_HRB%\lib\libmysql.lib + >> b32.bc

if "%4"=="/M" echo %MG_HRB%\lib\mysql.lib + >> b32.bc
if "%4"=="/M" echo %MG_HRB%\lib\libmysql.lib + >> b32.bc
if "%4"=="/m" echo %MG_HRB%\lib\mysql.lib + >> b32.bc
if "%4"=="/m" echo %MG_HRB%\lib\libmysql.lib + >> b32.bc

if "%5"=="/M" echo %MG_HRB%\lib\mysql.lib + >> b32.bc
if "%5"=="/M" echo %MG_HRB%\lib\libmysql.lib + >> b32.bc
if "%5"=="/m" echo %MG_HRB%\lib\mysql.lib + >> b32.bc
if "%5"=="/m" echo %MG_HRB%\lib\libmysql.lib + >> b32.bc

if "%6"=="/M" echo %MG_HRB%\lib\mysql.lib + >> b32.bc
if "%6"=="/M" echo %MG_HRB%\lib\libmysql.lib + >> b32.bc
if "%6"=="/m" echo %MG_HRB%\lib\mysql.lib + >> b32.bc
if "%6"=="/m" echo %MG_HRB%\lib\libmysql.lib + >> b32.bc

echo cw32.lib + >> b32.bc
echo import32.lib, >> b32.bc

if exist %1.res echo %1.res + >> b32.bc
if exist %MG_ROOT%\resources\hbprinter.res echo %MG_ROOT%\resources\hbprinter.res + >> b32.bc
if exist %MG_ROOT%\resources\miniprint.res echo %MG_ROOT%\resources\miniprint.res + >> b32.bc
echo %MG_ROOT%\resources\minigui.res >> b32.bc

Rem Debug Link

if "%2"=="/d" GOTO DEBUG_LINK
if "%2"=="/D" GOTO DEBUG_LINK
if "%3"=="/d" GOTO DEBUG_LINK
if "%3"=="/D" GOTO DEBUG_LINK
if "%4"=="/d" GOTO DEBUG_LINK
if "%4"=="/D" GOTO DEBUG_LINK
if "%5"=="/d" GOTO DEBUG_LINK
if "%5"=="/D" GOTO DEBUG_LINK
if "%6"=="/d" GOTO DEBUG_LINK
if "%6"=="/D" GOTO DEBUG_LINK

%MG_BCC%\bin\ilink32 -Gn -Tpe -aa -L%MG_BCC%\lib; @b32.bc

GOTO CLEANUP

:DEBUG_LINK

%MG_BCC%\bin\ilink32 -Gn -Tpe -ap -L%MG_BCC%\lib; @b32.bc

:CLEANUP

del *.tds
del %1.c
del %1.map
del %1.obj
del b32.bc
rem if exist %1.res del %1.res
%1



