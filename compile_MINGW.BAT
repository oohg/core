@echo off
rem
rem $Id: compile_MINGW.BAT,v 1.22 2013-07-23 19:46:41 migsoft Exp $
rem
cls

if exist %1.exe del %1.exe
if exist %1.exe GOTO ERREXIT

set TPATH=%PATH%

rem default paths
set ooHG_INSTALL=c:\oohg
set HRB_DIR=c:\oohg\harbour
set MINGW=c:\oohg\mingw

set LIB_GUI=lib
set LIB_HRB=lib
set BIN_HRB=bin

rem nightly harbour paths
rem set HRB_DIR=c:\hb32
rem set MINGW=%HRB_DIR%\comp\mingw

rem set LIB_GUI=lib\hb\mingw
rem set LIB_HRB=lib\win\mingw
rem set BIN_HRB=bin\win\mingw


set PATH=%MINGW%\bin;%HRB_DIR%\%BIN_HRB%

rem third libraries
rem THR_LIB=-lsocket -lmysqldll -ldll
set THR_LIB=

echo #define oohgpath %oohg_INSTALL%\RESOURCES > %oohg_INSTALL%\RESOURCES\_oohg_resconfig.h

if exist %1.rc copy /b %ooHG_INSTALL%\resources\ooHG.rc+%1.rc+%ooHG_INSTALL%\resources\filler %ooHG_INSTALL%\resources\_temp.rc > nul
if exist %1.rc windres -i %ooHG_INSTALL%\resources\_temp.rc -o %ooHG_INSTALL%\resources\_temp.o

set EXTRA=
if "%4"=="-w3" set EXTRA=-w3

if "%3"=="/p" set EXTRA=-p
if "%3"=="/P" set EXTRA=-p
if "%3"=="-p" set EXTRA=-p
if "%3"=="-P" set EXTRA=-p

if "%3"=="-w3" set EXTRA=-w3

if "%2"=="/d" goto DEBUG_COMP
if "%2"=="/D" goto DEBUG_COMP

if "%2"=="-w3" set EXTRA=-w3

if "%2"=="/c" goto CONSOLE_COMP
if "%2"=="/C" goto CONSOLE_COMP

if "%2"=="/p" set EXTRA=-p
if "%2"=="/P" set EXTRA=-p

goto STD_COMP

:CONSOLE_COMP

%HRB_DIR%\%BIN_HRB%\harbour %1.prg -n %EXTRA% -i%HRB_DIR%\include;%ooHG_INSTALL%\include;.
rem gcc -I. -I%HRB_DIR%\include -I%ooHG_INSTALL%\include -mno-cygwin -Wall -c %1.c -o%1.o
gcc -I. -I%HRB_DIR%\include -I%ooHG_INSTALL%\include -Wall -c %1.c -o%1.o

rem if     exist %1.rc gcc -Wall -o%1.exe %1.o %ooHG_INSTALL%\resources\_temp.o                         -L%MINGW%\lib -L%HRB_DIR%\%LIB_HRB% -L%ooHG_INSTALL%\%LIB_GUI% -mno-cygwin -Wl,--start-group                 -lhbsix -lhbvm -lhbrdd -lhbmacro -lhbmemio -lhbpp -lhbrtl -lhbziparc -lhblang -lhbcommon -lhbnulrdd -lrddntx -lrddcdx -lrddfpt -lhbct -lhbmisc -lxhb -lhbodbc -lrddsql -lsddodbc -lodbc32 -lhbmysql %THR_LIB% -lhbwin -lhbcpage -lhbmzip -lminizip -lhbzlib -lhbtip -lhbpcre -luser32 -lwinspool -lcomctl32 -lcomdlg32 -lgdi32 -lole32 -loleaut32 -luuid -lwinmm -lvfw32 -lwsock32 -lws2_32 -Wl,--end-group
rem if not exist %1.rc gcc -Wall -o%1.exe %1.o %ooHG_INSTALL%\resources\ooHG.o -L%MINGW%\lib -L%HRB_DIR%\%LIB_HRB% -L%ooHG_INSTALL%\%LIB_GUI% -mno-cygwin -Wl,--start-group -lgtgui -lgtwin -lhbsix -lhbvm -lhbrdd -lhbmacro -lhbmemio -lhbpp -lhbrtl -lhbziparc -lhblang -lhbcommon -lhbnulrdd -lrddntx -lrddcdx -lrddfpt -lhbct -lhbmisc -lxhb -lhbodbc -lrddsql -lsddodbc -lodbc32 -lhbmysql %THR_LIB% -lhbwin -lhbcpage -lhbmzip -lminizip -lhbzlib -lhbtip -lhbpcre -luser32 -lwinspool -lcomctl32 -lcomdlg32 -lgdi32 -lole32 -loleaut32 -luuid -lwinmm -lvfw32 -lwsock32 -lws2_32 -Wl,--end-group

if     exist %1.rc gcc -Wall -o%1.exe %1.o %ooHG_INSTALL%\resources\_temp.o                         -L%MINGW%\lib -L%HRB_DIR%\%LIB_HRB% -L%ooHG_INSTALL%\%LIB_GUI% -Wl,--start-group                 -lhbsix -lhbvm -lhbrdd -lhbmacro -lhbmemio -lhbpp -lhbrtl -lhbziparc -lhblang -lhbcommon -lhbnulrdd -lrddntx -lrddcdx -lrddfpt -lhbct -lhbmisc -lxhb -lhbodbc -lrddsql -lsddodbc -lodbc32 -lhbmysql %THR_LIB% -lhbwin -lhbcpage -lhbmzip -lminizip -lhbzlib -lhbtip -lhbpcre -luser32 -lwinspool -lcomctl32 -lcomdlg32 -lgdi32 -lole32 -loleaut32 -luuid -lwinmm -lvfw32 -lwsock32 -lws2_32 -Wl,--end-group
if not exist %1.rc gcc -Wall -o%1.exe %1.o %ooHG_INSTALL%\resources\ooHG.o -L%MINGW%\lib -L%HRB_DIR%\%LIB_HRB% -L%ooHG_INSTALL%\%LIB_GUI% -Wl,--start-group -lgtgui -lgtwin -lhbsix -lhbvm -lhbrdd -lhbmacro -lhbmemio -lhbpp -lhbrtl -lhbziparc -lhblang -lhbcommon -lhbnulrdd -lrddntx -lrddcdx -lrddfpt -lhbct -lhbmisc -lxhb -lhbodbc -lrddsql -lsddodbc -lodbc32 -lhbmysql %THR_LIB% -lhbwin -lhbcpage -lhbmzip -lminizip -lhbzlib -lhbtip -lhbpcre -luser32 -lwinspool -lcomctl32 -lcomdlg32 -lgdi32 -lole32 -loleaut32 -luuid -lwinmm -lvfw32 -lwsock32 -lws2_32 -Wl,--end-group


goto END_COMPILE

:STD_COMP

%HRB_DIR%\%BIN_HRB%\harbour %1.prg -n %EXTRA% -i%HRB_DIR%\include;%ooHG_INSTALL%\include;.
rem gcc -I. -I%HRB_DIR%\include -I%ooHG_INSTALL%\include -mno-cygwin -Wall -c %1.c -o%1.o
gcc -I. -I%HRB_DIR%\include -I%ooHG_INSTALL%\include -Wall -c %1.c -o%1.o

rem if     exist %1.rc gcc -Wall -o%1.exe %1.o %ooHG_INSTALL%\resources\_temp.o                         -mwindows -L%MINGW%\lib -L%HRB_DIR%\%LIB_HRB% -L%ooHG_INSTALL%\%LIB_GUI% -mno-cygwin -Wl,--start-group -looHG -lhbprinter -lminiprint -lgtgui -lhbsix -lhbvm -lhbrdd -lhbmacro -lhbmemio -lhbpp -lhbrtl -lhbziparc -lhblang -lhbcommon -lhbnulrdd -lrddntx -lrddcdx -lrddfpt -lhbct -lhbmisc -lxhb -lhbodbc -lrddsql -lsddodbc -lodbc32 -lhbmysql %THR_LIB% -lhbwin -lhbcpage -lhbmzip -lminizip -lhbzlib -lhbtip -lhbpcre -luser32 -lwinspool -lcomctl32 -lcomdlg32 -lgdi32 -lole32 -loleaut32 -luuid -lwinmm -lvfw32 -lwsock32 -lws2_32 -Wl,--end-group
rem if not exist %1.rc gcc -Wall -o%1.exe %1.o %ooHG_INSTALL%\resources\ooHG.o -mwindows -L%MINGW%\lib -L%HRB_DIR%\%LIB_HRB% -L%ooHG_INSTALL%\%LIB_GUI% -mno-cygwin -Wl,--start-group -looHG -lhbprinter -lminiprint -lgtgui -lhbsix -lhbvm -lhbrdd -lhbmacro -lhbmemio -lhbpp -lhbrtl -lhbziparc -lhblang -lhbcommon -lhbnulrdd -lrddntx -lrddcdx -lrddfpt -lhbct -lhbmisc -lxhb -lhbodbc -lrddsql -lsddodbc -lodbc32 -lhbmysql %THR_LIB% -lhbwin -lhbcpage -lhbmzip -lminizip -lhbzlib -lhbtip -lhbpcre -luser32 -lwinspool -lcomctl32 -lcomdlg32 -lgdi32 -lole32 -loleaut32 -luuid -lwinmm -lvfw32 -lwsock32 -lws2_32 -Wl,--end-group

if     exist %1.rc gcc -Wall -o%1.exe %1.o %ooHG_INSTALL%\resources\_temp.o                         -mwindows -L%MINGW%\lib -L%HRB_DIR%\%LIB_HRB% -L%ooHG_INSTALL%\%LIB_GUI% -Wl,--start-group -looHG -lhbprinter -lminiprint -lgtgui -lhbsix -lhbvm -lhbrdd -lhbmacro -lhbmemio -lhbpp -lhbrtl -lhbziparc -lhblang -lhbcommon -lhbnulrdd -lrddntx -lrddcdx -lrddfpt -lhbct -lhbmisc -lxhb -lhbodbc -lrddsql -lsddodbc -lodbc32 -lhbmysql %THR_LIB% -lhbwin -lhbcpage -lhbmzip -lminizip -lhbzlib -lhbtip -lhbpcre -luser32 -lwinspool -lcomctl32 -lcomdlg32 -lgdi32 -lole32 -loleaut32 -luuid -lwinmm -lvfw32 -lwsock32 -lws2_32 -Wl,--end-group
if not exist %1.rc gcc -Wall -o%1.exe %1.o %ooHG_INSTALL%\resources\ooHG.o -mwindows -L%MINGW%\lib -L%HRB_DIR%\%LIB_HRB% -L%ooHG_INSTALL%\%LIB_GUI% -Wl,--start-group -looHG -lhbprinter -lminiprint -lgtgui -lhbsix -lhbvm -lhbrdd -lhbmacro -lhbmemio -lhbpp -lhbrtl -lhbziparc -lhblang -lhbcommon -lhbnulrdd -lrddntx -lrddcdx -lrddfpt -lhbct -lhbmisc -lxhb -lhbodbc -lrddsql -lsddodbc -lodbc32 -lhbmysql %THR_LIB% -lhbwin -lhbcpage -lhbmzip -lminizip -lhbzlib -lhbtip -lhbpcre -luser32 -lwinspool -lcomctl32 -lcomdlg32 -lgdi32 -lole32 -loleaut32 -luuid -lwinmm -lvfw32 -lwsock32 -lws2_32 -Wl,--end-group


goto END_COMPILE

:DEBUG_COMP

echo OPTIONS NORUNATSTARTUP > init.cld

%HRB_DIR%\%BIN_HRB%\harbour %1.prg -n %EXTRA% -b -i%HRB_DIR%\include;%ooHG_INSTALL%\include;.
rem gcc -I. -I%HRB_DIR%\include -I%ooHG_INSTALL%\include -mno-cygwin -Wall -c %1.c -o%1.o
gcc -I. -I%HRB_DIR%\include -I%ooHG_INSTALL%\include -Wall -c %1.c -o%1.o

rem if     exist %1.rc gcc -Wall -o%1.exe %1.o %ooHG_INSTALL%\resources\_temp.o                         -L%MINGW%\lib -L%HRB_DIR%\%LIB_DIR% -L%ooHG_INSTALL%\%LIB_GUI% -mno-cygwin -Wl,--start-group -looHG -lhbprinter -lminiprint -lhbdebug -lgtgui -lgtwin -lhbsix -lhbvm -lhbrdd -lhbmacro -lhbmemio -lhbpp -lhbrtl -lhbziparc -lhblang -lhbcommon -lhbnulrdd -lrddntx -lrddcdx -lrddfpt -lhbct -lhbmisc -lxhb -lhbodbc -lrddsql -lsddodbc -lodbc32 -lhbmysql %THR_LIB% -lhbwin -lhbcpage -lhbmzip -lminizip -lhbzlib -lhbtip -lhbpcre -luser32 -lwinspool -lcomctl32 -lcomdlg32 -lgdi32 -lole32 -loleaut32 -luuid -lwinmm -lvfw32 -lwsock32 -lws2_32 -Wl,--end-group
rem if not exist %1.rc gcc -Wall -o%1.exe %1.o %ooHG_INSTALL%\resources\ooHG.o -L%MINGW%\lib -L%HRB_DIR%\%LIB_DIR% -L%ooHG_INSTALL%\%LIB_GUI% -mno-cygwin -Wl,--start-group -looHG -lhbprinter -lminiprint -lhbdebug -lgtgui -lgtwin -lhbsix -lhbvm -lhbrdd -lhbmacro -lhbmemio -lhbpp -lhbrtl -lhbziparc -lhblang -lhbcommon -lhbnulrdd -lrddntx -lrddcdx -lrddfpt -lhbct -lhbmisc -lxhb -lhbodbc -lrddsql -lsddodbc -lodbc32 -lhbmysql %THR_LIB% -lhbwin -lhbcpage -lhbmzip -lminizip -lhbzlib -lhbtip -lhbpcre -luser32 -lwinspool -lcomctl32 -lcomdlg32 -lgdi32 -lole32 -loleaut32 -luuid -lwinmm -lvfw32 -lwsock32 -lws2_32 -Wl,--end-group

if     exist %1.rc gcc -Wall -o%1.exe %1.o %ooHG_INSTALL%\resources\_temp.o                         -L%MINGW%\lib -L%HRB_DIR%\%LIB_DIR% -L%ooHG_INSTALL%\%LIB_GUI% -Wl,--start-group -looHG -lhbprinter -lminiprint -lhbdebug -lgtgui -lgtwin -lhbsix -lhbvm -lhbrdd -lhbmacro -lhbmemio -lhbpp -lhbrtl -lhbziparc -lhblang -lhbcommon -lhbnulrdd -lrddntx -lrddcdx -lrddfpt -lhbct -lhbmisc -lxhb -lhbodbc -lrddsql -lsddodbc -lodbc32 -lhbmysql %THR_LIB% -lhbwin -lhbcpage -lhbmzip -lminizip -lhbzlib -lhbtip -lhbpcre -luser32 -lwinspool -lcomctl32 -lcomdlg32 -lgdi32 -lole32 -loleaut32 -luuid -lwinmm -lvfw32 -lwsock32 -lws2_32 -Wl,--end-group
if not exist %1.rc gcc -Wall -o%1.exe %1.o %ooHG_INSTALL%\resources\ooHG.o -L%MINGW%\lib -L%HRB_DIR%\%LIB_DIR% -L%ooHG_INSTALL%\%LIB_GUI% -Wl,--start-group -looHG -lhbprinter -lminiprint -lhbdebug -lgtgui -lgtwin -lhbsix -lhbvm -lhbrdd -lhbmacro -lhbmemio -lhbpp -lhbrtl -lhbziparc -lhblang -lhbcommon -lhbnulrdd -lrddntx -lrddcdx -lrddfpt -lhbct -lhbmisc -lxhb -lhbodbc -lrddsql -lsddodbc -lodbc32 -lhbmysql %THR_LIB% -lhbwin -lhbcpage -lhbmzip -lminizip -lhbzlib -lhbtip -lhbpcre -luser32 -lwinspool -lcomctl32 -lcomdlg32 -lgdi32 -lole32 -loleaut32 -luuid -lwinmm -lvfw32 -lwsock32 -lws2_32 -Wl,--end-group


:END_COMPILE

del %1.c
del %1.o
if exist %ooHG_INSTALL%\resources\_temp.rc del %ooHG_INSTALL%\resources\_temp.rc
if exist %ooHG_INSTALL%\resources\_temp.o del %ooHG_INSTALL%\resources\_temp.o
if exist %ooHG_INSTALL%\resources\_oohg_resconfig.h del %ooHG_INSTALL%\resources\_oohg_resconfig.h
set PATH=%TPATH%
set TPATH=

if exist %1.exe %1.exe

if exist init.cld del init.cld

goto ENDBATCH

:ERREXIT

echo COMPILE ERROR: IS %1.EXE RUNNING ?

:ENDBATCH
